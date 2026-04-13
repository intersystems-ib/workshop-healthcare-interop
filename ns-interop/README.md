# ns-interop

This folder contains the main interoperability implementation for the workshop's HIS to LAB scenario.

- `src/Demo/HIS` contains the HIS-side REST API, message classes, data transforms, and process logic
- `src/Demo/LAB` contains the LAB-side router, validation, message classes, and result processing
- `src/Demo/Util` contains utility classes used by the interoperability flow

Relevant workshop areas:

- Scenario 1 in the top-level [README.md](../README.md)
- sample requests in [http/his-orders.http](../http/his-orders.http)
- sample HL7 result messages in [test/](../test/)
