CREATE SCHEMA IF NOT EXISTS labworkflow;
CREATE SCHEMA IF NOT EXISTS external_his;

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
FLUSH PRIVILEGES;
