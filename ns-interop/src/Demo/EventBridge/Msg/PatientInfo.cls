Class Demo.EventBridge.Msg.PatientInfo Extends (%SerialObject, %XML.Adaptor)
{

Property PatientId As %String;

Property MRN As %String;

Property AssigningAuthority As %String;

Property LastName As %String;

Property FirstName As %String;

Property MiddleName As %String;

Property BirthDate As %Date;

Property Sex As %String;

Property PhoneNumber As %String;

Property AddressLine1 As %String;

Property City As %String;

Property StateCode As %String;

Property PostalCode As %String;

Storage Default
{
<Data name="PatientInfoState">
<Value name="1">
<Value>PatientId</Value>
</Value>
<Value name="2">
<Value>MRN</Value>
</Value>
<Value name="3">
<Value>AssigningAuthority</Value>
</Value>
<Value name="4">
<Value>LastName</Value>
</Value>
<Value name="5">
<Value>FirstName</Value>
</Value>
<Value name="6">
<Value>MiddleName</Value>
</Value>
<Value name="7">
<Value>BirthDate</Value>
</Value>
<Value name="8">
<Value>Sex</Value>
</Value>
<Value name="9">
<Value>PhoneNumber</Value>
</Value>
<Value name="10">
<Value>AddressLine1</Value>
</Value>
<Value name="11">
<Value>City</Value>
</Value>
<Value name="12">
<Value>StateCode</Value>
</Value>
<Value name="13">
<Value>PostalCode</Value>
</Value>
</Data>
<State>PatientInfoState</State>
<StreamLocation>^Demo.EventBrid2B8D.PatientInfoS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
