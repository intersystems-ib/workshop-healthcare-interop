/// 
Class Demo.Alert.Rule.AlertRouter Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "EnsLib.MsgRouter.RuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="EnsLib.MsgRouter.RoutingEngine" production="Demo.OrderProduction">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
<rule name="Alerts">
<constraint name="msgClass" value="Ens.AlertRequest"></constraint>
<when condition="1" comment="">
<send transform="" target="Alert Email Out"></send>
</when>
</rule>
</ruleSet>
</ruleDefinition>
}

}
