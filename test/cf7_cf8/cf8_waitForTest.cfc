<cfcomponent extends="CFSeleniumTestCase_Tags" >

	<cffunction name="beforeTests">
		<!--- this will need to be modified to point to wherever you have your test server set up --->
		<cfset browserUrl = "http://localhost/test/fixture/">
		<cfset browserCommand= "*firefox">
		<cfset selenium= createObject("component","selenium_tags").init(waitTimeout=5000)>
		<cfset selenium.start(browserUrl,browserCommand)>
		<cfset selenium.setTimeout(30000)>
	</cffunction>

	<cffunction name="setup">
		<!--- this will need to be modified to point to wherever you have your test server set up --->
		<cfset selenium.open("http://localhost/test/fixture/waitForFixture.htm") />
	</cffunction>

	<cffunction name="waitForElementPresentShouldFindElementThatIsAlreadyThere">
		<cfset selenium.waitForElementPresent("alwaysPresentAndVisible") />
		<cfset assertEquals("alwaysPresentAndVisible",selenium.getText("alwaysPresentAndVisible")) />
	</cffunction>
	
	<cffunction name="waitForElementPresentShouldThrowIfElementIsNeverThere" mxunit:expectedException="elementNotFound">
		<cfset selenium.waitForElementPresent("neverPresent") />
	</cffunction>
	
	<cffunction name="waitForElementPresentShouldFindElementThatAppears">
		<cfset assertEquals(false,selenium.isElementPresent("presentAfterAPause")) />
		<cfset selenium.click("createElement") />
		<cfset selenium.waitForElementPresent("presentAfterAPause") />
		<cfset assertEquals("presentAfterAPause",selenium.getText("presentAfterAPause")) />
	</cffunction>
	
	<cffunction name="waitForElementVisibleShouldFindElementThatIsAlreadyThere">
		<cfset selenium.waitForElementVisible("alwaysPresentAndVisible") />
		<cfset assertEquals("alwaysPresentAndVisible",selenium.getText("alwaysPresentAndVisible")) />
	</cffunction>
	
	<cffunction name="waitForElementVisibleShouldThrowIfElementIsNeverVisible" mxunit:expectedException="elementNotVisible">
		<cfset selenium.waitForElementVisible("neverVisible") />
	</cffunction>
		
	<cffunction name="waitForElementVisibleShouldFindElementThatAppears">
		<cfset assertEquals(false,selenium.isVisible("becomesVisible")) />
		<cfset selenium.click("showElement") />
		<cfset selenium.waitForElementVisible("becomesVisible") />
		<cfset assertEquals("becomesVisible",selenium.getText("becomesVisible")) />
	</cffunction>
	
	<cffunction name="waitForElementNotVisibleShouldSucceedIfElementIsAlreadyInvisible">
		<cfset selenium.waitForElementNotVisible("neverVisible") />
		<cfset assertEquals("",selenium.getText("neverVisible")) />
	</cffunction>
	
	<cffunction name="waitForElementNotVisibleShouldThrowIfElementIsAlwaysVisible" mxunit:expectedException="elementStillVisible">
		<cfset selenium.waitForElementNotVisible("alwaysPresentAndVisible") />
	</cffunction>
	
	<cffunction name="waitForElementNotVisibleShouldSucceedIfElementDisappears">
		<cfset assertEquals(true,selenium.isVisible("becomesInvisible")) />
		<cfset selenium.click("hideElement") />
		<cfset selenium.waitForElementNotVisible("becomesInvisible") />
		<cfset assertEquals("",selenium.getText("becomesInvisible")) />
	</cffunction>
	
</cfcomponent>

