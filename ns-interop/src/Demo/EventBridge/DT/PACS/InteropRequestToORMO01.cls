Class Demo.EventBridge.DT.PACS.InteropRequestToORMO01 Extends Ens.DataTransformDTL [ DependsOn = (Demo.EventBridge.Msg.InteropResponse, EnsLib.HL7.Message) ]
{

Parameter GENERATEEMPTYSEGMENTS = 0;

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='Demo.EventBridge.Msg.InteropResponse' targetClass='EnsLib.HL7.Message' targetDocType='2.5:ORM_O01' create='new' language='objectscript' >
<subtransform class='Demo.EventBridge.DT.Segment.InteropRequestToMSH' targetObj='target.{MSH}' sourceObj='source' />
<subtransform class='Demo.EventBridge.DT.Segment.InteropRequestToPID' targetObj='target.{PIDgrp.PID}' sourceObj='source' />
<assign value='source.Info.Visit.PatientClass' property='target.{PIDgrp.PV1grp.PV1:PatientClass}' action='set' />
<assign value='source.Info.Visit.AssignedLocation' property='target.{PIDgrp.PV1grp.PV1:AssignedPatientLocation.PointOfCare}' action='set' />
<assign value='source.Info.Visit.Room' property='target.{PIDgrp.PV1grp.PV1:AssignedPatientLocation.Room}' action='set' />
<assign value='source.Info.Visit.Bed' property='target.{PIDgrp.PV1grp.PV1:AssignedPatientLocation.Bed}' action='set' />
<assign value='source.Info.Visit.VisitNumber' property='target.{PIDgrp.PV1grp.PV1:VisitNumber.IDNumber}' action='set' />
<assign value='source.Info.Visit.AttendingId' property='target.{PIDgrp.PV1grp.PV1:AttendingDoctor(1).IDNumber}' action='set' />
<assign value='source.Info.Visit.AttendingLastName' property='target.{PIDgrp.PV1grp.PV1:AttendingDoctor(1).FamilyName.Surname}' action='set' />
<assign value='source.Info.Visit.AttendingFirstName' property='target.{PIDgrp.PV1grp.PV1:AttendingDoctor(1).GivenName}' action='set' />
<assign value='##class(Demo.Util.Helper).DateToHL7DateTime(source.Info.Visit.AdmitDateTime)' property='target.{PIDgrp.PV1grp.PV1:AdmitDateTime.Time}' action='set' />
<assign value='"NW"' property='target.{ORCgrp(1).ORC:OrderControl}' action='set' />
<assign value='source.Info.Order.PlacerOrderNumber' property='target.{ORCgrp(1).ORC:PlacerOrderNumber.EntityIdentifier}' action='set' />
<assign value='source.Info.Order.FillerOrderNumber' property='target.{ORCgrp(1).ORC:FillerOrderNumber.EntityIdentifier}' action='set' />
<assign value='"SC"' property='target.{ORCgrp(1).ORC:OrderStatus}' action='set' />
<assign value='source.Info.Order.OrderingProviderId' property='target.{ORCgrp(1).ORC:EnteredBy(1).IDNumber}' action='set' />
<assign value='source.Info.Order.OrderingProviderLastName' property='target.{ORCgrp(1).ORC:EnteredBy(1).FamilyName.Surname}' action='set' />
<assign value='source.Info.Order.OrderingProviderFirstName' property='target.{ORCgrp(1).ORC:EnteredBy(1).GivenName}' action='set' />
<assign value='##class(Demo.Util.Helper).DateToHL7DateTime(source.Info.Order.RequestedDateTime)' property='target.{ORCgrp(1).ORC:OrderEffectiveDateTime.Time}' action='set' />
<assign value='1' property='target.{ORCgrp(1).OBRuniongrp.OBRunion.OBR:SetIDOBR}' action='set' />
<assign value='source.Info.Order.PlacerOrderNumber' property='target.{ORCgrp(1).OBRuniongrp.OBRunion.OBR:PlacerOrderNumber.EntityIdentifier}' action='set' />
<assign value='source.Info.Order.FillerOrderNumber' property='target.{ORCgrp(1).OBRuniongrp.OBRunion.OBR:FillerOrderNumber.EntityIdentifier}' action='set' />
<assign value='source.Info.Order.ServiceCode' property='target.{ORCgrp(1).OBRuniongrp.OBRunion.OBR:UniversalServiceIdentifier.Identifier}' action='set' />
<assign value='source.Info.Order.ServiceText' property='target.{ORCgrp(1).OBRuniongrp.OBRunion.OBR:UniversalServiceIdentifier.Text}' action='set' />
<assign value='source.Info.Order.PriorityCode' property='target.{ORCgrp(1).OBRuniongrp.OBRunion.OBR:PriorityOBR}' action='set' />
<assign value='##class(Demo.Util.Helper).DateToHL7DateTime(source.Info.Order.RequestedDateTime)' property='target.{ORCgrp(1).OBRuniongrp.OBRunion.OBR:RequestedDateTime.Time}' action='set' />
<assign value='source.Info.Order.Modality' property='target.{ORCgrp(1).OBRuniongrp.OBRunion.OBR:DiagnosticServSectID}' action='set' />
<assign value='source.Info.Order.ReasonText' property='target.{ORCgrp(1).OBRuniongrp.OBRunion.OBR:RelevantClinicalInformation}' action='set' />
</transform>
}

}
