/// Demo SOAP web service used to simulate the HIS side of the EventBridge reverse flow.
///
/// Publish in USER and extract the WSDL from:
/// http://localhost:52773/csp/user/Demo.EventBridge.HIS.ReportService.cls?wsdl=1
Class Demo.EventBridge.HIS.ReportService Extends %SOAP.WebService
{

Parameter SERVICENAME = "ReportService";

Parameter NAMESPACE = "urn:Demo.EventBridge.HIS.ReportService";

/// Accepts a PACS report already transformed into a SOAP payload.
/// The return value is a simple acknowledgement id that is enough for the workshop.
Method SubmitReport(report As Demo.EventBridge.HIS.ReportInfo) As %String [ WebMethod ]
{
	return ##class(%SYSTEM.Util).CreateGUID()
}

}
