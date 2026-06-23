Class Demo.EventBridge.Msg.UpdateRequestStatusReq Extends Ens.Request
{

Property Status As %String;

Property ErrorText As %String(MAXLEN = "");

Property MarkProcessed As %Integer;

Property RequestId As %String;

}
