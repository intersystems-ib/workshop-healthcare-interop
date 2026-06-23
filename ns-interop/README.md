# ns-interop

This folder contains the interoperability implementation for the workshop's Lab Workflow and EventBridge scenarios.

- `src/Demo/LabWorkflow/HIS` contains the HIS-side REST API, message classes, data transforms, and process logic
- `src/Demo/LabWorkflow/LAB` contains the LAB-side router, validation, message classes, and result processing
- `src/Demo/EventBridge` contains the SQL polling, canonical message, routing, and HL7 generation flow for the EventBridge scenario
- `src/Demo/Util` contains utility classes shared across interoperability scenarios

Relevant workshop areas:

- Scenario 1 in the top-level [README.md](../README.md)
- EventBridge walkthrough in [README-eventbridge.md](./README-eventbridge.md)
- sample requests in [http/labworkflow-orders.http](../http/labworkflow-orders.http)
- sample HL7 result messages in [samples/](../samples/)
