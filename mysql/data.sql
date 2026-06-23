-- Workshop demo data is split by scenario:
-- - labworkflow: current lab order / result scenario
-- - external_his: EventBridge scenario simulating an external HIS database
CREATE SCHEMA IF NOT EXISTS labworkflow;
CREATE SCHEMA IF NOT EXISTS external_his;

-- Reference catalog used by the LabWorkflow scenario.
CREATE TABLE labworkflow.TestCatalog (
  id INT AUTO_INCREMENT PRIMARY KEY,
  Code VARCHAR(10) NOT NULL UNIQUE,
  Name VARCHAR(100) NOT NULL,
  Description TEXT,
  IsActive BOOLEAN NOT NULL DEFAULT TRUE
);

-- sample Lab Workflow catalog data
INSERT INTO labworkflow.TestCatalog (code, name, description, isactive) VALUES
('GLU', 'Glucose', 'Blood glucose test to measure sugar levels.', TRUE),
('CBC', 'Complete Blood Count', 'Measures components of blood including red and white cells.', TRUE),
('CRP', 'C-Reactive Protein', 'Detects inflammation in the body.', TRUE),
('TSH', 'Thyroid Stimulating Hormone', 'Assesses thyroid function.', FALSE),
('LIP', 'Lipid Panel', 'Measures cholesterol and triglycerides.', TRUE);

GRANT ALL PRIVILEGES ON labworkflow.* TO 'testuser'@'%';
GRANT ALL PRIVILEGES ON external_his.* TO 'testuser'@'%';

-- EventBridge demo:
-- The external_his schema simulates pending interoperability events waiting
-- to be consumed by IRIS and transformed into HL7 v2 messages.

-- Core patient demographics used by both ADT and ORM requests.
CREATE TABLE external_his.Patient (
  PatientId VARCHAR(36) PRIMARY KEY,
  MRN VARCHAR(20) NOT NULL UNIQUE,
  AssigningAuthority VARCHAR(20) NOT NULL,
  LastName VARCHAR(80) NOT NULL,
  FirstName VARCHAR(80) NOT NULL,
  MiddleName VARCHAR(80),
  BirthDate DATE NOT NULL,
  Sex VARCHAR(1) NOT NULL,
  PhoneNumber VARCHAR(30),
  AddressLine1 VARCHAR(120),
  City VARCHAR(80),
  StateCode VARCHAR(10),
  PostalCode VARCHAR(20)
);

-- Visit / encounter context used to populate PV1.
CREATE TABLE external_his.Visit (
  VisitId VARCHAR(36) PRIMARY KEY,
  PatientId VARCHAR(36) NOT NULL,
  VisitNumber VARCHAR(30) NOT NULL UNIQUE,
  PatientClass VARCHAR(2) NOT NULL,
  AssignedLocation VARCHAR(40),
  Room VARCHAR(20),
  Bed VARCHAR(20),
  AttendingId VARCHAR(30),
  AttendingLastName VARCHAR(80),
  AttendingFirstName VARCHAR(80),
  AdmitDateTime DATETIME,
  FOREIGN KEY (PatientId) REFERENCES external_his.Patient(PatientId)
);

-- Simplified radiology order data used for ORM^O01 generation.
CREATE TABLE external_his.RadiologyOrder (
  OrderId VARCHAR(36) PRIMARY KEY,
  VisitId VARCHAR(36) NOT NULL,
  PlacerOrderNumber VARCHAR(30) NOT NULL UNIQUE,
  FillerOrderNumber VARCHAR(30),
  ServiceCode VARCHAR(20) NOT NULL,
  ServiceText VARCHAR(120) NOT NULL,
  PriorityCode VARCHAR(10) NOT NULL,
  OrderingProviderId VARCHAR(30),
  OrderingProviderLastName VARCHAR(80),
  OrderingProviderFirstName VARCHAR(80),
  RequestedDateTime DATETIME NOT NULL,
  Modality VARCHAR(20),
  ReasonText VARCHAR(255),
  FOREIGN KEY (VisitId) REFERENCES external_his.Visit(VisitId)
);

