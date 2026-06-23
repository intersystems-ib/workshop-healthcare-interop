/// Demo SOAP WebService to simulate HIS Result Processing
/// This can be used from an interop production
/// 
/// WSDL: http://localhost:52773/csp/user/Demo.LabWorkflow.HIS.ResultSoapService.cls?wsdl=1
/// /app/install/LabWorkflowResultSoapService.wsdl
Class Demo.LabWorkflow.HIS.ResultSoapService Extends %SOAP.WebService
{

Parameter SERVICENAME = "ResultSoapService";

Parameter NAMESPACE = "Demo";

Method NewResult(result As ResultInfo) As %String [ WebMethod ]
{
	return ##class(%SYSTEM.Util).CreateGUID()
}

}
