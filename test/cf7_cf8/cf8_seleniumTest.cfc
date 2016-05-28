<cfcomponent extends="cfselenium.CFSeleniumTestCase_Tags" >

	<cffunction name="beforeTests">
		<cfset browserUrl = "http://wiki.mxunit.org/">
		<cfset browserCommand= "*firefox">
		<cfset selenium= createObject("component","CFSelenium.selenium_tags").init("localhost", 4444)>
        <cfset assertEquals(0, Len(selenium.getSessionId()))>
		<cfset selenium.start(browserUrl,browserCommand)>
		<cfset assertFalse(Len(selenium.getSessionId()) EQ 0)>
	</cffunction>

	<cffunction name="tearDown">
        <cfset selenium.stop()>
	    <cfset assertEquals(0, len(selenium.getSessionId()))>
	</cffunction>
	
    <cffunction name="shouldBeAbleToStartAndStopABrowser">
    	// the asserts for this are in setUp and tearDown
	</cffunction>

	<cffunction name="parseCSVShouldWork">
		
		<cfset var input = "veni\, vidi\, vici,c:\\foo\\bar,c:\\I came\, I \\saw\\\, I conquered">
		<cfset var expected= ArrayNew(1)>
		<cfset ArrayAppend(expected,"veni, vidi, vici")>
		<cfset ArrayAppend(expected,"c:\foo\bar")>
		<cfset ArrayAppend(expected,"c:\i came, i \saw\, i conquered")>
		<cfset debug(selenium.parseCSV(input))>
		<cfset assertEquals(expected,selenium.parseCSV(input))>
		
		<cfset selenium.open("/pages/viewpage.action?pageId=786471")>
        <cfset debug(selenium.getAllLinks())>
        <cfset debug(selenium.getLocation())>
        <cfset debug(selenium.getBodyText())>
		
	</cffunction>
	
</cfcomponent>

