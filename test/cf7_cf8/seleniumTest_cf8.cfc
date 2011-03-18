<cfcomponent extends="mxunit.framework.TestCase">

	<cffunction name="setUp">
		<cfset var browserUrl = "http://wiki.mxunit.org/">
        <cfset selenium = startFireFox(browserUrl)>
	</cffunction>

	<cffunction name="tearDown">
        <cfset selenium.stop()>
	    <cfset assertTrue(len(selenium.getSessionId()) eq 0)>
	</cffunction>
	
	<cffunction access="private" cfreturntype="any" name="startSelenium">
		<cfargument name="browserUrl" type="string" required="true" />
		<cfargument name="browserCommand" type="string" required="false" default="" />
		<cfset var selenium = createobject("component","CFSelenium.selenium_tags").init(arguments.browserUrl,"localhost", 4444, arguments.browserCommand)>
	    <cfset assertTrue(len(selenium.getSessionId()) eq 0)>
        <cfset selenium.start()>
	    <cfset assertFalse(len(selenium.getSessionId()) eq 0)>
	    <cfreturn selenium>
		
	</cffunction>
	
	<cffunction access="private" returntype="any" name="startFireFox">
		<cfargument name="browserUrl" type="string" required="true" />
	    <cfreturn startSelenium(arguments.browserUrl,"*firefox")>
		
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
		
	</cffunction>

	<cffunction name="testOpen">
		
		<cfset selenium.open("/pages/viewpage.action?pageId=786471")>
       <!--- <cfset assertEndsWith("html/test_open.html", selenium.getLocation())> --->
       <!--- <cfset assertEquals("This is a test of the open command.", selenium.getBodyText())> --->
        <cfset debug(selenium.getAllLinks())>
        <cfset debug(selenium.getLocation())>
        <cfset debug(selenium.getBodyText())>

	</cffunction>
	
</cfcomponent>

