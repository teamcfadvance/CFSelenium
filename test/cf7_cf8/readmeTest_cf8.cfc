<cfcomponent extends="mxunit.framework.TestCase">
	<cffunction name="testForReadmePage">
		<cfset variables.selenium= CreateObject("component","CFSelenium.selenium_tags").init("http://github.com/")>
		<cfset variables.selenium.start()>
		<cfset variables.selenium.open("/bobsilverberg/CFSelenium")>
		<cfset assertEquals("bobsilverberg/CFSelenium - GitHub", selenium.getTitle())>
		<cfset variables.selenium.click("link=readme.md")>
		<cfset variables.selenium.waitForPageToLoad("30000")>
		<cfset assertEquals("readme.md at master from bobsilverberg/CFSelenium - GitHub", selenium.getTitle())>
		<cfset variables.selenium.click("raw-url")>
		<cfset variables.selenium.waitForPageToLoad("30000")>
		<cfset assertEquals("", selenium.getTitle())>
		<cfset assertTrue(selenium.isTextPresent("[CFSelenium]"))>
	</cffunction>
	
	<cffunction name="teardown">
		<cfset variables.selenium.stop()>
	</cffunction>
</cfcomponent>
