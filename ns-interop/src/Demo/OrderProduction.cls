Class Demo.OrderProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Demo.OrderProduction" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="HIS Order API In" Category="" ClassName="Demo.HIS.BS.OrderAPI" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HIS Order Process" Category="" ClassName="Demo.HIS.BP.OrderProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="LAB HL7 File Out" Category="" ClassName="EnsLib.HL7.Operation.FileOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/app/test/out</Setting>
    <Setting Target="Host" Name="DefCharEncoding">utf-8</Setting>
    <Setting Target="Host" Name="Filename">ORMO01_%Q%!+(_a).hl7</Setting>
    <Setting Target="Adapter" Name="Charset">utf-8</Setting>
    <Setting Target="Adapter" Name="Overwrite">1</Setting>
  </Item>
  <Item Name="JavaGateway" Category="" ClassName="EnsLib.JavaGateway.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ClassPath">/app/install/mysql-connector-j-8.4.0.jar</Setting>
  </Item>
  <Item Name="LAB Catalog SQL" Category="" ClassName="EnsLib.SQL.Operation.GenericOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="Credentials">MySQL_User</Setting>
    <Setting Target="Adapter" Name="DSN">jdbc:mysql://mysql:3306/testdb</Setting>
    <Setting Target="Adapter" Name="JDBCDriver">com.mysql.jdbc.Driver</Setting>
    <Setting Target="Adapter" Name="JGService">JavaGateway</Setting>
    <Setting Target="Host" Name="RequestClass">Demo.LAB.Msg.CheckTestCatalogReq</Setting>
    <Setting Target="Host" Name="InputParameters">*Code</Setting>
    <Setting Target="Host" Name="Query">select Code,Name,Description,IsActive from TestCatalog where code = ?</Setting>
    <Setting Target="Host" Name="ParamSQLTypes">VARCHAR,VARCHAR,TEXT,BOOLEAN</Setting>
    <Setting Target="Host" Name="ResponseClass">Demo.LAB.Msg.CheckTestCatalogRsp</Setting>
  </Item>
  <Item Name="LAB HL7 File In" Category="" ClassName="EnsLib.HL7.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MessageSchemaCategory">2.5</Setting>
    <Setting Target="Adapter" Name="FilePath">/app/test/in</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.hl7</Setting>
    <Setting Target="Host" Name="TargetConfigNames">LAB HL7 Router In</Setting>
  </Item>
  <Item Name="LAB HL7 Router In" Category="" ClassName="EnsLib.HL7.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="BusinessRuleName">Demo.LAB.Rule.RouterIn</Setting>
  </Item>
  <Item Name="LAB Result Process" Category="" ClassName="Demo.LAB.BP.ResultProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="RuleLogging">a</Setting>
  </Item>
  <Item Name="HIS Result Soap Out" Category="" ClassName="Demo.HIS.WSC.ResultService.BO.ResultSoapServiceSoap" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="SOAPCredentials">HISWS_User</Setting>
    <Setting Target="Adapter" Name="WebServiceURL">http://localhost:52773/csp/user/Demo.HIS.ResultSoapService.cls</Setting>
  </Item>
</Production>
}

}
