/// SQL BO used by the EventBridge demo to enrich canonical requests and update source row status.
Class Demo.EventBridge.BO.ExternalHISSQL Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

/// Enrich the canonical request with patient / visit / order data from the external HIS.
Method GetDetails(pRequest As Demo.EventBridge.Msg.InteropRequest, Output pResponse As Demo.EventBridge.Msg.InteropResponse) As %Status
{
	set pResponse = ##class(Demo.EventBridge.Msg.InteropResponse).%New()
	set pResponse.Info = ..CloneInfo(pRequest.Info)

	if pRequest.Info.RequestType="ADT_A08" {
		quit ..GetDetailsADT(pRequest, .pResponse)
	}

	if pRequest.Info.RequestType="ORM_O01" {
		quit ..GetDetailsORM(pRequest, .pResponse)
	}

	quit $$$ERROR($$$GeneralError, "Unsupported request type: "_pRequest.Info.RequestType)
}

/// Query external HIS details for an ADT update.
Method GetDetailsADT(pRequest As Demo.EventBridge.Msg.InteropRequest, Output pResponse As Demo.EventBridge.Msg.InteropResponse) As %Status
{
	set sc = $$$OK
	try {
		#dim rs As EnsLib.SQL.GatewayResultSet
		set sql = "select p.PatientId,p.MRN,p.AssigningAuthority,p.LastName,p.FirstName,coalesce(p.MiddleName,'') as MiddleName,p.BirthDate,p.Sex,coalesce(p.PhoneNumber,'') as PhoneNumber,coalesce(p.AddressLine1,'') as AddressLine1,coalesce(p.City,'') as City,coalesce(p.StateCode,'') as StateCode,coalesce(p.PostalCode,'') as PostalCode,v.VisitId,v.VisitNumber,v.PatientClass,coalesce(v.AssignedLocation,'') as AssignedLocation,coalesce(v.Room,'') as Room,coalesce(v.Bed,'') as Bed,coalesce(v.AttendingId,'') as AttendingId,coalesce(v.AttendingLastName,'') as AttendingLastName,coalesce(v.AttendingFirstName,'') as AttendingFirstName,v.AdmitDateTime from external_his.IntegrationRequest r join external_his.Patient p on p.PatientId = r.PatientId join external_his.Visit v on v.VisitId = r.VisitId where r.RequestId = ?"
		$$$ThrowOnError(..Adapter.ExecuteQuery(.rs, sql, pRequest.Info.RequestId))
		if 'rs.Next() {
			$$$ThrowStatus($$$ERROR($$$GeneralError, "No external HIS detail found for request "_pRequest.Info.RequestId))
		}
		do ..MapPatientVisitData(rs, pResponse.Info)
	} catch ex {
		set sc = ex.AsStatus()
	}
	quit sc
}

/// Query external HIS details for a radiology order.
Method GetDetailsORM(pRequest As Demo.EventBridge.Msg.InteropRequest, Output pResponse As Demo.EventBridge.Msg.InteropResponse) As %Status
{
	set sc = $$$OK
	try {
		#dim rs As EnsLib.SQL.GatewayResultSet
		set sql = "select p.PatientId,p.MRN,p.AssigningAuthority,p.LastName,p.FirstName,coalesce(p.MiddleName,'') as MiddleName,p.BirthDate,p.Sex,coalesce(p.PhoneNumber,'') as PhoneNumber,coalesce(p.AddressLine1,'') as AddressLine1,coalesce(p.City,'') as City,coalesce(p.StateCode,'') as StateCode,coalesce(p.PostalCode,'') as PostalCode,v.VisitId,v.VisitNumber,v.PatientClass,coalesce(v.AssignedLocation,'') as AssignedLocation,coalesce(v.Room,'') as Room,coalesce(v.Bed,'') as Bed,coalesce(v.AttendingId,'') as AttendingId,coalesce(v.AttendingLastName,'') as AttendingLastName,coalesce(v.AttendingFirstName,'') as AttendingFirstName,v.AdmitDateTime,o.OrderId,o.PlacerOrderNumber,coalesce(o.FillerOrderNumber,'') as FillerOrderNumber,o.ServiceCode,o.ServiceText,o.PriorityCode,coalesce(o.OrderingProviderId,'') as OrderingProviderId,coalesce(o.OrderingProviderLastName,'') as OrderingProviderLastName,coalesce(o.OrderingProviderFirstName,'') as OrderingProviderFirstName,o.RequestedDateTime,coalesce(o.Modality,'') as Modality,coalesce(o.ReasonText,'') as ReasonText from external_his.IntegrationRequest r join external_his.Patient p on p.PatientId = r.PatientId join external_his.Visit v on v.VisitId = r.VisitId join external_his.RadiologyOrder o on o.OrderId = r.OrderId where r.RequestId = ?"
		$$$ThrowOnError(..Adapter.ExecuteQuery(.rs, sql, pRequest.Info.RequestId))
		if 'rs.Next() {
			$$$ThrowStatus($$$ERROR($$$GeneralError, "No external HIS detail found for request "_pRequest.Info.RequestId))
		}
		do ..MapPatientVisitData(rs, pResponse.Info)
		if '$isobject(pResponse.Info.Order) {
			set pResponse.Info.Order = ##class(Demo.EventBridge.Msg.OrderInfo).%New()
		}
		set pResponse.Info.Order.OrderId = rs.Get("OrderId")
		set pResponse.Info.Order.PlacerOrderNumber = rs.Get("PlacerOrderNumber")
		set pResponse.Info.Order.FillerOrderNumber = rs.Get("FillerOrderNumber")
		set pResponse.Info.Order.ServiceCode = rs.Get("ServiceCode")
		set pResponse.Info.Order.ServiceText = rs.Get("ServiceText")
		set pResponse.Info.Order.PriorityCode = rs.Get("PriorityCode")
		set pResponse.Info.Order.OrderingProviderId = rs.Get("OrderingProviderId")
		set pResponse.Info.Order.OrderingProviderLastName = rs.Get("OrderingProviderLastName")
		set pResponse.Info.Order.OrderingProviderFirstName = rs.Get("OrderingProviderFirstName")
		set pResponse.Info.Order.RequestedDateTime = ##class(Demo.Util.Helper).OdbcTimestampToLogical(rs.Get("RequestedDateTime"))
		set pResponse.Info.Order.Modality = rs.Get("Modality")
		set pResponse.Info.Order.ReasonText = rs.Get("ReasonText")
	} catch ex {
		set sc = ex.AsStatus()
	}
	quit sc
}

