Class Demo.EventBridge.Msg.OrderInfo Extends (%SerialObject, %XML.Adaptor)
{

Property OrderId As %String;

Property PlacerOrderNumber As %String;

Property FillerOrderNumber As %String;

Property ServiceCode As %String;

Property ServiceText As %String;

Property PriorityCode As %String;

Property OrderingProviderId As %String;

Property OrderingProviderLastName As %String;

Property OrderingProviderFirstName As %String;

Property RequestedDateTime As %TimeStamp;

Property Modality As %String;

Property ReasonText As %String(MAXLEN = "");

Storage Default
{
<Data name="OrderInfoState">
<Value name="1">
<Value>OrderId</Value>
</Value>
<Value name="2">
<Value>PlacerOrderNumber</Value>
</Value>
<Value name="3">
<Value>FillerOrderNumber</Value>
</Value>
<Value name="4">
<Value>ServiceCode</Value>
</Value>
<Value name="5">
<Value>ServiceText</Value>
</Value>
<Value name="6">
<Value>PriorityCode</Value>
</Value>
<Value name="7">
<Value>OrderingProviderId</Value>
</Value>
<Value name="8">
<Value>OrderingProviderLastName</Value>
</Value>
<Value name="9">
<Value>OrderingProviderFirstName</Value>
</Value>
<Value name="10">
<Value>RequestedDateTime</Value>
</Value>
<Value name="11">
<Value>Modality</Value>
</Value>
<Value name="12">
<Value>ReasonText</Value>
</Value>
</Data>
<State>OrderInfoState</State>
<StreamLocation>^Demo.EventBridge2B8D.OrderInfoS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
