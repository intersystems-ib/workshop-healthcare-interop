# LabWorkflow Samples

This folder contains runtime files for the `Demo.LabWorkflow` scenario.

- `in/` is the inbound folder read by `Demo.Backend.Production` before forwarding messages to `LAB TCP In`
- `inarchive/` stores processed inbound lab result files
- `out/` is the simulated LAB destination folder written by `Demo.Backend.Production`
- copy the starter `ORUR01_*.hl7` files into `in/` to simulate incoming results
