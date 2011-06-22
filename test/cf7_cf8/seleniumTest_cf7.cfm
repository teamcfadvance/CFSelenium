<style>
	.resultBlock {padding:1ex;margin-bottom:2ex;border:1px solid black;}
	.success {color:green;}
	.failure {font-weight:bold;color:red;}
	.subhead {font-weight:bold;}
</style>

<h2>seleniumTest for CFSelenium on ColdFusion 7</h2>

<cfoutput>
	
	<p>Instantiating selenium...</p>
	
	<cfset browserUrl = "http://wiki.mxunit.org/">
	<cfset browserCommand= "*firefox">
	<cfset selenium= createObject("component","CFSelenium.selenium_tags").init("localhost", 4444)>
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
	
	<p>Starting selenium...</p>
	
	<cfflush />
	
	<cfset selenium.start(browserUrl,browserCommand)>
	<cfset failureCondition= 0>
	<cfset actual= Len(selenium.getSessionId())>
	
	<p class="resultBlock">
		Expected Selenium sessionId length: Not #failureCondition# <br />
		Actual Selenium sessionId length: #actual#<br />
		<cfif failureCondition NEQ actual>
			<span class="success">Passed</span>
		<cfelse>
			<span class="failure">Failed</span>
		</cfif>
	</p>
	
	<p>Testing parsing of comma-separated values...</p>
	
	<cfflush />
	
	<cfset input = "veni\, vidi\, vici,c:\\foo\\bar,c:\\I came\, I \\saw\\\, I conquered">
	<cfset expected= ArrayNew(1)>
	<cfset ArrayAppend(expected,"veni, vidi, vici")>
	<cfset ArrayAppend(expected,"c:\foo\bar")>
	<cfset ArrayAppend(expected,"c:\i came, i \saw\, i conquered")>
	<cfset actual= selenium.parseCSV(input)>
	
	<p class="resultBlock">
		Expected output (array):<br />
		<cfdump var="#expected#">
		
		Actual output (array):<br />
		<cfdump var="#actual#">
		
		<cfif ArrayLen(expected) NEQ ArrayLen(actual)>
			<span class="failure">Failed</span>
		<cfelse>
			<cfset valuesEqual= true />
			<cfloop index="i" from="1" to="#ArrayLen(expected)#">
				<cfif expected[i] NEQ actual[i]>
					<cfset valuesEqual= false />
				</cfif>
			</cfloop>
			<cfif valuesEqual>
				<span class="success">Passed</span>
			<cfelse>
				<span class="failure">Failed</span>
			</cfif>
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
