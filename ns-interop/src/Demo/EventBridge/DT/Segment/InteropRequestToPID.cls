Class Demo.EventBridge.DT.Segment.InteropRequestToPID Extends Ens.DataTransformDTL [ DependsOn = (Demo.EventBridge.Msg.InteropRequest, EnsLib.HL7.Segment) ]
{

Parameter GENERATEEMPTYSEGMENTS = 0;

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='Demo.EventBridge.Msg.InteropRequest' targetClass='EnsLib.HL7.Segment' targetDocType='2.5:PID' create='new' language='objectscript' >
<assign value='1' property='target.{SetIDPID}' action='set' />
<assign value='source.Info.Patient.MRN' property='target.{PatientIdentifierList(1).IDNumber}' action='set' />
<assign value='"MR"' property='target.{PatientIdentifierList(1).IdentifierTypeCode}' action='set' />
<assign value='source.Info.Patient.LastName' property='target.{PatientName(1).FamilyName.Surname}' action='set' />
<assign value='source.Info.Patient.FirstName' property='target.{PatientName(1).GivenName}' action='set' />
<assign value='##class(Demo.Util.Helper).DateToHL7Date(source.Info.Patient.BirthDate)' property='target.{DateTimeOfBirth.Time}' action='set' />
<assign value='source.Info.Patient.Sex' property='target.{AdministrativeSex}' action='set' />
<assign value='source.Info.Patient.AddressLine1' property='target.{PatientAddress(1).StreetAddress.StreetOrMailingAddress}' action='set' />
<assign value='source.Info.Patient.City' property='target.{PatientAddress(1).City}' action='set' />
<assign value='source.Info.Patient.StateCode' property='target.{PatientAddress(1).StateOrProvince}' action='set' />
<assign value='source.Info.Patient.PostalCode' property='target.{PatientAddress(1).ZipOrPostalCode}' action='set' />
<assign value='source.Info.Patient.PhoneNumber' property='target.{PhoneNumberHome(1).TelephoneNumber}' action='set' />
</transform>
}

}
