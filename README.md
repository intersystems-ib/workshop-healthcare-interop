# Intro to Healthcare Interoperability
Examples you can use to learn the main ideas involved in HealthCare Interoperability using InterSystems IRIS for Health. 

You can find more in-depth information in https://learning.intersystems.com.

# What do you need to install? 
* [Git](https://git-scm.com/downloads) 
* [Docker](https://www.docker.com/products/docker-desktop) (if you are using Windows, make sure you set your Docker installation to use "Linux containers").
* [Docker Compose](https://docs.docker.com/compose/install/)
* [Visual Studio Code](https://code.visualstudio.com/download) + [InterSystems ObjectScript VSCode Extension](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript)

# Setup
Build the image we will use during the workshop:

```
git clone https://github.com/intersystems-ib/workshop-healthcare-interop
cd workshop-healthcare-interop

docker-compose build
```

* Run the containers we will use in the workshop:
```
docker-compose up -d
```

Open `workshop-healthcare-interop` folder in VS Code.

# Basics 

## Start FindRateProduction

* Open the [Management Portal](http://localhost:52773/csp/sys/UtilHome.csp).
* Login using the default `superuser`/ `SYS` account.
* *Interoperability > Namespace **INTEROP** > List > Productions > Demo.Loan.FindRateProduction > Open*
* Start Production
* Have a look at the Business Services, Business Processes and Business Operations.
* Click on the *connector* (green ball) to see how the components are linked.
* See the *Legend* to understand the meaning of the different colors of the components.

## Test a Business Operation
* Click on `Demo.Loan.WebOperations`
* Go to *Actions* tab > Test > Choose a `Demo.Loan.CreditRatingRequest` message.
* Enter some input and see the output in the resulting Visual Trace.
* Have a look at the involved Business Operation and Messages in VS Code.

## Make a sample loan request
* Open http://localhost:52773/csp/healthshare/interop/DemoLoanForm.csp and enter some data (you can test with different values).
* Go back to your production and open the [Message Viewer](http://localhost:52773/csp/healthshare/interop/EnsPortal.MessageViewer.zen).
* Have a look at the messages, go through some of the traces.
* Pay attention to the elements involved, sync/async calls, message contents and possible errors or alerts thrown.

## Inspect a Business Process
* Back in [Demo.Loan.FindRateProduction Production](http://localhost:52773/csp/healthshare/interop/EnsPortal.ProductionConfig.zen?PRODUCTION=Demo.Loan.FindRateProduction), click on `Demo.Loan.FindRateDecisionProcessBPL`.
* On the settings tab, click on the magnifyer icon on the *Class name* setting.
* Inspect the graphical BPL definition of the process.
* When you are done, stop the production.

## Start Demo.HL7.MsgRouter.Production
* *Interoperability > Namespace **INTEROP** > List > Productions > Demo.HL7.MsgRouter.Production > Open*
* Start production.
* Have a look at the production, notice the prebuilt HL7 Business Services and Operations that are being used.
* Explore the settings on those services and operations (e.g. FilePath, etc.)

## Process some sample HL7 messages
* In your VS Code with `workshop-healthcare-interop` opened, copy `test/*.txt` files into `test/in` subdirectory.
* Go back to the production and see [Message Viewer](http://localhost:52773/csp/healthshare/interop/EnsPortal.MessageViewer.zen).
* Explore some the new messages that have appeared. Notice the HL7 messages.

## Explore routing rules and data transforms
* Back in Demo.HL7.MsgRouter.Production Production configuration page, click on `XYZ_Router`.
* Click on the magnifying glass on *Business Rule Name* in the Settings Tab.
* Notice the different routing rules based on the content of the HL7 messages.
* Find some of the rules that are using a *Data Transform*.
* Double-click on the Data Transform element and open the *DTL Editor*.
* Have a look at how can messages be transformed.


# FHIR Repository

<img src="./img/fhirserver.png" width="800px"/>

### Create FHIR endpoint
Create FHIR server in Health > FHIRREPO > FHIR Configuration > Server Configuration as:
* Endpoint: `/csp/healthshare/fhirrepo/fhir/r4`
* Core FHIR package: `hl7.fhir.r4.core@4.0.1`

### Load simple FHIR data
Load some sample FHIR data into repo using [WebTerminal](http://localhost:52773/terminal/).

```objectscript
zn "FHIRREPO"
set sc = ##class(HS.FHIRServer.Tools.DataLoader).SubmitResourceFiles("/app/install/simple-fhir-data/","FHIRServer","/csp/healthshare/fhirrepo/fhir/r4")
```

### Test FHIR repository
Open the Postman collection included in [workshop-healthcare-interop.postman_collection.json](./workshop-healthcare-interop.postman_collection.json) and try some requests on `FHIR Repo. Simple` and `FHIR Repo. Queries`.

# FHIR Interoperability

## Scenario: FHIR client
Build a fhir client to send some requests to a FHIR server.

<img src="./img/fhir-client.png" width="800px"/>

Have a look at the [interop.Production](http://localhost:52773/csp/healthshare/interop/EnsPortal.ProductionConfig.zen?PRODUCTION=interop.Production) production:
* `interop.bs.FHIRFileService` - Business Service that reads a file and creates a `HS.FHIRServer.Interop.Request` message.
* `interop.bp.FileToFHIRService` - Business Process that prepare `HS.FHIRServer.Interop.Request` from service before sending to external FHIR server.
* `HS.FHIRServer.Interop.HTTPOperation` - built-in Business Operation that sends a FHIR request to an external FHIR server.

Run some tests:
* Start the production
* Copy `data/patient.json` into `data/fhir-input` to process a sample file in your production.


## Scenario: FHIR request processing

<img src="./img/fhir-request-processing.png" width="800px"/>

In this scenario you need to receive FHIR requests in an interoperability production, maybe manipulate them and finally send that requests to a FHIR server.

In case you need to forward a FHIR request to an external server you can use simple FHIR Interoperability Adapter in InterSystems IRIS or HealthShare Health Connect.

You can find more information in [FHIR Interoperability Adapter](https://docs.intersystems.com/healthconnect20221/csp/docbook/DocBook.UI.Page.cls?KEY=HXFHIR_fhir_adapter).

### Install adapter
You need to install the FHIR interoperability adapter before using it in a namespace.
During the adapter installation it will create:
* A web application for your FHIR server endpoint.
* An `InteropService` and `InteropOperation` in your production.

Install the adapter using [WebTerminal](http://localhost:52773/terminal/):

```objectscript
zn "INTEROP"
set status = ##class(HS.FHIRServer.Installer).InteropAdapterConfig("/myendpoint/r4")
```

Test your service using the Postman collection in [workshop-healthcare-interop.postman_collection.json](./workshop-healthcare-interop.postman_collection.json) and running some requests in `Interop` directory.


# FHIR Analytics: FHIR SQL Builder

What about running analytics on top of a FHIR repository? Well, FHIR model is a directed graph, so it's not trivial.

However, you can have a look at a new experimental feature: **InterSystems FHIR SQL Builder**.

FHIR SQL Builder is a tool that allows you to create your SQL schemas using data from your FHIR repository without moving the data to a separate SQL repository.

<img src="img/fhirsqlbuilder-ui.png" width="900" />

You will need to go through three simple steps:

## Analyze your FHIR repository data
Access [FHIR SQL Builder](http://localhost:52773/csp/fhirsql/index.csp) and create a **New Analysis**:
* New FHIR repository
* Name: `fhirrepo`
* Host: `localhost`
* Port: `52773`
* Credentials: create new credentials using `superuser` / `SYS`
* FHIR repository endpoint: `/csp/healthshare/fhirrepo/fhir/r4`

## Choose data you want to project to SQL
Create a **New Transformation Specification**.

Add some FHIR fields that will be projected as SQL, you can try the following:
* `Patient.gender`
* `Observation.code.coding.code`
* `Observation.valueQuantity.value`

<img src="img/fhirsqlbuilder-transformation.png" width="900" />

## Project data to SQL
Simply create a **New Projection** specifying the package you want to use for your projection (e.g. `demo`).

After that, you can access your data using SQL!

In your workshop you have included a [JupyterLab Notebook](http://localhost:8888/lab/tree/IRISPython.ipynb) to play with the data :)

<img src="img/fhirsqlbuilder-projection.gif" width="900" />
