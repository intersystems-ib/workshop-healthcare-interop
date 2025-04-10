/// 
Class Demo.LAB.Rule.RouterIn Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "EnsLib.HL7.MsgRouter.RuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="EnsLib.HL7.MsgRouter.RoutingEngine" production="Demo.OrderProduction">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
<rule name="Process Incoming Laboratory Results">
<constraint name="source" value="LAB HL7 File In"></constraint>
<constraint name="docCategory" value="2.5"></constraint>
<constraint name="docName" value="ORU_R01"></constraint>
<when condition="Document.{MSH:SendingFacility.NamespaceID}=&quot;LABORATORY&quot;" comment="">
<send transform="" target="LAB Result Process"></send>
</when>
</rule>
</ruleSet>
</ruleDefinition>
}

}
