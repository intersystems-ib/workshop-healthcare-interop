Class Demo.LAB.Msg.CheckTestCatalogRsp Extends Ens.Response
{

Property Code As %String;

Property Name As %String(MAXLEN = "");

Property Description As %String(MAXLEN = "");

Property IsActive As %Boolean;

Storage Default
{
<Data name="CheckTestCatalogRspDefaultData">
<Subscript>"CheckTestCatalogRsp"</Subscript>
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>IsActive</Value>
</Value>
</Data>
<DefaultData>CheckTestCatalogRspDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
