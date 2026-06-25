Class Demo.EventBridge.HIS.WSC.Msg.SubmitReportRequest Extends Ens.Request [ ProcedureBlock ]
{

Parameter RESPONSECLASSNAME = "Demo.EventBridge.HIS.WSC.Msg.SubmitReportResponse";

Property report As Demo.EventBridge.HIS.WSC.s0.ReportInfo;

Storage Default
{
<Data name="SubmitReportRequestDefaultData">
<Subscript>"SubmitReportRequest"</Subscript>
<Value name="1">
<Value>report</Value>
</Value>
</Data>
<DefaultData>SubmitReportRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
