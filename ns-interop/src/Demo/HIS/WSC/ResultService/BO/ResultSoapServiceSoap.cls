Class Demo.HIS.WSC.ResultService.BO.ResultSoapServiceSoap Extends Ens.BusinessOperation [ ProcedureBlock ]
{

Parameter ADAPTER = "EnsLib.SOAP.OutboundAdapter";

Method NewResult(pRequest As Demo.HIS.WSC.ResultService.Msg.NewResultRequest, Output pResponse As Demo.HIS.WSC.ResultService.Msg.NewResultResponse) As %Library.Status
{
 Set ..Adapter.WebServiceClientClass = "Demo.HIS.WSC.ResultService.ResultSoapServiceSoap"
 Set tSC = ..Adapter.InvokeMethod("NewResult",.NewResultResult,pRequest.result)  Quit:$$$ISERR(tSC) tSC
 Set tSC = pRequest.NewResponse(.pResponse)  Quit:$$$ISERR(tSC) tSC
 Set pResponse.NewResultResult=$get(NewResultResult)
 Quit $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Demo.HIS.WSC.ResultService.Msg.NewResultRequest">
		<Method>NewResult</Method>
	</MapItem>
</MapItems>
}

}
