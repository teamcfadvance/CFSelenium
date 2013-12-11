<!---TODO: I need my own version of CFSeleniumTestCase that calls the selenium_tags.cfc (and maybe defines "variables"?)--->
<cfcomponent extends="CFSeleniumTestCase_Tags">
	
	<cffunction name="beforeTests">
		<cfset browserURL= "http://github.com/">
		<cfset super.beforeTests()>
	</cffunction>		
			
	<cffunction name="testForReadmePage">
		<cfset variables.selenium.open("/bobsilverberg/CFSelenium")>
		<cfset assertTrue(variables.selenium.getTitle() contains "bobsilverberg/cfselenium")>
		<cfset variables.selenium.click("link=readme.md")>
		<cfset variables.selenium.waitForPageToLoad("30000")>
		<cfset sleep(1000)>
		<cfset assertTrue(variables.selenium.getTitle() contains "CFSelenium/readme.md at master")>
		<cfset variables.selenium.click("raw-url")>
		<cfset variables.selenium.waitForPageToLoad("30000")>
		<cfset assertEquals("", variables.selenium.getTitle())>
		<cfset assertTrue(variables.selenium.isTextPresent("[CFSelenium]"))>
	</cffunction>
	
</cfcomponent>
