[CFSelenium](http://github.com/bobsilverberg/CFSelenium) - A Native CFML (ColdFusion) Client Library for Selenium-RC
=============================================================================================================

### What is CFSelenium? ###

CFSelenium is a ColdFusion Component (CFC) which provides a native client library for Selenium-RC. This allows you to write tests, using CFML, which will drive a browser and verify results via Selenium-RC.

### Requirements ###

1. [ColdFusion 7+](http://www.coldfusion.com) - ColdFusion 9+ is required for the script-based cfc. You can use the tag-based cfc, selenium_tags on CF 7 and 8.
2. The [Selenium-RC Server jar](http://code.google.com/p/selenium/downloads/list), the latest version of which is included in the distribution

### Usage ###

Preferred: Write your UI tests to extend cfselenium.CFSeleniumTestCase, which will start and stop the Selenium RC before and after all tests in a TestCase. For example:
	component extends="cfselenium.CFSeleniumTestCase" ...

Alternate: Start the Selenium-RC server from the shell. For example:
    java -jar selenium-server-standalone-2.0b2.jar

Create an instance of selenium.cfc, passing in the beginning url for your test:
    selenium = new selenium("http://github.com/");

You can also pass the host, port and browser command into the constructor, which default to localhost, 4444, and *firefox, respectively:
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

### A Selenium-IDE Formatter Too ###

Also included in the distribution is a Firefox extension which will add a formatter to Selenium-IDE which will allow you to export tests in CFSelenium / MXUnit format. The plugin can be found in the _formats_ folder.

### Support ###

The script-based version of CFSelenium is maintained by [Bob Silverberg](https://github.com/bobsilverberg) and the tag-based version is maintained by [Brian Swartzfager](https://github.com/bcswartz). Please use the main repo's [issue tracker](https://github.com/bobsilverberg/CFSelenium/issues) to report bugs and request enhancements.