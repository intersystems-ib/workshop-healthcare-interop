/// SQL polling service for the EventBridge demo.
/// It reads pending rows from the external HIS table and turns each row
/// into a lightweight canonical request sent to the business process.
Class Demo.EventBridge.BS.PendingRequestService Extends Ens.BusinessService
{

Parameter ADAPTER = "EnsLib.SQL.InboundAdapter";

/// Called by the SQL inbound adapter for each row returned by the poll query.
/// The row has already been marked as PROCESSING by the adapter DeleteQuery.
Method OnProcessInput(pInput As EnsLib.SQL.Snapshot, Output pOutput As %RegisteredObject, ByRef pHint As %String) As %Status
{
	set sc = $$$OK
	try {
		// Build the canonical request from the polled SQL row.
		set interopRequest = ..BuildInteropRequest(pInput)
		
		// Forward the canonical request to the router.
		$$$ThrowOnError(..SendRequestAsync("EventBridge Router", interopRequest))
	} catch ex {
		set sc = ex.AsStatus()
	}
	quit sc
}

/// Builds the canonical request using only the identifiers and routing metadata
/// returned by the poll query. Full patient / visit / order details are loaded later.
Method BuildInteropRequest(pRow As EnsLib.SQL.Snapshot) As Demo.EventBridge.Msg.InteropRequest
{
	set req = ##class(Demo.EventBridge.Msg.InteropRequest).%New()
	set req.Info = ##class(Demo.EventBridge.Msg.InteropInfo).%New()

	// Copy the basic request metadata read by the SQL poll query.
	set req.Info.RequestId = pRow.Get("RequestId")
	set req.Info.RequestType = pRow.Get("RequestType")
	set req.Info.SourceSystem = pRow.Get("SourceSystem")
	set req.Info.TargetSystem = pRow.Get("TargetSystem")
	set req.Info.Status = "PROCESSING"
	set req.Info.EventDateTime = pRow.Get("EventDateTime")

	// Only the ids are needed at this stage.
	// The process will call the SQL BO later to enrich the request with details.
	set req.Info.Patient = ##class(Demo.EventBridge.Msg.PatientInfo).%New()
	set req.Info.Patient.PatientId = pRow.Get("PatientId")

	set req.Info.Visit = ##class(Demo.EventBridge.Msg.VisitInfo).%New()
	set req.Info.Visit.VisitId = pRow.Get("VisitId")

	set orderId = pRow.Get("OrderId")
	if orderId'="" {
		set req.Info.Order = ##class(Demo.EventBridge.Msg.OrderInfo).%New()
		set req.Info.Order.OrderId = orderId
	}

	quit req
}

}
