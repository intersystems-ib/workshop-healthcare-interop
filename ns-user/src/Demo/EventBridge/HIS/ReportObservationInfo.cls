Class Demo.EventBridge.HIS.ReportObservationInfo Extends (%SerialObject, %XML.Adaptor)
{

Property Code As %String;

Property Name As %String(MAXLEN = "");

Property Value As %String(MAXLEN = "");

Property Units As %String;

Property ResultStatus As %String;

Storage Default
{
<Data name="ReportObservationInfoState">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Value</Value>
</Value>
<Value name="4">
<Value>Units</Value>
</Value>
<Value name="5">
<Value>ResultStatus</Value>
</Value>
</Data>
<State>ReportObservationInfoState</State>
<StreamLocation>^Demo.EventBridge.HIS.ReportObservationInfoS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
