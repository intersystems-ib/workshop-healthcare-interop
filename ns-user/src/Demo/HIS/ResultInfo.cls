Class Demo.HIS.ResultInfo Extends (%SerialObject, %XML.Adaptor)
{

Property PatientId As %String;

Property OrderId As %String;

Property Observations As list Of ObxInfo;

Storage Default
{
<Data name="ResultInfoState">
<Value name="1">
<Value>PatientId</Value>
</Value>
<Value name="2">
<Value>OrderId</Value>
</Value>
<Value name="3">
<Value>Observations</Value>
</Value>
</Data>
<State>ResultInfoState</State>
<StreamLocation>^Demo.HIS.ResultInfoS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
