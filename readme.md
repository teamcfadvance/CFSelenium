[CFSelenium](http://github.com/bobsilverberg/CFSelenium) - A Native CFML (ColdFusion) Binding for Selenium-RC

### What is CFSelenium? ###

CFSelenium is a ColdFusion Component (CFC) which provides a native binding for Selenium-RC. This allows you to write tests, using CFML, which will drive a browser and verify results via Selenium-RC.

### Requirements ###

1. [ColdFusion 9+](http://www.coldfusion.com)
2. The [Selenium-RC Server jar](http://seleniumhq.org/download/previous.html#selenium-rc-previous-downloads), the latest version of which is included in the distribution

### Usage ###

1. Start the Selenium-RC server.  For example:
	java - jar selenium-server-standalone-2.0b2.jar

2. Create an instance of selenium.cfc, passing in the beginning url for your test, the host and port of your RC instance, and the browser you want to drive:
	selenium = createObject("component","selenium").init(browserUrl="http://github.com/bobsilverberg/CFSelenium", host="localhost", port=4444, browserCommand="*firefox");

3. Call methods on the selenium object to drive the browser. For example:
