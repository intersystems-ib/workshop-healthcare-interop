/// Routes canonical EventBridge requests to the target-specific business process.
Class Demo.EventBridge.Rule.RouteByTargetSystem Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "EnsLib.MsgRouter.RuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="EnsLib.MsgRouter.RoutingEngine" production="Demo.EventBridge.Production">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
<rule name="Route PACS Requests">
<constraint name="msgClass" value="Demo.EventBridge.Msg.InteropRequest"></constraint>
<when condition="Document.Info.TargetSystem=&quot;PACS&quot;" comment="">
<send transform="" target="HIS PACS Process"></send>
</when>
</rule>
</ruleSet>
</ruleDefinition>
}

}
