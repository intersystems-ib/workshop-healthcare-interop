Class Demo.EventBridge.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Demo.EventBridge.Production" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="HIS Pending Request In" Category="EventBridge" ClassName="Demo.EventBridge.BS.PendingRequestService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="Credentials">MySQL_User</Setting>
    <Setting Target="Adapter" Name="CallInterval">5</Setting>
    <Setting Target="Adapter" Name="DSN">jdbc:mysql://mysql:3306/testdb</Setting>
    <Setting Target="Adapter" Name="DeleteQuery">update external_his.IntegrationRequest set Status = 'PROCESSING', UpdatedAt = now() where RequestId = ?</Setting>
    <Setting Target="Adapter" Name="JDBCClasspath">/app/install/mysql-connector-j-8.4.0.jar</Setting>
    <Setting Target="Adapter" Name="JDBCDriver">com.mysql.jdbc.Driver</Setting>
    <Setting Target="Adapter" Name="JGService">JavaGateway</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">RequestId</Setting>
    <Setting Target="Adapter" Name="Query">select RequestId,RequestType,SourceSystem,TargetSystem,PatientId,VisitId,coalesce(OrderId,'') as OrderId,EventDateTime from external_his.IntegrationRequest where Status = 'PENDING' order by CreatedAt asc limit 5</Setting>
    <Setting Target="Adapter" Name="StayConnected">300</Setting>
  </Item>
  <Item Name="EventBridge Router" Category="EventBridge" ClassName="EnsLib.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="BusinessRuleName">Demo.EventBridge.Rule.RouteByTargetSystem</Setting>
  </Item>
  <Item Name="HIS PACS Process" Category="EventBridge" ClassName="Demo.EventBridge.BP.HISPACSProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="JavaGateway" Category="" ClassName="EnsLib.JavaGateway.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ClassPath">/app/install/mysql-connector-j-8.4.0.jar</Setting>
    <Setting Target="Host" Name="%gatewayName">%Java Server</Setting>
  </Item>
  <Item Name="HIS SQL Out" Category="SQL" ClassName="Demo.EventBridge.BO.ExternalHISSQL" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="Credentials">MySQL_User</Setting>
    <Setting Target="Adapter" Name="DSN">jdbc:mysql://mysql:3306/testdb</Setting>
    <Setting Target="Adapter" Name="JDBCDriver">com.mysql.jdbc.Driver</Setting>
    <Setting Target="Adapter" Name="JGService">JavaGateway</Setting>
    <Setting Target="Adapter" Name="JDBCClasspath">/app/install/mysql-connector-j-8.4.0.jar</Setting>
  </Item>
  <Item Name="PACS HL7 File Out" Category="PACS" ClassName="EnsLib.HL7.Operation.FileOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/app/samples/eventbridge/out</Setting>
    <Setting Target="Host" Name="DefCharEncoding">utf-8</Setting>
    <Setting Target="Host" Name="Filename">EventBridge_%Q%!+(_a).hl7</Setting>
    <Setting Target="Adapter" Name="Charset">utf-8</Setting>
    <Setting Target="Adapter" Name="Overwrite">1</Setting>
  </Item>
  <Item Name="PACS HL7 File In" Category="PACS" ClassName="EnsLib.HL7.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MessageSchemaCategory">2.5</Setting>
    <Setting Target="Adapter" Name="FilePath">/app/samples/eventbridge/in</Setting>
    <Setting Target="Adapter" Name="ArchivePath">/app/samples/eventbridge/inarchive</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.hl7</Setting>
    <Setting Target="Host" Name="TargetConfigNames">PACS HL7 Router In</Setting>
  </Item>
  <Item Name="PACS HL7 Router In" Category="PACS" ClassName="EnsLib.HL7.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="BusinessRuleName">Demo.EventBridge.PACS.Rule.RouterIn</Setting>
  </Item>
  <Item Name="PACS HIS Process" Category="PACS" ClassName="Demo.EventBridge.PACS.BP.HISReportProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="HIS Report SOAP Out" Category="HIS" ClassName="Demo.EventBridge.HIS.WSC.BO.ReportServiceSoap" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="WebServiceURL">http://localhost:52773/csp/user/Demo.EventBridge.HIS.ReportService.cls</Setting>
    <Setting Target="Adapter" Name="SOAPCredentials">HISWS_User</Setting>
  </Item>
</Production>
}

}
