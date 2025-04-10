Class Demo.HIS.WSC.ResultService.Msg.NewResultRequest Extends Ens.Request [ ProcedureBlock ]
{

Parameter RESPONSECLASSNAME = "Demo.HIS.WSC.ResultService.Msg.NewResultResponse";

Property result As Demo.HIS.WSC.ResultService.s0.ResultInfo;

Storage Default
{
<Data name="NewResultRequestDefaultData">
<Subscript>"NewResultRequest"</Subscript>
<Value name="1">
<Value>result</Value>
</Value>
</Data>
<DefaultData>NewResultRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
