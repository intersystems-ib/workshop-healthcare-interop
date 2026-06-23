Class Demo.EventBridge.Msg.InteropInfo Extends (%SerialObject, %XML.Adaptor)
{

Property RequestId As %String;

Property RequestType As %String;

Property SourceSystem As %String;

Property TargetSystem As %String;

Property Status As %String;

Property EventDateTime As %TimeStamp;

Property Patient As Demo.EventBridge.Msg.PatientInfo;

Property Visit As Demo.EventBridge.Msg.VisitInfo;

Property Order As Demo.EventBridge.Msg.OrderInfo;

Storage Default
{
<Data name="InteropInfoState">
<Value name="1">
<Value>RequestId</Value>
</Value>
<Value name="2">
<Value>RequestType</Value>
</Value>
<Value name="3">
<Value>SourceSystem</Value>
</Value>
<Value name="4">
<Value>TargetSystem</Value>
</Value>
<Value name="5">
<Value>Status</Value>
</Value>
<Value name="6">
<Value>EventDateTime</Value>
</Value>
<Value name="7">
<Value>Patient</Value>
</Value>
<Value name="8">
<Value>Visit</Value>
</Value>
<Value name="9">
<Value>Order</Value>
</Value>
</Data>
<State>InteropInfoState</State>
<StreamLocation>^Demo.EventBridge2B8D.InteropInfoS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
