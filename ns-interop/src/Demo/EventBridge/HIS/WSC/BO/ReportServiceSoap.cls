Class Demo.EventBridge.HIS.WSC.BO.ReportServiceSoap Extends Ens.BusinessOperation [ ProcedureBlock ]
{

Parameter ADAPTER = "EnsLib.SOAP.OutboundAdapter";

Method SubmitReport(pRequest As Demo.EventBridge.HIS.WSC.Msg.SubmitReportRequest, Output pResponse As Demo.EventBridge.HIS.WSC.Msg.SubmitReportResponse) As %Library.Status
{
 Set:""=..Adapter.WebServiceClientClass ..Adapter.WebServiceClientClass = "Demo.EventBridge.HIS.WSC.ReportServiceSoap"
 Set tSC = ..Adapter.InvokeMethod("SubmitReport",.SubmitReportResult,pRequest.report)  Quit:$$$ISERR(tSC) tSC
 Set tSC = pRequest.NewResponse(.pResponse)  Quit:$$$ISERR(tSC) tSC
 Set pResponse.SubmitReportResult=$get(SubmitReportResult)
 Quit $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Demo.EventBridge.HIS.WSC.Msg.SubmitReportRequest">
		<Method>SubmitReport</Method>
	</MapItem>
</MapItems>
}

}
