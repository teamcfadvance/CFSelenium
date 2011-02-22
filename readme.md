[CFSelenium](http://github.com/bobsilverberg/CFSelenium) - A Native CFML (ColdFusion) Client Library for Selenium-RC
=============================================================================================================

### What is CFSelenium? ###

CFSelenium is a ColdFusion Component (CFC) which provides a native client library for Selenium-RC. This allows you to write tests, using CFML, which will drive a browser and verify results via Selenium-RC.

### Requirements ###

1. [ColdFusion 9+](http://www.coldfusion.com)
2. The [Selenium-RC Server jar](http://seleniumhq.org/download/previous.html#selenium-rc-previous-downloads), the latest version of which is included in the distribution

### Usage ###

Start the Selenium-RC server.  For example:
    java - jar selenium-server-standalone-2.0b2.jar

Create an instance of selenium.cfc, passing in the beginning url for your test:
    selenium = new selenium("http://github.com/");

You can also pass the host, port and browser command into the construtcor, which default to localhost, 4444, and *firefox, respectively:
	selenium = new selenium("http://github.com/", "localhost", 4444, "*firefox");

Call methods on the selenium object to drive the browser and check values. For example:
	selenium = new selenium("http://github.com/");
	selenium.start();
	selenium.open("/bobsilverberg/CFSelenium");
	assertEquals("bobsilverberg/CFSelenium - GitHub", selenium.getTitle());
	selenium.click("link=readme.md");
	selenium.waitForPageToLoad("30000");
	assertEquals("readme.md at master from bobsilverberg's CFSelenium - GitHub", selenium.getTitle());
	selenium.click("raw-url");
	selenium.waitForPageToLoad("30000");
	assertEquals("", selenium.getTitle());
	assertTrue(selenium.isTextPresent("[CFSelenium]"));
	selenium.stop();
