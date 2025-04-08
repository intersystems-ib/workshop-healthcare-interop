Class Demo.HIS.Msg.TestInfo Extends (%SerialObject, %XML.Adaptor, %JSON.Adaptor)
{

Property code As %String;

Property description As %String;

Property priority As %String;

Storage Default
{
<Data name="TestInfoState">
<Value name="1">
<Value>code</Value>
</Value>
<Value name="2">
<Value>description</Value>
</Value>
<Value name="3">
<Value>priority</Value>
</Value>
</Data>
<State>TestInfoState</State>
<StreamLocation>^Demo.HIS.Msg.TestInfoS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
