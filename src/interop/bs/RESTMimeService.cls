/// Example of REST service that receives DICOM files as MIME attachments
Class interop.bs.RESTMimeService Extends (Ens.BusinessService, %CSP.REST)
{

XData UrlMap
{
<Routes>
    <Route Url="/studies" Method="POST" Call="NewStudy"/>
</Routes>
}

ClassMethod NewStudy() As %Status
{
    set ret = $$$OK

    try {
        // for each mime data
        set mimeName = %request.NextMimeData("")
        while (mimeName'="") {
            // retrieve mime data
            set mimeData = %request.GetMimeData(mimeName)

            // get some attributes
            set contentType = mimeData.Attributes("ContentType")
            
            // do something with data
            if (contentType = "application/dicom") {
                set sc = ##class(EnsLib.DICOM.Document).CreateFromDicomFileStream(mimeData, .dicom)
                $$$ThrowOnError(sc)

                // print some dicom content
                write { "DataSet.PatientName": (dicom.GetValueAt("DataSet.PatientName")) }.%ToJSON(),!

                // here you can instatiate Business Service and send messages to other interop components
                $$$ThrowOnError(##class(Ens.Director).CreateBusinessService("REST Mime Service",.service))
                $$$ThrowOnError(service.OnProcessInput(dicom))
            }

            // next mime data
            set mimeName = %request.NextMimeData(mimeName)            
        }

    } catch ex {
        set ret = ex.AsStatus()
    }
    quit ret
}

/// Override this method to process incoming data. Do not call SendRequestSync/Async() from outside this method (e.g. in a SOAP Service or a CSP page).
Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject, ByRef pHint As %String) As %Status
{
	set ret = $$$OK
    try {
        $$$ThrowOnError(..SendRequestAsync("Dummy Process", pInput))

    } catch ex {
        set ret = ex.AsStatus()
    }
    quit ret
}

}
