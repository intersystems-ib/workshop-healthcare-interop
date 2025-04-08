/// Created from: /app/install/HISResultSoapService.wsdl
Class Demo.HIS.WSC.ResultService.s0.ResultInfo Extends (%SerialObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "Demo";

Parameter VALIDIFNULL = 1;

Parameter XMLNAME = "ResultInfo";

Parameter XMLSEQUENCE = 1;

Property PatientId As %String(MAXLEN = "", XMLNAME = "PatientId");

Property OrderId As %String(MAXLEN = "", XMLNAME = "OrderId");

Property Observations As list Of Demo.HIS.WSC.ResultService.s0.ObxInfo(XMLITEMNAME = "ObxInfo", XMLNAME = "Observations", XMLPROJECTION = "COLLECTION");

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
<StreamLocation>^Demo.HIS.WSC.Re56F7.ResultInfoS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
