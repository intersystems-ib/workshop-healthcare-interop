Class Demo.EventBridge.PACS.DT.HIS.ORUR01ToSubmitReportRequest Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.HL7.Message, Demo.EventBridge.HIS.WSC.Msg.SubmitReportRequest) ]
{

Parameter GENERATEEMPTYSEGMENTS = 0;

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.HL7.Message' targetClass='Demo.EventBridge.HIS.WSC.Msg.SubmitReportRequest' sourceDocType='2.5:ORU_R01' create='new' language='objectscript' >
<assign value='source.{PIDgrpgrp(1).PIDgrp.PID:PatientIdentifierList(1).IDNumber}' property='target.report.PatientId' action='set' />
<assign value='source.{PIDgrpgrp(1).PIDgrp.PV1grp.PV1:VisitNumber.IDNumber}' property='target.report.VisitNumber' action='set' />
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).ORC:PlacerOrderNumber.EntityIdentifier}' property='target.report.OrderId' action='set' />
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).ORC:PlacerOrderNumber.EntityIdentifier}' property='target.report.PlacerOrderNumber' action='set' />
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBR:FillerOrderNumber.EntityIdentifier}' property='target.report.FillerOrderNumber' action='set' />
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBR:DiagnosticServSectID}' property='target.report.Modality' action='set' />
<assign value='##class(Demo.Util.Helper).HL7ToLogicalTimestamp(source.{MSH:DateTimeOfMessage.Time})' property='target.report.ReportDateTime' action='set' />
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBR:ResultStatus}' property='target.report.ReportStatus' action='set' />
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(1).OBX:ObservationValue(1)}' property='target.report.ReportText' action='set' />
<foreach property='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp()}' key='k1' >
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ObservationIdentifier.Identifier}' property='target.report.Observations.(k1).Code' action='set' />
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ObservationIdentifier.Text}' property='target.report.Observations.(k1).Name' action='set' />
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ObservationValue(1)}' property='target.report.Observations.(k1).Value' action='set' />
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:Units.Identifier}' property='target.report.Observations.(k1).Units' action='set' />
<assign value='source.{PIDgrpgrp(1).ORCgrp(1).OBXgrp(k1).OBX:ObservationResultStatus}' property='target.report.Observations.(k1).ResultStatus' action='set' />
</foreach>
</transform>
}

}
