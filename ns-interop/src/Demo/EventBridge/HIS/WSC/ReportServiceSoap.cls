Class Demo.EventBridge.HIS.WSC.ReportServiceSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://localhost:52773/csp/user/Demo.EventBridge.HIS.ReportService.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "urn:Demo.EventBridge.HIS.ReportService";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "ReportService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method SubmitReport(report As Demo.EventBridge.HIS.WSC.s0.ReportInfo) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SubmitReport").Invoke($this,"urn:Demo.EventBridge.HIS.ReportService/Demo.EventBridge.HIS.ReportService.SubmitReport",.report)
}

}
