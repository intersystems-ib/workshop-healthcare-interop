Class Demo.HIS.BS.OrderAPI Extends (%CSP.REST, Ens.BusinessService)
{

Parameter HandleCorsRequest = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Method="POST" Url = "/order" Call = "NewOrder" />
</Routes>
}

/// Common config
ClassMethod OnPreDispatch(pUrl As %String, pMethod As %String, ByRef pContinue As %Boolean) As %Status
{
    set %response.ContentType = "application/json"
    quit $$$OK
}

/// New Order
ClassMethod NewOrder()
{
    set ret = $$$OK

    try {
        // request body
        set body = %request.Content

        // instantiate Order from request body payload
        set msg = ##class(Demo.HIS.Msg.OrderReq).%JSONNew()
        $$$ThrowOnError(msg.%JSONImport(body)) 

        // instatiate interop business service and send to ingestion process
        $$$ThrowOnError(##class(Ens.Director).CreateBusinessService("HIS Order API In", .service))
        $$$ThrowOnError(service.SendRequestAsync("HIS Order Process", msg))
        
        // response status
        set %response.Status = "201"
        write {"result": "order created"}.%ToJSON()

    } catch ex {
        set ret = ex.AsStatus()
        set %response.Status = 500
    }

    quit ret
}

}
