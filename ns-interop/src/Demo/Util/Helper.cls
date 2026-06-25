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

/// Converts an HL7 TS value such as 20260625093000 to an IRIS logical timestamp
ClassMethod HL7ToLogicalTimestamp(pValue As %String) As %TimeStamp
{
	if $get(pValue)="" quit ""
	set tValue = $extract(pValue,1,14)
	if $length(tValue)<8 quit ""
	set tDate = $extract(tValue,1,4)_"-"_$extract(tValue,5,6)_"-"_$extract(tValue,7,8)
	set tTime = "00:00:00"
	if $length(tValue)'<10 {
		set tTime = $extract(tValue,9,10)_":"_$select($length(tValue)'<12:$extract(tValue,11,12),1:"00")_":"_$select($length(tValue)'<14:$extract(tValue,13,14),1:"00")
	}
	quit tDate_" "_tTime
}

/// Converts an ODBC date string to an IRIS logical date
ClassMethod OdbcDateToLogical(pValue As %String) As %Date
{
	if $get(pValue)="" quit ""
	quit ##class(%Library.Date).OdbcToLogical(pValue)
}

/// Converts an ODBC timestamp string to an IRIS logical timestamp
ClassMethod OdbcTimestampToLogical(pValue As %String) As %TimeStamp
{
	if $get(pValue)="" quit ""
	quit ##class(%Library.TimeStamp).OdbcToLogical(pValue)
}

}
