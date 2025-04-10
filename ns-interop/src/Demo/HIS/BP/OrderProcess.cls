/// 
Class Demo.HIS.BP.OrderProcess Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Demo.HIS.Msg.OrderReq' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='hl7' type='EnsLib.HL7.Message' instantiate='0' />
<property name='catalogRsp' type='Demo.LAB.Msg.CheckTestCatalogRsp' instantiate='0' />
</context>
<sequence xend='200' yend='900' >
<call name='Check LAB Catalog' target='LAB Catalog SQL' async='0' timeout='5' xpos='200' ypos='250' >
<annotation><![CDATA[Check Test in LAB Catalog]]></annotation>
<request type='Demo.LAB.Msg.CheckTestCatalogReq' >
<assign property="callrequest.Code" value="request.test.code" action="set" languageOverride="" />
</request>
<response type='Demo.LAB.Msg.CheckTestCatalogRsp' >
<assign property="context.catalogRsp" value="callresponse" action="set" languageOverride="" />
</response>
</call>
<if name='Test IsActive?' condition='context.catalogRsp.IsActive=1' xpos='200' ypos='350' xend='200' yend='800' >
<true>
<transform name='OrderReq to HL7' class='Demo.HIS.DT.LAB.OrderReqToORMO01' source='request' target='context.hl7' xpos='335' ypos='500' >
<annotation><![CDATA[Create ORM^O01]]></annotation>
</transform>
<transform name='LAB Catalog to HL7' class='Demo.HIS.DT.LAB.CheckCatalogRspToORMO01' source='context.catalogRsp' target='context.hl7' xpos='335' ypos='600' >
<annotation><![CDATA[Add Catalog Info to ORM^O01]]></annotation>
</transform>
<call name='Send to LAB' target='LAB HL7 File Out' async='1' xpos='335' ypos='700' >
<request type='EnsLib.HL7.Message' >
<assign property="callrequest" value="context.hl7" action="set" languageOverride="" />
</request>
</call>
</true>
</if>
</sequence>
</process>
}

}