-- Queue of pending outbound integration events polled by IRIS.
-- Status values used in the demo are typically PENDING, PROCESSING, SENT, ERROR.
CREATE TABLE external_his.IntegrationRequest (
  RequestId VARCHAR(36) PRIMARY KEY,
  RequestType VARCHAR(20) NOT NULL,
  SourceSystem VARCHAR(40) NOT NULL,
  TargetSystem VARCHAR(40) NOT NULL,
  PatientId VARCHAR(36) NOT NULL,
  VisitId VARCHAR(36) NOT NULL,
  OrderId VARCHAR(36),
  EventDateTime DATETIME NOT NULL,
  Status VARCHAR(20) NOT NULL,
  ErrorText TEXT,
  CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UpdatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  ProcessedAt DATETIME,
  FOREIGN KEY (PatientId) REFERENCES external_his.Patient(PatientId),
  FOREIGN KEY (VisitId) REFERENCES external_his.Visit(VisitId),
  FOREIGN KEY (OrderId) REFERENCES external_his.RadiologyOrder(OrderId)
);

-- Seed patients:
-- - PAT-EB-1001 is used by the ADT_A08 request
-- - PAT-EB-1002 is used by the ORM_O01 request
INSERT INTO external_his.Patient (
  PatientId, MRN, AssigningAuthority, LastName, FirstName, MiddleName, BirthDate, Sex,
  PhoneNumber, AddressLine1, City, StateCode, PostalCode
) VALUES
('PAT-EB-1001', 'MRN-EB-1001', 'HISDB', 'Navarro', 'Elena', 'Maria', '1982-04-19', 'F', '+34-600-100-100', 'Calle Mayor 10', 'Madrid', 'MD', '28001'),
('PAT-EB-1002', 'MRN-EB-1002', 'HISDB', 'Ortega', 'Luis', 'Alberto', '1974-11-03', 'M', '+34-600-200-200', 'Avenida Norte 55', 'Madrid', 'MD', '28015');

-- One visit per seeded patient keeps the workshop flow easy to follow.
INSERT INTO external_his.Visit (
  VisitId, PatientId, VisitNumber, PatientClass, AssignedLocation, Room, Bed,
  AttendingId, AttendingLastName, AttendingFirstName, AdmitDateTime
) VALUES
('VIS-EB-2001', 'PAT-EB-1001', 'VN-EB-2001', 'O', 'RAD^01^A', '01', 'A', 'DOC-100', 'Santos', 'Irene', '2026-06-20 09:15:00'),
('VIS-EB-2002', 'PAT-EB-1002', 'VN-EB-2002', 'O', 'RAD^02^B', '02', 'B', 'DOC-200', 'Molina', 'Javier', '2026-06-22 11:00:00');

-- Only the ORM request needs an order row.
INSERT INTO external_his.RadiologyOrder (
  OrderId, VisitId, PlacerOrderNumber, FillerOrderNumber, ServiceCode, ServiceText,
  PriorityCode, OrderingProviderId, OrderingProviderLastName, OrderingProviderFirstName,
  RequestedDateTime, Modality, ReasonText
) VALUES
('ORD-EB-3001', 'VIS-EB-2002', 'PO-EB-3001', 'FO-EB-3001', 'XRCH', 'Chest X-Ray',
 'ROUTINE', 'DOC-300', 'Ruiz', 'Clara', '2026-06-23 08:45:00', 'CR', 'Persistent cough and follow-up imaging');

-- Seed pending events consumed by the EventBridge SQL poller:
-- - ADT_A08: patient demographic update
-- - ORM_O01: radiology order to PACS
INSERT INTO external_his.IntegrationRequest (
  RequestId, RequestType, SourceSystem, TargetSystem, PatientId, VisitId, OrderId,
  EventDateTime, Status, ErrorText, CreatedAt, UpdatedAt, ProcessedAt
) VALUES
('REQ-EB-4001', 'ADT_A08', 'EXT_HIS', 'PACS', 'PAT-EB-1001', 'VIS-EB-2001', NULL,
 '2026-06-23 08:05:00', 'PENDING', NULL, '2026-06-23 08:05:00', '2026-06-23 08:05:00', NULL),
('REQ-EB-4002', 'ORM_O01', 'EXT_HIS', 'PACS', 'PAT-EB-1002', 'VIS-EB-2002', 'ORD-EB-3001',
 '2026-06-23 08:10:00', 'PENDING', NULL, '2026-06-23 08:10:00', '2026-06-23 08:10:00', NULL);

FLUSH PRIVILEGES;
