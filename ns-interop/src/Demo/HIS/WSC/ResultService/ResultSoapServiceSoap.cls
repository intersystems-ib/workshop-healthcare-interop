Class Demo.HIS.WSC.ResultService.ResultSoapServiceSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://localhost:52773/csp/user/Demo.HIS.ResultSoapService.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "Demo";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "ResultSoapService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method NewResult(result As Demo.HIS.WSC.ResultService.s0.ResultInfo) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("NewResult").Invoke($this,"Demo/Demo.HIS.ResultSoapService.NewResult",.result)
}

}
