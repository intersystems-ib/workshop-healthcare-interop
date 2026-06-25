/// Created from: /app/install/EventBridgeHISReportService.wsdl
Class Demo.EventBridge.HIS.WSC.s0.ReportInfo Extends (%SerialObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "urn:Demo.EventBridge.HIS.ReportService";

Parameter VALIDIFNULL = 1;

Parameter XMLNAME = "ReportInfo";

Parameter XMLSEQUENCE = 1;

Property PatientId As %String(MAXLEN = "", XMLNAME = "PatientId");

Property VisitNumber As %String(MAXLEN = "", XMLNAME = "VisitNumber");

Property OrderId As %String(MAXLEN = "", XMLNAME = "OrderId");

Property PlacerOrderNumber As %String(MAXLEN = "", XMLNAME = "PlacerOrderNumber");

Property FillerOrderNumber As %String(MAXLEN = "", XMLNAME = "FillerOrderNumber");

Property Modality As %String(MAXLEN = "", XMLNAME = "Modality");

Property ReportDateTime As %TimeStamp(XMLNAME = "ReportDateTime");

Property ReportStatus As %String(MAXLEN = "", XMLNAME = "ReportStatus");

Property ReportText As %String(MAXLEN = "", XMLNAME = "ReportText");

Property Observations As list Of Demo.EventBridge.HIS.WSC.s0.ReportObservationInfo(XMLITEMNAME = "ReportObservationInfo", XMLNAME = "Observations", XMLPROJECTION = "COLLECTION");

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
<StreamLocation>^Demo.EventBridge574.ReportInfoS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
