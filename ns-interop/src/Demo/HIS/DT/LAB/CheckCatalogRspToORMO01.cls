Class Demo.HIS.DT.LAB.CheckCatalogRspToORMO01 Extends Ens.DataTransformDTL [ DependsOn = (Demo.LAB.Msg.CheckTestCatalogRsp, EnsLib.HL7.Message) ]
{

Parameter GENERATEEMPTYSEGMENTS = 0;

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='Demo.LAB.Msg.CheckTestCatalogRsp' targetClass='EnsLib.HL7.Message' targetDocType='2.5:ORM_O01' create='existing' language='objectscript' >
<assign value='source.Name' property='target.{ORCgrp(1).OBRuniongrp.OBRunion.OBR:UniversalServiceIdentifier.Text}' action='set' />
<assign value='source.Description' property='target.{ORCgrp(1).OBRuniongrp.OBRunion.OBR:UniversalServiceIdentifier.AlternateText}' action='set' />
</transform>
}

}
