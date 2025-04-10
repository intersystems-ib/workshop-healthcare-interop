Include Ensemble

Class Demo.Util.Helper Extends %RegisteredObject
{

/// Returns current date time in HL7 format
ClassMethod HL7CurrentDateTime() As %String
{
    quit $translate($zdatetime($horolog,8)," :")
}

/// Converts a Date to HL7 Date
ClassMethod DateToHL7Date(pDate As %Date) As %String
{
	if pDate="" quit ""
	set ret = ""
	try {
		set ret = $zdate(pDate, 8)
	} catch ex {
		$$$LOGERROR($$$CurrentMethod_": "_ex.DisplayString())
	}
	quit ret
}

/// Converts a TimeStamp to HL7 Date Time
ClassMethod DateToHL7DateTime(pDate As %Date) As %String
{
	if pDate="" quit ""
	set ret = ""
	try {
		set ret = $translate(pDate, " -:T", "")
	} catch ex {
		$$$LOGERROR($$$CurrentMethod_": "_ex.DisplayString())
	}
	quit ret
}

}
