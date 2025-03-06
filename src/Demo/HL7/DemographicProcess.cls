/// 
Class Demo.HL7.DemographicProcess Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='EnsLib.HL7.Message' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='hl7' type='EnsLib.HL7.Message' instantiate='0' />
</context>
<sequence xend='200' yend='1050' >
<scope xpos='200' ypos='250' xend='200' yend='950' >
<transform name='Extract Demographics' class='Demo.HL7.MsgRouter.ADTLastNameTransform' source='request' target='hl7' xpos='200' ypos='350' />
<if name='Priority ?' condition='1' xpos='200' ypos='450' xend='200' yend='700' >
<true>
<call name='Priority Operation' target='Priority_FileOperation' async='1' xpos='470' ypos='600' >
<request type='EnsLib.HL7.Message' >
<assign property="callrequest" value="context.hl7" action="set" languageOverride="" />
</request>
</call>
</true>
<false>
<call name='Regular Operation' target='Regular_FileOperation' async='1' xpos='200' ypos='600' >
<request type='EnsLib.HL7.Message' >
<assign property="callrequest" value="context.hl7" action="set" languageOverride="" />
</request>
</call>
</false>
</if>
<faulthandlers>
<catchall xpos='200' ypos='800' xend='200' yend='250' />
</faulthandlers>
</scope>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
