USE external_his;

-- Use this file to inspect the HIS-side tables, add demo rows,
-- and reset IntegrationRequest rows back to PENDING for reprocessing.

-- ---------------------------------------------------------------------------
-- Quick inspection queries
-- ---------------------------------------------------------------------------

SELECT *
FROM external_his.IntegrationRequest
ORDER BY CreatedAt DESC;

SELECT
  ir.RequestId,
  ir.RequestType,
  ir.TargetSystem,
  ir.Status,
  ir.EventDateTime,
  p.MRN,
  CONCAT(p.LastName, ', ', p.FirstName) AS PatientName,
  v.VisitNumber,
  ro.PlacerOrderNumber,
  ro.ServiceCode,
  ro.ServiceText
FROM external_his.IntegrationRequest ir
JOIN external_his.Patient p
  ON p.PatientId = ir.PatientId
JOIN external_his.Visit v
  ON v.VisitId = ir.VisitId
LEFT JOIN external_his.RadiologyOrder ro
  ON ro.OrderId = ir.OrderId
ORDER BY ir.CreatedAt DESC;

SELECT *
FROM external_his.Patient
ORDER BY PatientId;

SELECT *
FROM external_his.Visit
ORDER BY VisitId;

SELECT *
FROM external_his.RadiologyOrder
ORDER BY OrderId;

-- ---------------------------------------------------------------------------
-- Reset rows so IRIS can pick them up again
-- ---------------------------------------------------------------------------

-- Reset every EventBridge request to PENDING.
UPDATE external_his.IntegrationRequest
SET Status = 'PENDING',
    ErrorText = NULL,
    ProcessedAt = NULL,
    UpdatedAt = NOW()
WHERE RequestId LIKE 'REQ-EB-%';

-- ---------------------------------------------------------------------------
-- Add new demo events using existing seeded patient / visit / order rows
-- ---------------------------------------------------------------------------

-- New ADT_A08 for the first seeded patient.
INSERT INTO external_his.IntegrationRequest (
  RequestId, RequestType, SourceSystem, TargetSystem, PatientId, VisitId, OrderId,
  EventDateTime, Status, ErrorText, CreatedAt, UpdatedAt, ProcessedAt
) VALUES (
  'REQ-EB-4101', 'ADT_A08', 'EXT_HIS', 'PACS', 'PAT-EB-1001', 'VIS-EB-2001', NULL,
  NOW(), 'PENDING', NULL, NOW(), NOW(), NULL
);

-- New ORM_O01 for the seeded radiology order.
INSERT INTO external_his.IntegrationRequest (
  RequestId, RequestType, SourceSystem, TargetSystem, PatientId, VisitId, OrderId,
  EventDateTime, Status, ErrorText, CreatedAt, UpdatedAt, ProcessedAt
) VALUES (
  'REQ-EB-4102', 'ORM_O01', 'EXT_HIS', 'PACS', 'PAT-EB-1002', 'VIS-EB-2002', 'ORD-EB-3001',
  NOW(), 'PENDING', NULL, NOW(), NOW(), NULL
);

-- ---------------------------------------------------------------------------
-- Template to create a brand new patient, visit, order, and outbound request
-- ---------------------------------------------------------------------------

-- 1. Insert patient
INSERT INTO external_his.Patient (
  PatientId, MRN, AssigningAuthority, LastName, FirstName, MiddleName, BirthDate, Sex,
  PhoneNumber, AddressLine1, City, StateCode, PostalCode
) VALUES (
  'PAT-EB-1100', 'MRN-EB-1100', 'HISDB', 'Lopez', 'Ana', NULL, '1990-02-14', 'F',
  '+34-600-300-300', 'Gran Via 100', 'Madrid', 'MD', '28013'
);

-- 2. Insert visit
INSERT INTO external_his.Visit (
  VisitId, PatientId, VisitNumber, PatientClass, AssignedLocation, Room, Bed,
  AttendingId, AttendingLastName, AttendingFirstName, AdmitDateTime
) VALUES (
  'VIS-EB-2100', 'PAT-EB-1100', 'VN-EB-2100', 'O', 'RAD^03^A', '03', 'A',
  'DOC-310', 'Martin', 'Laura', NOW()
);

-- 3. Insert radiology order
INSERT INTO external_his.RadiologyOrder (
  OrderId, VisitId, PlacerOrderNumber, FillerOrderNumber, ServiceCode, ServiceText,
  PriorityCode, OrderingProviderId, OrderingProviderLastName, OrderingProviderFirstName,
  RequestedDateTime, Modality, ReasonText
) VALUES (
  'ORD-EB-3100', 'VIS-EB-2100', 'PO-EB-3100', 'FO-EB-3100', 'CTABD', 'CT Abdomen',
  'ROUTINE', 'DOC-320', 'Garcia', 'Pablo', NOW(), 'CT', 'Abdominal pain'
);

-- 4. Insert integration request
INSERT INTO external_his.IntegrationRequest (
  RequestId, RequestType, SourceSystem, TargetSystem, PatientId, VisitId, OrderId,
  EventDateTime, Status, ErrorText, CreatedAt, UpdatedAt, ProcessedAt
) VALUES (
  'REQ-EB-4103', 'ORM_O01', 'EXT_HIS', 'PACS', 'PAT-EB-1100', 'VIS-EB-2100', 'ORD-EB-3100',
  NOW(), 'PENDING', NULL, NOW(), NOW(), NULL
);
