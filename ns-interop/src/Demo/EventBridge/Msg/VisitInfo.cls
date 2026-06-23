Class Demo.EventBridge.Msg.VisitInfo Extends (%SerialObject, %XML.Adaptor)
{

Property VisitId As %String;

Property VisitNumber As %String;

Property PatientClass As %String;

Property AssignedLocation As %String;

Property Room As %String;

Property Bed As %String;

Property AttendingId As %String;

Property AttendingLastName As %String;

Property AttendingFirstName As %String;

Property AdmitDateTime As %TimeStamp;

Storage Default
{
<Data name="VisitInfoState">
<Value name="1">
<Value>VisitId</Value>
</Value>
<Value name="2">
<Value>VisitNumber</Value>
</Value>
<Value name="3">
<Value>PatientClass</Value>
</Value>
<Value name="4">
<Value>AssignedLocation</Value>
</Value>
<Value name="5">
<Value>Room</Value>
</Value>
<Value name="6">
<Value>Bed</Value>
</Value>
<Value name="7">
<Value>AttendingId</Value>
</Value>
<Value name="8">
<Value>AttendingLastName</Value>
</Value>
<Value name="9">
<Value>AttendingFirstName</Value>
</Value>
<Value name="10">
<Value>AdmitDateTime</Value>
</Value>
</Data>
<State>VisitInfoState</State>
<StreamLocation>^Demo.EventBridge2B8D.VisitInfoS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
