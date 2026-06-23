# ns-interop

This folder contains the main interoperability implementation for the workshop's REST-to-HL7 Lab Workflow scenario.

- `src/Demo/LabWorkflow/HIS` contains the HIS-side REST API, message classes, data transforms, and process logic
- `src/Demo/LabWorkflow/LAB` contains the LAB-side router, validation, message classes, and result processing
- `src/Demo/Util` contains utility classes shared across interoperability scenarios

Relevant workshop areas:

- Scenario 1 in the top-level [README.md](../README.md)
- sample requests in [http/labworkflow-orders.http](../http/labworkflow-orders.http)
- sample HL7 result messages in [samples/](../samples/)