/// Update the source integration row after processing.
Method UpdateRequestStatus(pRequest As Demo.EventBridge.Msg.UpdateRequestStatusReq, Output pResponse As Ens.Response) As %Status
{
	set sc = $$$OK
	set pResponse = ##class(Ens.Response).%New()
	try {
		set sql = "update external_his.IntegrationRequest set Status = ?, ErrorText = ?, ProcessedAt = case when ? = 1 then now() else ProcessedAt end, UpdatedAt = now() where RequestId = ?"
		$$$ThrowOnError(..Adapter.ExecuteUpdate(.nrows, sql, pRequest.Status, pRequest.ErrorText, +pRequest.MarkProcessed, pRequest.RequestId))
	} catch ex {
		set sc = ex.AsStatus()
	}
	quit sc
}

/// Create a shallow copy of the canonical payload before enrichment.
Method CloneInfo(pInfo As Demo.EventBridge.Msg.InteropInfo) As Demo.EventBridge.Msg.InteropInfo
{
	set clone = ##class(Demo.EventBridge.Msg.InteropInfo).%New()
	if '$isobject(pInfo) {
		quit clone
	}
	set clone.RequestId = pInfo.RequestId
	set clone.RequestType = pInfo.RequestType
	set clone.SourceSystem = pInfo.SourceSystem
	set clone.TargetSystem = pInfo.TargetSystem
	set clone.Status = pInfo.Status
	set clone.EventDateTime = pInfo.EventDateTime
	set clone.Patient = pInfo.Patient
	set clone.Visit = pInfo.Visit
	set clone.Order = pInfo.Order
	quit clone
}

/// Copy shared patient and visit data from SQL into the canonical payload.
Method MapPatientVisitData(pRow As %RegisteredObject, pInfo As Demo.EventBridge.Msg.InteropInfo) As %Status
{
	if '$isobject(pInfo.Patient) {
		set pInfo.Patient = ##class(Demo.EventBridge.Msg.PatientInfo).%New()
	}
	if '$isobject(pInfo.Visit) {
		set pInfo.Visit = ##class(Demo.EventBridge.Msg.VisitInfo).%New()
	}
	set pInfo.Patient.PatientId = pRow.Get("PatientId")
	set pInfo.Patient.MRN = pRow.Get("MRN")
	set pInfo.Patient.AssigningAuthority = pRow.Get("AssigningAuthority")
	set pInfo.Patient.LastName = pRow.Get("LastName")
	set pInfo.Patient.FirstName = pRow.Get("FirstName")
	set pInfo.Patient.MiddleName = pRow.Get("MiddleName")
	set pInfo.Patient.BirthDate = ##class(Demo.Util.Helper).OdbcDateToLogical(pRow.Get("BirthDate"))
	set pInfo.Patient.Sex = pRow.Get("Sex")
	set pInfo.Patient.PhoneNumber = pRow.Get("PhoneNumber")
	set pInfo.Patient.AddressLine1 = pRow.Get("AddressLine1")
	set pInfo.Patient.City = pRow.Get("City")
	set pInfo.Patient.StateCode = pRow.Get("StateCode")
	set pInfo.Patient.PostalCode = pRow.Get("PostalCode")
	set pInfo.Visit.VisitId = pRow.Get("VisitId")
	set pInfo.Visit.VisitNumber = pRow.Get("VisitNumber")
	set pInfo.Visit.PatientClass = pRow.Get("PatientClass")
	set pInfo.Visit.AssignedLocation = pRow.Get("AssignedLocation")
	set pInfo.Visit.Room = pRow.Get("Room")
	set pInfo.Visit.Bed = pRow.Get("Bed")
	set pInfo.Visit.AttendingId = pRow.Get("AttendingId")
	set pInfo.Visit.AttendingLastName = pRow.Get("AttendingLastName")
	set pInfo.Visit.AttendingFirstName = pRow.Get("AttendingFirstName")
	set pInfo.Visit.AdmitDateTime = ##class(Demo.Util.Helper).OdbcTimestampToLogical(pRow.Get("AdmitDateTime"))
	quit $$$OK
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="Demo.EventBridge.Msg.InteropRequest">
    <Method>GetDetails</Method>
  </MapItem>
  <MapItem MessageType="Demo.EventBridge.Msg.UpdateRequestStatusReq">
    <Method>UpdateRequestStatus</Method>
  </MapItem>
</MapItems>
}

}
