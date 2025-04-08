Class Demo.HIS.DT.LAB.OrderReqTosegMSH Extends Ens.DataTransformDTL [ DependsOn = (Demo.HIS.Msg.OrderReq, EnsLib.HL7.Segment) ]
{

Parameter GENERATEEMPTYSEGMENTS = 0;

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='Demo.HIS.Msg.OrderReq' targetClass='EnsLib.HL7.Segment' targetDocType='2.5:MSH' create='new' language='objectscript' >
<assign value='"|"' property='target.{FieldSeparator}' action='set' />
<assign value='"^~&amp;"' property='target.{EncodingCharacters}' action='set' />
<assign value='"HIS"' property='target.{SendingApplication}' action='set' />
<assign value='"DEMO"' property='target.{SendingFacility.NamespaceID}' action='set' />
<assign value='"LAB"' property='target.{ReceivingApplication}' action='set' />
<assign value='##class(Demo.Util.Helper).HL7CurrentDateTime()' property='target.{DateTimeOfMessage.Time}' action='set' />
<assign value='"P"' property='target.{ProcessingID}' action='set' />
<assign value='"AL"' property='target.{AcceptAcknowledgmentType}' action='set' />
<assign value='"NE"' property='target.{ApplicationAcknowledgmentTyp}' action='set' />
<assign value='source.msgId' property='target.{MessageControlID}' action='set' />
</transform>
}

}
