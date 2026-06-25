/// Routes inbound PACS HL7 messages to the reverse EventBridge process.
Class Demo.EventBridge.PACS.Rule.RouterIn Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "EnsLib.HL7.MsgRouter.RuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="EnsLib.HL7.MsgRouter.RoutingEngine" production="Demo.EventBridge.Production">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
<rule name="Process Incoming PACS Reports">
<constraint name="source" value="PACS HL7 File In"></constraint>
<constraint name="docCategory" value="2.5"></constraint>
<constraint name="docName" value="ORU_R01"></constraint>
<when condition="(Document.{MSH:SendingFacility.NamespaceID}=&quot;PACS&quot;)||(Document.{MSH:SendingApplication.NamespaceID}=&quot;PACS&quot;)" comment="">
<send transform="" target="PACS HIS Process"></send>
</when>
</rule>
</ruleSet>
</ruleDefinition>
}

}
