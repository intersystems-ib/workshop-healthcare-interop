Class Demo.EventBridge.DT.PACS.InteropRequestToADTA08 Extends Ens.DataTransformDTL [ DependsOn = (Demo.EventBridge.Msg.InteropResponse, EnsLib.HL7.Message) ]
{

Parameter GENERATEEMPTYSEGMENTS = 0;

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='Demo.EventBridge.Msg.InteropResponse' targetClass='EnsLib.HL7.Message' targetDocType='2.5:ADT_A01' create='new' language='objectscript' >
<subtransform class='Demo.EventBridge.DT.Segment.InteropRequestToMSH' targetObj='target.{MSH}' sourceObj='source' />
<assign value='"A08"' property='target.{EVN:EventTypeCode}' action='set' />
<assign value='##class(Demo.Util.Helper).HL7CurrentDateTime()' property='target.{EVN:RecordedDateTime.Time}' action='set' />
<subtransform class='Demo.EventBridge.DT.Segment.InteropRequestToPID' targetObj='target.{PID}' sourceObj='source' />
<subtransform class='Demo.EventBridge.DT.Segment.InteropRequestToPV1' targetObj='target.{PV1}' sourceObj='source' />
</transform>
}

}
