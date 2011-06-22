<!---TODO: I need my own version of CFSeleniumTestCase that calls the selenium_tags.cfc (and maybe defines "variables"?)--->
<cfcomponent extends="cfselenium.CFSeleniumTestCase_Tags">
	
	<cffunction name="beforeTests">
		<cfset browserURL= "http://github.com/">
		<cfset super.beforeTests()>
	</cffunction>		
			
	<cffunction name="testForReadmePage">
		<cfset variables.selenium.open("/bobsilverberg/CFSelenium")>
		<cfset assertEquals("bobsilverberg/CFSelenium - GitHub", selenium.getTitle())>
		<cfset variables.selenium.click("link=readme.md")>
		<cfset variables.selenium.waitForPageToLoad("30000")>
		<cfset sleep(1000)>
		<cfset assertEquals("readme.md at master from bobsilverberg/cfselenium - github", variables.selenium.getTitle())>
		<cfset variables.selenium.click("raw-url")>
		<cfset variables.selenium.waitForPageToLoad("30000")>
		<cfset assertEquals("", variables.selenium.getTitle())>
		<cfset assertTrue(variables.selenium.isTextPresent("[CFSelenium]"))>
	</cffunction>
	
</cfcomponent>
