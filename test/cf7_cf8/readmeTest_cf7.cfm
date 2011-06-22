<style>
	.resultBlock {padding:1ex;margin-bottom:2ex;border:1px solid black;}
	.success {color:green;}
	.failure {font-weight:bold;color:red;}
</style>

<h2>readmeTest for CFSelenium on ColdFusion 7</h2>

<cfoutput>
	<cfset browserUrl= "http://github.com">
	<cfset browserCommand= "*firefox">
	<cfset selenium= CreateObject("component","CFSelenium.selenium_tags").init()>
	<cfset selenium.start(browserUrl,browserCommand)>
	
	<cfset selenium.open("/bobsilverberg/CFSelenium")>

	<cfset expected= "bobsilverberg/CFSelenium - GitHub">
	<cfset actual= selenium.getTitle()>

	<p class="resultBlock">
		Expected page title: #expected#<br />
		Actual page title: #actual#<br />
		<cfif expected EQ actual>
			<span class="success">Passed</span>
		<cfelse>
			<span class="failure">Failed</span>
		</cfif>
	</p>
	
	<cfflush />
	
	<p>Loading readme.md...</p>
	
	<cfflush />
	
	<cfset selenium.click("link=readme.md")>
	<cfset selenium.waitForPageToLoad("30000")>
		
	<cfset thread= CreateObject("java","java.lang.Thread") />
	<cfset thread.sleep(1000) />
	
	<cfset expected= "readme.md at master from bobsilverberg/CFSelenium - GitHub">
	<cfset actual= selenium.getTitle()>
		
	<p class="resultBlock">
		Expected page title: #expected#<br />
		Actual page title: #actual#<br />
		<cfif expected EQ actual>
			<span class="success">Passed</span>
		<cfelse>
			<span class="failure">Failed</span>
		</cfif>
	</p>
	
	<cfflush />
	
	<p>Clicking on "raw-url"...</p>
	
	<cfflush />
	
	<!---For some reason, this would sometimes throw an error when used with CF9 and Firefox 4 on Windows 7.  Runs fine in CF7 and Firefox 3.6, and CF9 and Firefox 3.6 on a Mac.  Enclosing in try/catch as a precaution--->
	
	<cftry>
		<cfset selenium.click("raw-url")>
		<cfset selenium.waitForPageToLoad("30000")>
		<cfset actual= selenium.getTitle()>
		<cfcatch type="any">
			<cfset actual= "Error occurred while trying to click raw link" />
		</cfcatch>
	</cftry>
	
	<cfset expected= "">
	<cfset actual= selenium.getTitle()>
	
	<p class="resultBlock">
		Expected page title: #expected#<br />
		Actual page title: #actual#<br />
		<cfif expected EQ actual>
			<span class="success">Passed</span>
		<cfelse>
			<span class="failure">Failed</span>
		</cfif>
	</p>
	
	<cfset expected= true>
	<cfset actual= selenium.isTextPresent("[CFSelenium]")>
	
	<p class="resultBlock">
		Looking for text: [CFSelenium]<br />
		Text found?: #actual#<br />
		<cfif expected EQ actual>
			<span class="success">Passed</span>
		<cfelse>
			<span class="failure">Failed</span>
		</cfif>
	</p>
	
	<p>DONE</p>
	
	<cfset selenium.stop()>
	<cfset selenium.stopServer()>
	
</cfoutput>
