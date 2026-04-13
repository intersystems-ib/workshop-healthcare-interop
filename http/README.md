# VS Code HTTP requests

These `.http` files are a lightweight replacement for the Postman collection:

- [his-orders.http](/Users/afuentes/Documents/ISC/workspace/workshop-healthcare-interop/http/his-orders.http)
- [fhir-repository.http](/Users/afuentes/Documents/ISC/workspace/workshop-healthcare-interop/http/fhir-repository.http)

Use them with the VS Code REST Client extension. The defaults match the Postman collection:

- `server=localhost`
- `port=52773`
- `fhirendpoint=csp/healthshare/fhirrepo/fhir/r4`
- `username=superuser`
- `password=SYS`

Notes:

- `his-orders.http` covers the three HIS order examples.
- `fhir-repository.http` covers the FHIR repository metadata, CRUD, and search examples.
- The Postman collection's `Version Patient/1/_history/1` entry points to `Patient/1`; the `.http` file uses the expected history path `Patient/1/_history/1`.
