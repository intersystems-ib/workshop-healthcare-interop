Class Demo.EventBridge.DT.Segment.InteropRequestToMSH Extends Ens.DataTransformDTL [ DependsOn = (Demo.EventBridge.Msg.InteropRequest, EnsLib.HL7.Segment) ]
{

Parameter GENERATEEMPTYSEGMENTS = 0;

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='Demo.EventBridge.Msg.InteropRequest' targetClass='EnsLib.HL7.Segment' targetDocType='2.5:MSH' create='new' language='objectscript' >
<assign value='"|"' property='target.{FieldSeparator}' action='set' />
<assign value='&quot;^~\&amp;&quot;' property='target.{EncodingCharacters}' action='set' />
<assign value='source.Info.SourceSystem' property='target.{SendingApplication.NamespaceID}' action='set' />
<assign value='"IRISDEMO"' property='target.{SendingFacility.NamespaceID}' action='set' />
<assign value='source.Info.TargetSystem' property='target.{ReceivingApplication.NamespaceID}' action='set' />
<assign value='"PACSDEMO"' property='target.{ReceivingFacility.NamespaceID}' action='set' />
<assign value='##class(Demo.Util.Helper).HL7CurrentDateTime()' property='target.{DateTimeOfMessage.Time}' action='set' />
<assign value='$translate(source.Info.RequestType,&quot;_&quot;,&quot;^&quot;)' property='target.{MessageType.MessageCode}' action='set' />
<assign value='$piece($translate(source.Info.RequestType,&quot;_&quot;,&quot;^&quot;),&quot;^&quot;,2)' property='target.{MessageType.TriggerEvent}' action='set' />
<assign value='source.Info.RequestId' property='target.{MessageControlID}' action='set' />
<assign value='"P"' property='target.{ProcessingID.ProcessingID}' action='set' />
<assign value='"2.5"' property='target.{VersionID.VersionID}' action='set' />
</transform>
}

}
