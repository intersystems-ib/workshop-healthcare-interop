# EventBridge Samples

This folder contains runtime files for the `Demo.EventBridge` scenario.

- `in/` is the inbound folder read by `Demo.Backend.Production` before forwarding messages to `PACS TCP In`
- `inarchive/` stores processed inbound PACS files
- `out/` is the simulated PACS destination folder written by `Demo.Backend.Production`
- `ORUR01_ImagingReport.hl7` is a sample PACS result file you can copy into `in/`
