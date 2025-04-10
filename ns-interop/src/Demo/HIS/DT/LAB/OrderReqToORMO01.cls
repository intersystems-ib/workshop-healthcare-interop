Class Demo.HIS.DT.LAB.OrderReqToORMO01 Extends Ens.DataTransformDTL [ DependsOn = (Demo.HIS.Msg.OrderReq, EnsLib.HL7.Message) ]
{

Parameter GENERATEEMPTYSEGMENTS = 0;

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='Demo.HIS.Msg.OrderReq' targetClass='EnsLib.HL7.Message' targetDocType='2.5:ORM_O01' create='new' language='objectscript' >
<subtransform class='Demo.HIS.DT.LAB.OrderReqTosegMSH' targetObj='target.{MSH}' sourceObj='source' />
<if condition='source.clinicalInfo&apos;=""' >
<true>
<assign value='1' property='target.{NTE():SetIDNTE}' action='set' />
<assign value='source.clinicalInfo' property='target.{NTE(1):Comment(1)}' action='set' />
</true>
</if>
<assign value='source.patient.mrn' property='target.{PIDgrp.PID:PatientIdentifierList(1).IDNumber}' action='set' />
<assign value='source.patient.name' property='target.{PIDgrp.PID:PatientName(1).GivenName}' action='set' />
<assign value='..Lookup("HIS-LAB-AdministrativeSex",source.patient.gender)' property='target.{PIDgrp.PID:AdministrativeSex}' action='set' />
<assign value='##class(Demo.Util.Helper).DateToHL7Date(source.patient.birthDate)' property='target.{PIDgrp.PID:DateTimeofBirth.Time}' action='set' />
<assign value='"NW"' property='target.{ORCgrp(1).ORC:OrderControl}' action='set' />
<assign value='source.orderId' property='target.{ORCgrp(1).ORC:PlacerOrderNumber}' action='set' />
<assign value='"SC"' property='target.{ORCgrp(1).ORC:OrderStatus}' action='set' />
<assign value='source.practitioner.identifier' property='target.{ORCgrp(1).ORC:EnteredBy(1).IDNumber}' action='set' />
<assign value='##class(Demo.Util.Helper).DateToHL7DateTime(source.orderDateTime)' property='target.{ORCgrp(1).ORC:OrderEffectiveDateTime}' action='set' />
<assign value='1' property='target.{ORCgrp(1).OBRuniongrp.OBRunion.OBR:SetIDOBR}' action='set' />
<assign value='source.orderId' property='target.{ORCgrp(1).OBRuniongrp.OBRunion.OBR:PlacerOrderNumber.EntityIdentifier}' action='set' />
<assign value='source.test.code' property='target.{ORCgrp(1).OBRuniongrp.OBRunion.OBR:UniversalServiceIdentifier.Identifier}' action='set' />
<assign value='source.test.priority' property='target.{ORCgrp(1).OBRuniongrp.OBRunion.OBR:PriorityOBR}' action='set' />
<assign value='##class(Demo.Util.Helper).DateToHL7DateTime(source.orderDateTime)' property='target.{ORCgrp(1).OBRuniongrp.OBRunion.OBR:RequestedDateTime}' action='set' />
</transform>
}

}
