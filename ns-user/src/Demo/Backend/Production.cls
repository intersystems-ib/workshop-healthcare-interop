Class Demo.Backend.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Demo.Backend.Production" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="LAB HL7 TCP In From Interop" Category="LabWorkflow" ClassName="EnsLib.HL7.Service.TCPService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="MessageSchemaCategory">2.5.1</Setting>
    <Setting Target="Adapter" Name="Port">62000</Setting>
    <Setting Target="Host" Name="TargetConfigNames">LAB HL7 File Out</Setting>
    <Setting Target="Host" Name="ArchiveIO">1</Setting>
    <Setting Target="Host" Name="LocalFacilityApplication">ISC:LAB</Setting>
  </Item>
  <Item Name="LAB HL7 File Out" Category="LabWorkflow" ClassName="EnsLib.HL7.Operation.FileOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/app/samples/labworkflow/out</Setting>
    <Setting Target="Host" Name="DefCharEncoding">utf-8</Setting>
    <Setting Target="Host" Name="Filename">ORMO01_%Q%!+(_a).hl7</Setting>
    <Setting Target="Adapter" Name="Charset">utf-8</Setting>
    <Setting Target="Adapter" Name="Overwrite">1</Setting>
  </Item>
  <Item Name="LAB HL7 File In" Category="LabWorkflow" ClassName="EnsLib.HL7.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MessageSchemaCategory">2.5</Setting>
    <Setting Target="Adapter" Name="FilePath">/app/samples/labworkflow/in</Setting>
    <Setting Target="Adapter" Name="ArchivePath">/app/samples/labworkflow/inarchive</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.hl7</Setting>
    <Setting Target="Host" Name="TargetConfigNames">LAB HL7 TCP Out To Interop</Setting>
  </Item>
  <Item Name="LAB HL7 TCP Out To Interop" Category="LabWorkflow" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">localhost</Setting>
    <Setting Target="Adapter" Name="Port">62001</Setting>
  </Item>
  <Item Name="PACS HL7 TCP In From Interop" Category="EventBridge" ClassName="EnsLib.HL7.Service.TCPService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MessageSchemaCategory">2.5</Setting>
    <Setting Target="Adapter" Name="Port">62010</Setting>
    <Setting Target="Host" Name="TargetConfigNames">PACS HL7 File Out</Setting>
    <Setting Target="Host" Name="LocalFacilityApplication">ISC:PACS</Setting>
  </Item>
  <Item Name="PACS HL7 File Out" Category="EventBridge" ClassName="EnsLib.HL7.Operation.FileOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/app/samples/eventbridge/out</Setting>
    <Setting Target="Host" Name="DefCharEncoding">utf-8</Setting>
    <Setting Target="Host" Name="Filename">EventBridge_%Q%!+(_a).hl7</Setting>
    <Setting Target="Adapter" Name="Charset">utf-8</Setting>
    <Setting Target="Adapter" Name="Overwrite">1</Setting>
  </Item>
  <Item Name="PACS HL7 File In" Category="EventBridge" ClassName="EnsLib.HL7.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MessageSchemaCategory">2.5</Setting>
    <Setting Target="Adapter" Name="FilePath">/app/samples/eventbridge/in</Setting>
    <Setting Target="Adapter" Name="ArchivePath">/app/samples/eventbridge/inarchive</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.hl7</Setting>
    <Setting Target="Host" Name="TargetConfigNames">PACS HL7 TCP Out To Interop</Setting>
  </Item>
  <Item Name="PACS HL7 TCP Out To Interop" Category="EventBridge" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">localhost</Setting>
    <Setting Target="Adapter" Name="Port">62011</Setting>
  </Item>
</Production>
}

}
