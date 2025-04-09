Class fhirdemo.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="fhirdemo.Production" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="fhirdemo.bs.FHIRFileService" Category="FHIRClient" ClassName="fhirdemo.bs.FHIRFileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/app/data/fhir-input</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.json</Setting>
    <Setting Target="Host" Name="TargetConfigNames">fhirdemo.bp.FileToFHIRServer</Setting>
  </Item>
  <Item Name="HS.Util.Trace.Operations" Category="FHIRRequestProcessing,FHIRClient" ClassName="HS.Util.Trace.Operations" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="fhirdemo.bp.FileToFHIRServer" Category="FHIRClient" ClassName="fhirdemo.bp.FileToFHIRServer" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="InteropService" Category="FHIRRequestProcessing" ClassName="HS.FHIRServer.Interop.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">fhirdemo.bp.FHIRHandler</Setting>
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
  </Item>
  <Item Name="DummyLogOperation" Category="FHIRRequestProcessing" ClassName="EnsLib.File.PassthroughOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="fhirdemo.bp.FHIRHandler" Category="FHIRRequestProcessing" ClassName="fhirdemo.bp.FHIRHandler" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="FHIRServer Operation" Category="" ClassName="HS.FHIRServer.Interop.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="TraceOperations">*FULL*</Setting>
  </Item>
</Production>
}

}
