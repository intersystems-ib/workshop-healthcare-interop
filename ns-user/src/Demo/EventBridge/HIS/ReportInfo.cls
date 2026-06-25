Class Demo.EventBridge.HIS.ReportInfo Extends (%SerialObject, %XML.Adaptor)
{

Property PatientId As %String;

Property VisitNumber As %String;

Property OrderId As %String;

Property PlacerOrderNumber As %String;

Property FillerOrderNumber As %String;

Property Modality As %String;

Property ReportDateTime As %TimeStamp;

Property ReportStatus As %String;

Property ReportText As %String(MAXLEN = "");

Property Observations As list Of Demo.EventBridge.HIS.ReportObservationInfo;

Storage Default
{
<Data name="ReportInfoState">
<Value name="1">
<Value>PatientId</Value>
</Value>
<Value name="2">
<Value>VisitNumber</Value>
</Value>
<Value name="3">
<Value>OrderId</Value>
</Value>
<Value name="4">
<Value>PlacerOrderNumber</Value>
</Value>
<Value name="5">
<Value>FillerOrderNumber</Value>
</Value>
<Value name="6">
<Value>Modality</Value>
</Value>
<Value name="7">
<Value>ReportDateTime</Value>
</Value>
<Value name="8">
<Value>ReportStatus</Value>
</Value>
<Value name="9">
<Value>ReportText</Value>
</Value>
<Value name="10">
<Value>Observations</Value>
</Value>
</Data>
<State>ReportInfoState</State>
<StreamLocation>^Demo.EventBridge.HIS.ReportInfoS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
