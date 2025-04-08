CREATE TABLE TestCatalog (
  id INT AUTO_INCREMENT PRIMARY KEY,
  Code VARCHAR(10) NOT NULL UNIQUE,
  Name VARCHAR(100) NOT NULL,
  Description TEXT,
  IsActive BOOLEAN NOT NULL DEFAULT TRUE
);

-- sample data
INSERT INTO TestCatalog (code, name, description, isactive) VALUES
('GLU', 'Glucose', 'Blood glucose test to measure sugar levels.', TRUE),
('CBC', 'Complete Blood Count', 'Measures components of blood including red and white cells.', TRUE),
('CRP', 'C-Reactive Protein', 'Detects inflammation in the body.', TRUE),
('TSH', 'Thyroid Stimulating Hormone', 'Assesses thyroid function.', FALSE),
('LIP', 'Lipid Panel', 'Measures cholesterol and triglycerides.', TRUE);
