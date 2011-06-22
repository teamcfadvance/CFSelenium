<style>
	.resultBlock {padding:1ex;margin-bottom:2ex;border:1px solid black;}
	.success {color:green;}
	.failure {font-weight:bold;color:red;}
	.subhead {font-weight:bold;}
</style>

<h2>waitForTest for CFSelenium on ColdFusion 7</h2>

<cfoutput>
	
	<p>Instantiating selenium...</p>
	
	<cfset browserUrl = "http://localhost/CFSelenium/test/fixture/">
	<cfset browserCommand= "*firefox">
	<cfset selenium= createObject("component","cfselenium.selenium_tags").init(waitTimeout=5000)>
	<cfset selenium.start(browserUrl,browserCommand)>
	<cfset selenium.setTimeout(30000)>
	<cfset selenium.open("http://localhost/cfselenium/test/fixture/waitForFixture.htm") />
	
	<p>Checking if "alwaysPresentAndVisible" exists on the page (should find it)...</p>
	<cfflush />
	
	<cfset selenium.waitForElementPresent("alwaysPresentAndVisible") />
	
	<cfset expected= "alwaysPresentAndVisible">
	<cfset actual= selenium.getText("alwaysPresentAndVisible")>
	
	<p class="resultBlock">
		Expected Selenium result: #expected# <br />
		Actual Selenium result: #actual#<br />
		<cfif expected EQ actual>
			<span class="success">Passed</span>
		<cfelse>
			<span class="failure">Failed</span>
		</cfif>
	</p>
	
	<p>Will look for "neverPresent" on the page (should NOT find it and throw an error after 5 seconds)...</p>
	
	<cfflush />
	<cfset expected="CFSelenium.elementNotFound">
	<cftry>
		<cfset selenium.waitForElementPresent("neverPresent")>
		<cfcatch type="any">
			<cfset actual= cfcatch.type />
		</cfcatch>
	</cftry>
	
	<p class="resultBlock">
		Expected Selenium error type: #expected# <br />
		Actual Selenium type #actual#<br />
		<cfif expected EQ actual>
			<span class="success">Passed</span>
		<cfelse>
			<span class="failure">Failed</span>
		</cfif>
	</p>
	
	<p>Will look for "presentAfterAPause", which at first will not be found...</p>
	<cfflush />
	<cfset expected= false>
	<cfset actual= selenium.isElementPresent("presentAfterAPause")>
	
	<p class="resultBlock">
		Expected Selenium result: #expected# <br />
		Actual Selenium result: #actual#<br />
		<cfif expected EQ actual>
			<span class="success">Passed</span>
		<cfelse>
			<span class="failure">Failed</span>
		</cfif>
	</p>
	
	<p>Will now create "presentAfterAPause" via Javascript and check again...</p>
	<cfflush />
	<cfset selenium.click("createElement") />
	<cfset selenium.waitForElementPresent("presentAfterAPause") />
	<cfset expected="presentAfterAPause" />
	<cfset actual= selenium.getText("presentAfterAPause") />
	
	<p class="resultBlock">
		Expected Selenium result: #expected# <br />
		Actual Selenium result: #actual#<br />
		<cfif expected EQ actual>
			<span class="success">Passed</span>
		<cfelse>
			<span class="failure">Failed</span>
		</cfif>
	</p>
		
	
	<p>Checking if "alwaysPresentAndVisible" is visible on the page (should find it)...</p>
	<cfflush />
	
	<cfset selenium.waitForElementVisible("alwaysPresentAndVisible") />
	
	<cfset expected= "alwaysPresentAndVisible">
	<cfset actual= selenium.getText("alwaysPresentAndVisible")>
	
	<p class="resultBlock">
		Expected Selenium result: #expected# <br />
		Actual Selenium result: #actual#<br />
		<cfif expected EQ actual>
			<span class="success">Passed</span>
		<cfelse>
			<span class="failure">Failed</span>
		</cfif>
	</p>
	
	<p>Will look for "neverVisible" on the page (should NOT see it and throw an error after 5 seconds)...</p>
	
	<cfflush />
	<cfset expected="CFSelenium.elementNotVisible">
	<cftry>
		<cfset selenium.waitForElementVisible("neverVisible")>
		<cfcatch type="any">
			<cfset actual= cfcatch.type />
		</cfcatch>
	</cftry>
	
	<p class="resultBlock">
		Expected Selenium error type: #expected# <br />
		Actual Selenium type #actual#<br />
		<cfif expected EQ actual>
			<span class="success">Passed</span>
		<cfelse>
			<span class="failure">Failed</span>
		</cfif>
	</p>
	
	<p>Will look for "becomesVisible", which at first will not be found...</p>
	<cfflush />
	<cfset expected= false>
	<cfset actual= selenium.isVisible("becomesVisible")>
	
	<p class="resultBlock">
		Expected Selenium result: #expected# <br />
		Actual Selenium result: #actual#<br />
		<cfif expected EQ actual>
			<span class="success">Passed</span>
		<cfelse>
			<span class="failure">Failed</span>
		</cfif>
	</p>
	
	<p>Will now make "becomesVisible" visible via Javascript and check again...</p>
	<cfflush />
	<cfset selenium.click("showElement") />
	<cfset selenium.waitForElementVisible("becomesVisible") />
	<cfset expected="becomesVisible" />
	<cfset actual= selenium.getText("becomesVisible") />
	
	<p class="resultBlock">
		Expected Selenium result: #expected# <br />
		Actual Selenium result: #actual#<br />
		<cfif expected EQ actual>
			<span class="success">Passed</span>
		<cfelse>
			<span class="failure">Failed</span>
		</cfif>
	</p>
	
	
	<p>Testing that "neverVisible" is not visible on the page...</p>
	<cfflush />
	
	<cfset selenium.waitForElementNotVisible("neverVisible") />
	
	<cfset expected= "">
	<cfset actual= selenium.getText("neverVisible")>
	
	<p class="resultBlock">
		Expected Selenium result: #expected# <br />
		Actual Selenium result: #actual#<br />
		<cfif expected EQ actual>
			<span class="success">Passed</span>
		<cfelse>
			<span class="failure">Failed</span>
		</cfif>
	</p>
	
	
	
	<p>Will test that "alwaysPresentAndVisible" is NOT visible (which is not true and will throw an error after 5 seconds)...</p>
	
	<cfflush />
	<cfset expected="CFSelenium.elementStillVisible">
	<cftry>
		<cfset selenium.waitForElementNotVisible("alwaysPresentAndVisible")>
		<cfcatch type="any">
			<cfset actual= cfcatch.type />
		</cfcatch>
	</cftry>
	
	<p class="resultBlock">
		Expected Selenium error type: #expected# <br />
		Actual Selenium type #actual#<br />
		<cfif expected EQ actual>
			<span class="success">Passed</span>
		<cfelse>
			<span class="failure">Failed</span>
		</cfif>
	</p>
	
	<p>Will look for "becomesInvisible", which at first will be visible...</p>
	<cfflush />
	<cfset expected= true>
	<cfset actual= selenium.isVisible("becomesInvisible")>
	
	<p class="resultBlock">
		Expected Selenium result: #expected# <br />
		Actual Selenium result: #actual#<br />
		<cfif expected EQ actual>
			<span class="success">Passed</span>
		<cfelse>
			<span class="failure">Failed</span>
		</cfif>
	</p>
	
	<p>Will now make "becomesInvisible" invisible via Javascript and check again...</p>
	<cfflush />
	<cfset selenium.click("hideElement") />
	<cfset selenium.waitForElementNotVisible("becomesInvisible") />
	<cfset expected="" />
	<cfset actual= selenium.getText("becomesInvisible") />
	
	<p class="resultBlock">
		Expected Selenium result: #expected# <br />
		Actual Selenium result: #actual#<br />
		<cfif expected EQ actual>
			<span class="success">Passed</span>
		<cfelse>
			<span class="failure">Failed</span>
		</cfif>
	</p>
	
	<p>Stopping selenium...</p>
	<cfset selenium.stop()>
	
	<cfset expected= 0>
	<cfset actual= Len(selenium.getSessionId())>
	
	<p class="resultBlock">
		Expected Selenium sessionId length: #expected# <br />
		Actual Selenium sessionId length: #actual#<br />
		<cfif expected EQ actual>
			<span class="success">Passed</span>
		<cfelse>
			<span class="failure">Failed</span>
		</cfif>
	</p>
	
	<cfset selenium.stopServer()>
	
	<p>DONE</p>
	
</cfoutput>
