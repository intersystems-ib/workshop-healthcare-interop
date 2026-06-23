Class Demo.EventBridge.BP.InteropRequestProcess Extends Ens.BusinessProcessBPL
{

XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Demo.EventBridge.Msg.InteropRequest' response='Ens.Response' height='2200' width='2200' >
<context>
<property name='interopRsp' type='Demo.EventBridge.Msg.InteropResponse' instantiate='0' />
<property name='hl7' type='EnsLib.HL7.Message' instantiate='0' />
<property name='dtlClass' type='%String' instantiate='0' />
</context>
<sequence xend='200' yend='1400' >
<call name='Get HIS Details' target='HIS SQL Out' async='0' timeout='15' xpos='200' ypos='350' >
<request type='Demo.EventBridge.Msg.InteropRequest' >
<assign property='callrequest' value='request' action='set' />
</request>
<response type='Demo.EventBridge.Msg.InteropResponse' >
<assign property='context.interopRsp' value='callresponse' action='set' />
</response>
</call>
<assign name='Select DTL Class' property='context.dtlClass' value='$select(request.Info.RequestType=&quot;ADT_A08&quot;:&quot;Demo.EventBridge.DT.PACS.InteropRequestToADTA08&quot;,1:&quot;Demo.EventBridge.DT.PACS.InteropRequestToORMO01&quot;)' action='set' />
<transform name='Canonical To HL7' class='@context.dtlClass' source='context.interopRsp' target='context.hl7' xpos='200' ypos='550' />
<call name='Send HL7 To PACS' target='PACS HL7 File Out' async='0' timeout='15' xpos='200' ypos='700' >
<request type='EnsLib.HL7.Message' >
<assign property='callrequest' value='context.hl7' action='set' />
</request>
</call>
<call name='Update HIS Status' target='HIS SQL Out' async='0' timeout='15' xpos='200' ypos='950' >
<request type='Demo.EventBridge.Msg.UpdateRequestStatusReq' >
<assign property='callrequest' value='##class(Demo.EventBridge.Msg.UpdateRequestStatusReq).%New()' action='set' />
<assign property='callrequest.Status' value='"SENT"' action='set' />
<assign property='callrequest.MarkProcessed' value='1' action='set' />
<assign property='callrequest.RequestId' value='context.interopRsp.Info.RequestId' action='set' />
</request>
</call>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
