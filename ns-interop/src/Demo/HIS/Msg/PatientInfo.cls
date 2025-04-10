Class Demo.HIS.Msg.PatientInfo Extends (%SerialObject, %XML.Adaptor, %JSON.Adaptor)
{

Property mrn As %String;

Property name As %String(MAXLEN = "");

Property birthDate As %Date;

Property gender As %String;

Storage Default
{
<Data name="PatientInfoState">
<Value name="1">
<Value>mrn</Value>
</Value>
<Value name="2">
<Value>name</Value>
</Value>
<Value name="3">
<Value>birthDate</Value>
</Value>
<Value name="4">
<Value>gender</Value>
</Value>
</Data>
<State>PatientInfoState</State>
<StreamLocation>^Demo.HIS.Msg.PatientInfoS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
