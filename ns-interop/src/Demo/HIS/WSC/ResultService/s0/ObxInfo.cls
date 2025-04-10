/// Created from: /app/install/HISResultSoapService.wsdl
Class Demo.HIS.WSC.ResultService.s0.ObxInfo Extends (%SerialObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "Demo";

Parameter VALIDIFNULL = 1;

Parameter XMLNAME = "ObxInfo";

Parameter XMLSEQUENCE = 1;

Property Code As %String(MAXLEN = "", XMLNAME = "Code");

Property Name As %String(MAXLEN = "", XMLNAME = "Name");

Property Value As %String(MAXLEN = "", XMLNAME = "Value");

Storage Default
{
<Data name="ObxInfoState">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Value</Value>
</Value>
</Data>
<State>ObxInfoState</State>
<StreamLocation>^Demo.HIS.WSC.Resul56F7.ObxInfoS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
