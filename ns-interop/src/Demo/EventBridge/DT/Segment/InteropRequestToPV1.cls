Class Demo.EventBridge.DT.Segment.InteropRequestToPV1 Extends Ens.DataTransformDTL [ DependsOn = (Demo.EventBridge.Msg.InteropRequest, EnsLib.HL7.Segment) ]
{

Parameter GENERATEEMPTYSEGMENTS = 0;

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='Demo.EventBridge.Msg.InteropRequest' targetClass='EnsLib.HL7.Segment' targetDocType='2.5:PV1' create='new' language='objectscript' >
<assign value='1' property='target.{SetIDPV1}' action='set' />
<assign value='source.Info.Visit.PatientClass' property='target.{PatientClass}' action='set' />
<assign value='source.Info.Visit.AssignedLocation' property='target.{AssignedPatientLocation.PointOfCare}' action='set' />
<assign value='source.Info.Visit.Room' property='target.{AssignedPatientLocation.Room}' action='set' />
<assign value='source.Info.Visit.Bed' property='target.{AssignedPatientLocation.Bed}' action='set' />
<assign value='source.Info.Visit.AttendingId' property='target.{AttendingDoctor(1).IDNumber}' action='set' />
<assign value='source.Info.Visit.AttendingLastName' property='target.{AttendingDoctor(1).FamilyName.Surname}' action='set' />
<assign value='source.Info.Visit.AttendingFirstName' property='target.{AttendingDoctor(1).GivenName}' action='set' />
<assign value='source.Info.Visit.VisitNumber' property='target.{VisitNumber.IDNumber}' action='set' />
<assign value='##class(Demo.Util.Helper).DateToHL7DateTime(source.Info.Visit.AdmitDateTime)' property='target.{AdmitDateTime.Time}' action='set' />
</transform>
}

}
