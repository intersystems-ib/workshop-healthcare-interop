Class Demo.EventBridge.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Demo.EventBridge.Production" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="HIS Pending Request In" Category="Order" ClassName="Demo.EventBridge.BS.PendingRequestService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
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
  <Item Name="EventBridge Router" Category="Order" ClassName="EnsLib.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="BusinessRuleName">Demo.EventBridge.Rule.RouteByTargetSystem</Setting>
  </Item>
  <Item Name="HIS PACS Process" Category="Order" ClassName="Demo.EventBridge.BP.HISPACSProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="JavaGateway" Category="" ClassName="EnsLib.JavaGateway.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ClassPath">/app/install/mysql-connector-j-8.4.0.jar</Setting>
    <Setting Target="Host" Name="%gatewayName">%Java Server</Setting>
  </Item>
  <Item Name="HIS SQL Out" Category="Order" ClassName="Demo.EventBridge.BO.ExternalHISSQL" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="Credentials">MySQL_User</Setting>
    <Setting Target="Adapter" Name="DSN">jdbc:mysql://mysql:3306/testdb</Setting>
    <Setting Target="Adapter" Name="JDBCDriver">com.mysql.jdbc.Driver</Setting>
    <Setting Target="Adapter" Name="JGService">JavaGateway</Setting>
    <Setting Target="Adapter" Name="JDBCClasspath">/app/install/mysql-connector-j-8.4.0.jar</Setting>
  </Item>
  <Item Name="PACS TCP Out" Category="Order" ClassName="EnsLib.HL7.Operation.TCPOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="IPAddress">localhost</Setting>
    <Setting Target="Adapter" Name="Port">62010</Setting>
    <Setting Target="Host" Name="ArchiveIO">1</Setting>
  </Item>
  <Item Name="PACS TCP In" Category="Result" ClassName="EnsLib.HL7.Service.TCPService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MessageSchemaCategory">2.5</Setting>
    <Setting Target="Adapter" Name="Port">62011</Setting>
    <Setting Target="Host" Name="TargetConfigNames">PACS HL7 Router In</Setting>
    <Setting Target="Host" Name="ArchiveIO">1</Setting>
    <Setting Target="Host" Name="LocalFacilityApplication">ISC:IRIS</Setting>
  </Item>
  <Item Name="PACS HL7 Router In" Category="Result" ClassName="EnsLib.HL7.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="BusinessRuleName">Demo.EventBridge.PACS.Rule.RouterIn</Setting>
  </Item>
  <Item Name="PACS HIS Process" Category="Result" ClassName="Demo.EventBridge.PACS.BP.HISReportProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="HIS Report SOAP Out" Category="Result" ClassName="Demo.EventBridge.HIS.WSC.BO.ReportServiceSoap" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="WebServiceURL">http://localhost:52773/csp/user/Demo.EventBridge.HIS.ReportService.cls</Setting>
    <Setting Target="Adapter" Name="SOAPCredentials">HISWS_User</Setting>
  </Item>
</Production>
}

}
