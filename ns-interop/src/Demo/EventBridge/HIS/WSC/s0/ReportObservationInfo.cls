/// Created from: /app/install/EventBridgeHISReportService.wsdl
Class Demo.EventBridge.HIS.WSC.s0.ReportObservationInfo Extends (%SerialObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "urn:Demo.EventBridge.HIS.ReportService";

Parameter VALIDIFNULL = 1;

Parameter XMLNAME = "ReportObservationInfo";

Parameter XMLSEQUENCE = 1;

Property Code As %String(MAXLEN = "", XMLNAME = "Code");

Property Name As %String(MAXLEN = "", XMLNAME = "Name");

Property Value As %String(MAXLEN = "", XMLNAME = "Value");

Property Units As %String(MAXLEN = "", XMLNAME = "Units");

Property ResultStatus As %String(MAXLEN = "", XMLNAME = "ResultStatus");

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
<StreamLocation>^Demo.EventB574.ReportObser6851S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
