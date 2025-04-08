Class Demo.LAB.DT.HIS.ORUR01ToNewResult Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.HL7.Message, Demo.HIS.WSC.ResultService.Msg.NewResultRequest) ]
{

Parameter GENERATEEMPTYSEGMENTS = 0;

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.HL7.Message' targetClass='Demo.HIS.WSC.ResultService.Msg.NewResultRequest' sourceDocType='2.5:ORU_R01' create='new' language='objectscript' >
<assign value='source.{PIDgrpgrp(1).PIDgrp.PID:PatientIdentifierList(1).IDNumber}' property='target.result.PatientId' action='set' />
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).ORC:PlacerOrderNumber.EntityIdentifier}' property='target.result.OrderId' action='set' />
<foreach property='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp()}' key='k1' >
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ObservationIdentifier.Identifier}' property='target.result.Observations.(k1).Code' action='set' />
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ObservationIdentifier.Text}' property='target.result.Observations.(k1).Name' action='set' />
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ObservationValue(1)}' property='target.result.Observations.(k1).Value' action='set' />
</foreach>
</transform>
}

}
