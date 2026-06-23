# samples

This folder contains sample HL7 payloads and working directories used by the workshop.

- `ORUR01_*.hl7` are starter HL7 ORU^R01 messages you can copy into `in/`
- `in/` is the inbound watch folder used to simulate lab result delivery
- `inarchive/` stores processed inbound files
- `out/` stores generated output files from the Lab Workflow scenario
- `eventbridge/out/` stores generated PACS HL7 output from the EventBridge scenario
- `xml/` contains XML representations of the sample HL7 messages
- `other/` contains auxiliary sample files used by the workshop content

For the lab result simulation flow, see Scenario 1 in [README.md](../README.md). For the SQL polling PACS flow, see [ns-interop/README-eventbridge.md](../ns-interop/README-eventbridge.md).
