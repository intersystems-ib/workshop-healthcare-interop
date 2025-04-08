Class Demo.HIS.ObxInfo Extends (%SerialObject, %XML.Adaptor)
{

Property Code As %String;

Property Name As %String(MAXLEN = "");

Property Value As %String;

Storage Default
{
<Data name="ObxInfoState">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Value</Value>
</Value>
</Data>
<State>ObxInfoState</State>
<StreamLocation>^Demo.HIS.ObxInfoS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
