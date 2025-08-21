/// 
Class fhirdemo.bp.FHIRPatientHandler Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='EnsLib.HL7.Message' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='patientRequest' type='HS.FHIRServer.Interop.Request' instantiate='1' />
<property name='patientResponse' type='HS.FHIRServer.Interop.Response' instantiate='1' />
<property name='patientId' type='%Integer' initialexpression='0' instantiate='0' />
<property name='SDAMessage' type='%Stream.GlobalCharacter' instantiate='0' />
<property name='FHIRMessage' type='%DynamicObject' instantiate='0' />
<property name='index' type='%Integer' initialexpression='1' instantiate='0' />
<property name='patientResource' type='%DynamicObject' instantiate='0' />
<property name='patientMRN' type='%Integer' instantiate='0' />
</context>
<sequence xend='200' yend='1300' >
<code name='De HL7 a FHIR' xpos='200' ypos='250' >
<annotation><![CDATA[Transformación de HL7 v2.5.1 a SDA]]></annotation>
<![CDATA[ 
 do ##class(HS.Gateway.HL7.HL7ToSDA3).GetSDA(request, .SDAMessageTemp)
 set SDAToFHIR = ##class(HS.FHIR.DTL.Util.API.Transform.SDA3ToFHIR).TransformStream(SDAMessageTemp,"HS.SDA3.Container","R4")
 set context.FHIRMessage = SDAToFHIR.bundle
 $$$TRACE("Valor: "_SDAToFHIR.bundle.%ToJSON())
]]>
</code>
<code name='Extracción de recurso Patient' xpos='200' ypos='350' >
<![CDATA[ Set array = context.FHIRMessage.entry.%GetIterator()
 While array.%GetNext(.key, .value) {
   if (value.resource.resourceType = "Patient") {
     set context.patientResource = value.resource
     Set arrayIdentifier = value.resource.identifier.%GetIterator()
     While arrayIdentifier.%GetNext(.keyIdentifier, .valueIdentifier)
     {
       if (valueIdentifier.type.text = "NNESP")
       {
         set context.patientMRN = valueIdentifier.value
       }
     }
     break
   }
 }]]>
</code>
<code name='Búsqueda de paciente' xpos='200' ypos='450' >
<annotation><![CDATA[Creación del objeto de la solicitud]]></annotation>
<![CDATA[ Set context.patientId = 0
 Set context.patientRequest.Request.RequestMethod = "GET"
 Set context.patientRequest.Request.RequestPath = "Patient"
 Set context.patientRequest.Request.QueryString = "identifier="_context.patientMRN
 Set context.patientRequest.Request.RequestFormatCode= "JSON"
 Set context.patientRequest.Request.SessionApplication = "/csp/healthshare/fhirrepo/fhir/r4"
 Set context.patientRequest.Request.IsRecursive = 0
 Set qs=##class(HS.SDA3.QuickStream).%New()
 Set context.patientRequest.QuickStreamId = qs.%Id()]]>
</code>
<call name='Consulta a repositorio' target='FHIRServer Operation' async='0' xpos='200' ypos='550' >
<request type='HS.FHIRServer.Interop.Request' >
<assign property="callrequest" value="context.patientRequest" action="set" languageOverride="" />
</request>
<response type='HS.FHIRServer.Interop.Response' >
<assign property="context.patientResponse" value="callresponse" action="set" languageOverride="" />
</response>
</call>
<code name='Comprueba paciente' xpos='200' ypos='650' >
<![CDATA[ set stream = ##class(HS.SDA3.QuickStream).%OpenId(context.patientResponse.QuickStreamId,, .tSC)

 set quickStreamIn = ##class(HS.SDA3.QuickStream).%OpenId(context.patientResponse.QuickStreamId,, .tSC)
        
 set dynamicBundle = ##class(%DynamicAbstractObject).%FromJSON(quickStreamIn)
 
 if ($ISOBJECT(dynamicBundle.entry))
 {
   set entryIterator = dynamicBundle.entry.%GetIterator()

   while entryIterator.%GetNext(.key, .value)
   {
     set context.patientId = value.resource.id
   }
 }
 ]]>
</code>
<if name='¿Existe paciente?' condition='context.patientId &gt; 0' xpos='200' ypos='750' xend='200' yend='1000' >
<annotation><![CDATA[Validación de paciente
]]></annotation>
<true>
<code name='Actualiza paciente' xpos='470' ypos='900' >
<annotation><![CDATA[Genera solicitud de actualización]]></annotation>
<![CDATA[ Set context.patientRequest.Request.RequestMethod = "PUT"
 Set context.patientRequest.Request.RequestPath = "Patient/"_context.patientId
 Set context.patientRequest.Request.RequestFormatCode= "JSON"
 Set context.patientRequest.Request.SessionApplication = "/csp/healthshare/fhirrepo/fhir/r4"
 Set context.patientRequest.Request.IsRecursive = 0]]>
</code>
</true>
<false>
<code name='Crea paciente' xpos='200' ypos='900' >
<annotation><![CDATA[Genera solicitud de creación]]></annotation>
<![CDATA[ Set context.patientRequest.Request.RequestMethod = "POST"
 Set context.patientRequest.Request.RequestPath = "Patient"
 Set context.patientRequest.Request.RequestFormatCode= "JSON"
 Set context.patientRequest.Request.SessionApplication = "/csp/healthshare/fhirrepo/fhir/r4"
 Set context.patientRequest.Request.IsRecursive = 0]]>
</code>
</false>
</if>
<code name='Transformación en Stream' xpos='200' ypos='1100' >
<annotation><![CDATA[Se almacena el recurso como stream
]]></annotation>
<![CDATA[ set qs=##class(HS.SDA3.QuickStream).%New()
 set context.patientRequest.QuickStreamId = qs.%Id()
 Set tempStream = ##class(%Stream.TmpCharacter).%New()
 do context.patientResource.%ToJSON(tempStream)
 do qs.CopyFrom(tempStream)
 ]]>
</code>
<call name='Envío a repositorio' target='FHIRServer Operation' async='0' xpos='200' ypos='1200' >
<request type='HS.FHIRServer.Interop.Request' >
<assign property="callrequest" value="context.patientRequest" action="set" languageOverride="" />
</request>
<response type='HS.FHIRServer.Interop.Response' >
<assign property="context.patientResponse" value="callresponse" action="set" languageOverride="" />
</response>
</call>
</sequence>
</process>
}

}
