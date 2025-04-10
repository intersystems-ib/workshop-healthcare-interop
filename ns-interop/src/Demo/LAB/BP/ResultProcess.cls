/// 
Class Demo.LAB.BP.ResultProcess Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='EnsLib.HL7.Message' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='hisResultReq' type='Demo.HIS.WSC.ResultService.Msg.NewResultRequest' instantiate='0' />
<property name='resultRsp' type='Demo.HIS.WSC.ResultService.Msg.NewResultResponse' instantiate='0' />
</context>
<sequence xend='200' yend='550' >
<transform name='HL7 To HIS Result' class='Demo.LAB.DT.HIS.ORUR01ToNewResult' source='request' target='context.hisResultReq' xpos='200' ypos='250' >
<annotation><![CDATA[ORU^R01 To HIS Soap Request]]></annotation>
</transform>
<call name='Send result to HIS' target='HIS Result Soap Out' async='0' timeout='5' xpos='200' ypos='350' >
<annotation><![CDATA[Call HIS Result WebService]]></annotation>
<request type='Demo.HIS.WSC.ResultService.Msg.NewResultRequest' >
<assign property="callrequest" value="context.hisResultReq" action="set" languageOverride="" />
</request>
<response type='Demo.HIS.WSC.ResultService.Msg.NewResultResponse' >
<assign property="context.resultRsp" value="callresponse" action="set" languageOverride="" />
</response>
</call>
<trace name='Trace' value='"Received: "_context.resultRsp.NewResultResult' xpos='200' ypos='450' />
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
