# 🏥 Workshop: Intro to Healthcare Interoperability

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](./LICENSE) [![Docker Ready](https://img.shields.io/badge/docker-ready-blue)](https://www.docker.com/) [![VS Code Compatible](https://img.shields.io/badge/VS%20Code-Compatible-blueviolet)](https://code.visualstudio.com/) [![Maintained](https://img.shields.io/badge/status-maintained-brightgreen)](#) [![InterSystems IRIS](https://img.shields.io/badge/Powered%20by-InterSystems%20IRIS-ff69b4)](https://www.intersystems.com/iris)

Welcome to this hands-on workshop designed to help you explore **InterSystems IRIS for Health** and its powerful **Interoperability Framework** through real-world healthcare integration scenarios.

🔗 For extended learning, check out [InterSystems Learning](https://learning.intersystems.com).  
🖼️ Interested in imaging workflows? Visit our [DICOM Interop Workshop](https://github.com/intersystems-ib/workshop-iris-dicom-interop).

---

## 🧰 Requirements

Before you begin, make sure you have the following tools installed:

- [Git](https://git-scm.com/downloads)  
- [Docker & Docker Compose](https://docs.docker.com/compose/install/)  - ⚠️ On **Windows**, Docker must be set to use **Linux containers**  
- [Visual Studio Code](https://code.visualstudio.com/download) with:
  - the [InterSystems ObjectScript Extension Pack](https://marketplace.visualstudio.com/items?itemName=intersystems-community.objectscript-pack)
  - the [REST Client extension](https://marketplace.visualstudio.com/items?itemName=humao.rest-client)

---

## 🚀 Getting Started

Clone this repo and spin up the environment with Docker Compose:

```bash
git clone https://github.com/intersystems-ib/workshop-healthcare-interop
cd workshop-healthcare-interop
docker compose build
docker compose up -d
```

Open the `workshop-healthcare-interop` folder in **VS Code** to explore the source.

### ✅ Quick Start

After `docker compose up -d`, use these entrypoints to verify the workshop is ready:

1. Open the [Management Portal](http://localhost:52773/csp/sys/UtilHome.csp) and log in with `superuser` / `SYS`
2. Send a sample HIS order from [http/his-orders.http](./http/his-orders.http)
3. Configure the FHIR server as described below, then run [http/fhir-repository.http](./http/fhir-repository.http)
4. Optionally open [JupyterLab](http://localhost:8888/lab/tree/IRISPython.ipynb)

What is automatic after `docker compose up -d`:

- IRIS, MySQL, and Jupyter containers are started
- Source code is mounted into the IRIS container

What is still manual:

- creating the FHIR server in the `FHIRREPO` namespace
- loading the sample FHIR resources
- exploring or starting the workshop scenarios from VS Code or the Management Portal

### 🗺️ Repo Map

- [http/](./http/) contains runnable VS Code REST Client requests for the workshop scenarios
- [ns-interop/](./ns-interop/) contains the interoperability classes for the HIS to LAB order and result flow
- [ns-fhirrepo/](./ns-fhirrepo/) contains FHIR repository and FHIR interoperability production code
- [ns-user/](./ns-user/) contains user namespace classes, including SOAP-related artifacts used in the workshop
- [install/](./install/) contains install-time assets such as roles, web app definitions, HL7 resources, sample FHIR data, and helper config files
- [test/](./test/) contains HL7 sample messages and input/output folders used to simulate inbound lab results
- [jupyter/](./jupyter/) contains the notebook environment used for FHIR SQL Builder exploration
- [mysql/](./mysql/) contains the sample external database used for test catalog validation
- [local/LOCAL.md](./local/LOCAL.md) documents a local customization used to expose an HL7 XML view in the portal

### 🔎 Validation Checklist

- [Management Portal](http://localhost:52773/csp/sys/UtilHome.csp) is reachable
- `POST /his/api/order` works via [http/his-orders.http](./http/his-orders.http)
- `GET /csp/healthshare/fhirrepo/fhir/r4/metadata` works via [http/fhir-repository.http](./http/fhir-repository.http) after FHIR setup
- [JupyterLab](http://localhost:8888/lab/tree/IRISPython.ipynb) is reachable

---

## 💡 Scenario 1: HIS Orders & Lab Results

### 🧾 Step 1: HIS Sends Order to LAB

<img src="./img/hl7-create-order.png" width="900px" />

>A Hospital Information System (HIS) sends a REST request to IRIS → IRIS validates the test code via an external SQL catalog → IRIS transforms the message into HL7 (ORM^O01) → Sends it to the Laboratory.

#### 🔍 Explore the Production

- Open the [Management Portal](http://localhost:52773/csp/sys/UtilHome.csp)  
- Login with: `superuser` / `SYS`
- Go to [Demo.OrderProduction](http://localhost:52773/csp/healthshare/interop/EnsPortal.ProductionConfig.zen?PRODUCTION=Demo.OrderProduction)

Explore:
- Components: Business Services, Processes, Operations
- Visual trace & connector lines
- Component settings and data flow

#### 🧪 Test the LAB Catalog Lookup

- Select the `LAB Catalog SQL` component. This is the component that runs a SQL query in an external DB to validate a test code.
- Use *Actions > Test* with message type: `Demo.LAB.Msg.CheckTestCatalogReq`
- Try codes like `GLU` or `CBC` and check the results

If you are interested in having a look at the the catalog DB directly:

```bash
docker exec -it mysqlh bash
mysql --host=localhost --user=testuser testdb -p  # Password: testpassword
```

```sql
SELECT * FROM TestCatalog;
```

#### 📤 Send an Order from HIS

Use the VS Code HTTP requests in [http/his-orders.http](./http/his-orders.http) or `curl` to create a new order from HIS:

```bash
curl -X POST http://localhost:52773/his/api/order \
  -H "Content-Type: application/json" \
  -d '{
  "msgId": "DDJ-20250408-001",
  "orderId": "ORD-20250408-001",
  "patient": {
    "mrn": "PAT-12345",
    "name": "Juan Perez",
    "birthDate": "1980-05-15",
    "gender": "male"
  },
  "practitioner": {
    "identifier": "DR-98765",
    "name": "Dr. Maria Gomez"
  },
  "orderDateTime": "2025-04-08T10:30:00Z",
  "test": {
      "code": "GLU",
      "description": "Blood glucose test",
      "priority": "routine"
   },
  "clinicalInfo": "Patient with dizziness and history of diabetes."
}'
```

Then:
- Open the [Message Viewer](http://localhost:52773/csp/healthshare/interop/EnsPortal.MessageViewer.zen)
- Inspect traces and data flow

#### ⚙️ Inspect the BPL Process & Data Transformations

- Click on `HIS Order Process` > magnifier icon next to *Class name*
- Inspect the **BPL** (Business Process Language) graphical flow

<img src="./img/his-order-process-bpl.png" width="400px" />

- Check *Transform* actions > Open **DTL Editor**
<img src="./img/data-transform.png" width="900px" />

---

### 📥 Step 2: LAB Sends Back Results

<img src="./img/hl7-send-result.png" width="900px" />

>The Laboratory sends the results back to IRIS using HL7 → IRIS processes the results and transforms the HL7 to a SOAP request that can be processed by the Hospital Information System (HIS) → Sends it to the Hospital.


#### 🔁 Simulate ORU^R01 Messages

- Copy `test/ORUR01_*` files into `test/in` directory
- Monitor message flow in [Message Viewer](http://localhost:52773/csp/healthshare/interop/EnsPortal.MessageViewer.zen)

#### 🧠 Understand HL7 Routing

- Open `LAB HL7 Router In`
- Check routing rules by clicking the magnifier next to *Business Rule Name*

<img src="./img/rule-editor.png" width="700px" />

---

## 📦 Scenario 2: FHIR Repository

Let’s persist and interact with FHIR resources via InterSystems IRIS for Health.

### 🏗️ Create a FHIR Server

In **Health > FHIRREPO > FHIR Configuration > Server Configuration**, define:

- Namespace: `FHIRREPO`
- Name: `fhirrepo`
- URL: `/csp/healthshare/fhirrepo/fhir/r4`
- Version: `FHIR R4`

<img src="./img/fhirrepo-create.png" width="700px" />

### 📥 Load FHIR Data

In [WebTerminal](http://localhost:52773/terminal/):

```objectscript
zn "FHIRREPO"
set sc = ##class(HS.FHIRServer.Tools.DataLoader).SubmitResourceFiles("/app/install/simple-fhir-data/", "FHIRServer", "/csp/healthshare/fhirrepo/fhir/r4")
```

<img src="./img/fhir-resource-loaded.png" width="700px" />

### 🔗 Interact via API

Use the VS Code HTTP requests in [http/fhir-repository.http](./http/fhir-repository.http): 
<img src="img/postman-fhir.png" width="900px"/>

or run this ObjectScript snippet to leverage pre-built clients:

```objectscript
set clientObj = ##class(HS.FHIRServer.RestClient.FHIRService).CreateInstance("/csp/healthshare/fhirrepo/fhir/r4")
do clientObj.SetResponseFormat("JSON")
set response = clientObj.Read("GET", "Patient", "10")
zwrite response.Json
```

---

## 🔄 FHIR Interoperability

You can also route FHIR requests through IRIS’ Interoperability engine and leverage all the framework power:

1. Go to [FHIR Server Management](http://localhost:52773/csp/fhir-management/index.html#/home)
2. Edit your server → In *FHIR Server Service Configuration*:
Set `InteropService` as your Service Config Name

Now, incoming FHIR requests will go through [fhirdemo.Production](http://localhost:52773/csp/healthshare/fhirrepo/EnsPortal.ProductionConfig.zen?PRODUCTION=fhirdemo.Production)

You can inspect all transactions in the [Message Viewer](http://localhost:52773/csp/healthshare/fhirrepo/EnsPortal.MessageViewer.zen).

---

## 📊 FHIR Analytics with FHIR SQL Builder

FHIR data is graph-based, but with **FHIR SQL Builder**, you can query it via SQL — no data duplication needed!

### Step 1: 🔍 Analyze Repository

- Open [FHIR SQL Builder UI](http://localhost:52773/csp/fhirsql/index.html#/)
- Create New Analysis:
  - Repository: `fhirrepo`, host: `localhost`, port: `52773`
  - Credentials: `superuser` / `SYS`
  - Endpoint: `/csp/healthshare/fhirrepo/fhir/r4`

### Step 2: 📐 Define SQL Projection

- Create a **Transformation Spec**
- Add paths like:
  - `Patient.gender`
  - `Observation.code.coding.code`
  - `Observation.valueQuantity.value`

<img src="img/fhirsqlbuilder-transformation.png" width="900px" />

Or import `install/fhirtransf.json`.

### Step 3: 📤 Project to SQL

Define a package (e.g. `demo`) for your SQL projection.

Test it using the provided [Jupyter Notebook](http://localhost:8888/lab/tree/IRISPython.ipynb)!

<img src="img/fhirsqlbuilder-projection.gif" width="900px" />

---

## 🙌 You're Ready!

Explore, break things, build your own flows — and don’t forget to have fun learning how **InterSystems IRIS for Health** helps solve real-world interoperability challenges!

---

## 🧭 Glossary

- **Namespace**: an IRIS logical environment with its own code and data context
- **Production**: an interoperability configuration that wires services, processes, and operations together
- **Business Service / Process / Operation**: the inbound, orchestration, and outbound building blocks in an interoperability production
- **BPL**: Business Process Language, the graphical orchestration used for process flows
- **DTL**: Data Transformation Language, the graphical mapper used to transform payloads between formats
