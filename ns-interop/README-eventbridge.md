# EventBridge Scenario

This guide documents the `Demo.EventBridge` interoperability scenario.

The scenario simulates a common HIS-to-PACS pattern:

- an external HIS stores pending integration requests in MySQL
- IRIS polls `external_his.IntegrationRequest`
- IRIS builds a canonical `Demo.EventBridge.Msg.InteropRequest`
- IRIS routes the canonical request based on `TargetSystem`
- IRIS enriches the request with patient, visit, and order data
- IRIS transforms the request into HL7 v2
- IRIS sends the HL7 message to a simulated PACS file destination

The reverse PACS-to-HIS path uses:

- an inbound `ORU^R01` HL7 router
- a PACS-to-HIS business process
- a SOAP web client generated from the HIS WSDL

## Production

- Open [Demo.EventBridge.Production](http://localhost:52773/csp/healthshare/interop/EnsPortal.ProductionConfig.zen?PRODUCTION=Demo.EventBridge.Production)
- Main poller: `HIS Pending Request In`
- Router: `EventBridge Router`
- PACS-specific process: `HIS PACS Process`
- SQL outbound BO: `HIS SQL Out`
- Simulated PACS target: `PACS HL7 File Out`
- Reverse HL7 input: `PACS HL7 File In`
- Reverse HL7 router: `PACS HL7 Router In`
- Reverse SOAP process: `PACS HIS Process`
- Reverse SOAP target: `HIS Report SOAP Out`

The poller uses the SQL inbound adapter `Query` plus `DeleteQuery` to claim fetched rows immediately by updating them from `PENDING` to `PROCESSING`.
The SQL outbound BO uses its `MessageMap` to dispatch one detail-enrichment call and the final status update behavior.

## MySQL Data

The external HIS simulation lives in the `external_his` schema.

Relevant tables:

- `external_his.IntegrationRequest`
- `external_his.Patient`
- `external_his.Visit`
- `external_his.RadiologyOrder`

Seed rows include:

- one pending `ADT_A08` patient demographic update
- one pending `ORM_O01` radiology order

To inspect the schema directly:

```bash
docker exec -it mysqlh bash
mysql --host=localhost --user=testuser external_his -p  # Password: testpassword
```

```sql
SELECT * FROM external_his.IntegrationRequest;
SELECT * FROM external_his.Patient;
SELECT * FROM external_his.Visit;
SELECT * FROM external_his.RadiologyOrder;
```

## Canonical Message

The scenario uses `Demo.EventBridge.Msg.InteropInfo` as the reusable canonical payload, wrapped by:

- `Demo.EventBridge.Msg.InteropRequest`
- `Demo.EventBridge.Msg.InteropResponse`

The canonical payload carries:

- request metadata such as request type, source, target, and event timestamp
- patient data
- visit data
- order data when present

## HL7 Transforms

The scenario demonstrates reusable subtransforms:

- `Demo.EventBridge.DT.Segment.InteropRequestToMSH`
- `Demo.EventBridge.DT.Segment.InteropRequestToPID`
- `Demo.EventBridge.DT.Segment.InteropRequestToPV1`

These are reused by the two top-level transforms:

- `Demo.EventBridge.DT.PACS.InteropRequestToADTA08`
- `Demo.EventBridge.DT.PACS.InteropRequestToORMO01`

Message-specific segments are handled directly inside the PACS transforms:

- `EVN` inside `Demo.EventBridge.DT.PACS.InteropRequestToADTA08`
- `PV1`, `ORC` and `OBR` inside `Demo.EventBridge.DT.PACS.InteropRequestToORMO01`

## SOAP Client Generation

The reverse path uses SOAP client classes generated from the HIS demo web service WSDL.

In VS Code use the SOAP wizard with these values:

- `VSCode -> Soap wizard`
- `File: /app/install/EventBridgeHISReportService.wsdl`
- `Proxy class package: Demo.EventBridge.HIS.WSC`
- `Create Business Operation: yes`
- `Business Operation Package: Demo.EventBridge.HIS.WSC.BO`
- `Request Object Package: Demo.EventBridge.HIS.WSC.Msg`
- `Response Object Package: Demo.EventBridge.HIS.WSC.Msg`

Generated classes live under:

- `Demo.EventBridge.HIS.WSC`
- `Demo.EventBridge.HIS.WSC.BO`
- `Demo.EventBridge.HIS.WSC.Msg`

## Reverse Flow

The reverse path demonstrates a simple PACS-to-HIS report flow:

- `PACS HL7 File In` reads inbound `ORU^R01` messages from `samples/eventbridge/in/`
- `PACS HL7 Router In` dispatches `ORU^R01` messages to `PACS HIS Process`
- `Demo.EventBridge.PACS.DT.HIS.ORUR01ToSubmitReportRequest` maps the HL7 report to the generated SOAP request
- `HIS Report SOAP Out` calls the HIS SOAP service in the `USER` namespace

Relevant classes:

- `Demo.EventBridge.PACS.Rule.RouterIn`
- `Demo.EventBridge.PACS.BP.HISReportProcess`
- `Demo.EventBridge.PACS.DT.HIS.ORUR01ToSubmitReportRequest`
- `Demo.EventBridge.HIS.WSC.BO.ReportServiceSoap`

## Output

Generated HL7 files are written to [samples/eventbridge/out/](../samples/eventbridge/out/).
