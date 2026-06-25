/// Receives PACS ORU^R01 reports, transforms them to the generated SOAP request,
/// and calls the simulated HIS SOAP service.
Class Demo.EventBridge.PACS.BP.HISReportProcess Extends Ens.BusinessProcessBPL
{

XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='EnsLib.HL7.Message' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='submitReportReq' type='Demo.EventBridge.HIS.WSC.Msg.SubmitReportRequest' instantiate='0' />
<property name='submitReportRsp' type='Demo.EventBridge.HIS.WSC.Msg.SubmitReportResponse' instantiate='0' />
</context>
<sequence xend='200' yend='550' >
<transform name='HL7 To HIS Report' class='Demo.EventBridge.PACS.DT.HIS.ORUR01ToSubmitReportRequest' source='request' target='context.submitReportReq' xpos='200' ypos='250' >
<annotation><![CDATA[ORU^R01 To HIS Report SOAP Request]]></annotation>
</transform>
<call name='Send Report To HIS' target='HIS Report SOAP Out' async='0' timeout='15' xpos='200' ypos='350' >
<annotation><![CDATA[Call the generated HIS SOAP client BO]]></annotation>
<request type='Demo.EventBridge.HIS.WSC.Msg.SubmitReportRequest' >
<assign property='callrequest' value='context.submitReportReq' action='set' />
</request>
<response type='Demo.EventBridge.HIS.WSC.Msg.SubmitReportResponse' >
<assign property='context.submitReportRsp' value='callresponse' action='set' />
</response>
</call>
<trace name='Trace Response' value='"Received: "_context.submitReportRsp.SubmitReportResult' xpos='200' ypos='450' />
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
