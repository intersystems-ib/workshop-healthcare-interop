Class Demo.HIS.Msg.PractitionerInfo Extends (%SerialObject, %XML.Adaptor, %JSON.Adaptor)
{

Property identifier As %String;

Property name As %String(MAXLEN = "");

Storage Default
{
<Data name="PractitionerInfoState">
<Value name="1">
<Value>identifier</Value>
</Value>
<Value name="2">
<Value>name</Value>
</Value>
</Data>
<State>PractitionerInfoState</State>
<StreamLocation>^Demo.HIS.Msg.PractitionerInfoS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
