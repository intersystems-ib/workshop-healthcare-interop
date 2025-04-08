Class Demo.HIS.Msg.OrderReq Extends (Ens.Request, %XML.Adaptor, %JSON.Adaptor)
{

Property msgId As %String;

Property orderId As %String;

Property patient As PatientInfo;

Property practitioner As PractitionerInfo;

Property orderDateTime As %TimeStamp;

Property test As TestInfo;

Property clinicalInfo As %String(MAXLEN = "");

Storage Default
{
<Data name="OrderReqDefaultData">
<Subscript>"OrderReq"</Subscript>
<Value name="1">
<Value>msgId</Value>
</Value>
<Value name="2">
<Value>orderId</Value>
</Value>
<Value name="3">
<Value>patient</Value>
</Value>
<Value name="4">
<Value>practitioner</Value>
</Value>
<Value name="5">
<Value>orderDateTime</Value>
</Value>
<Value name="6">
<Value>tests</Value>
</Value>
<Value name="7">
<Value>clinicalInfo</Value>
</Value>
<Value name="8">
<Value>test</Value>
</Value>
</Data>
<DefaultData>OrderReqDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
