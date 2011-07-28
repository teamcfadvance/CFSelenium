[CFSelenium](http://github.com/bobsilverberg/CFSelenium) - A Native CFML (ColdFusion) Client Library for Selenium-RC
=============================================================================================================

### What is CFSelenium? ###

CFSelenium is a ColdFusion Component (CFC) which provides a native client library for Selenium-RC. This allows you to write tests, using CFML, which will drive a browser and verify results via Selenium-RC.

### Requirements ###

1. [ColdFusion 7+](http://www.coldfusion.com) - ColdFusion 9+ is required for the script-based cfc. You can use the tag-based cfc, selenium_tags on CF 7 and 8.
2. The [Selenium-RC Server jar](http://code.google.com/p/selenium/downloads/list), the latest version of which is included in the distribution

### Usage ###

Optionally, start the Selenium-RC server.  Selenium.cfc will automatically start the Selenium-RC server for you in the background if it isn't already started (note this does not work on CF7). To start it manually, the command is similar to this:

	java -jar selenium-server-standalone-2.2.0.jar

Create an instance of selenium.cfc.

	selenium = new selenium();

You can also pass the host and port into the constructor, which default to localhost and 4444:
	
	selenium = new selenium("localhost", 4444);

To start up a browser, call selenium.start() passing in the starting url and, optionally, a browser command telling it which browser to start (the default is *firefox):

	selenium.start("http://github.com/");

To start a different browser (e.g., Google Chrome), pass in the browser command too:

	selenium.start("http://github.com/","*googlechrome");

Call methods on the selenium object to drive the browser and check values. For example:
	
	selenium.open("/bobsilverberg/CFSelenium");
	assertEquals("bobsilverberg/CFSelenium - GitHub", selenium.getTitle());
	selenium.click("link=readme.md");
	selenium.waitForPageToLoad("30000");
	assertEquals("readme.md at master from bobsilverberg's CFSelenium - GitHub", selenium.getTitle());
	selenium.click("raw-url");
	selenium.waitForPageToLoad("30000");
	assertEquals("", selenium.getTitle());
	assertTrue(selenium.isTextPresent("[CFSelenium]"));

You can shut down the browser using the stop() method:

	selenium.stop();

### A Base Test Case for MXUnit ###

Also included in the distribution is a base test case for MXUnit, called CFSeleniumTestCase.cfc. This is designed to instantiate the selenium.cfc for you and start up a browser session once, before all of your tests run, and shut down the browser after all the tests have completed. To use this base test case, simply extend it in your own test case:

	component extends="CFSelenium.CFSeleniumTestCase"

You will then want to place a beforeTests() method in your test case which sets the browserUrl and the calls the base test case's beforeTests() method:

	public void function beforeTests(){
		browserURL = "http://github.com/";
		super.beforeTests();
	}

### A Selenium-IDE Formatter Too ###

Also included in the distribution is a Firefox extension which will add a formatter to Selenium-IDE which will allow you to export tests in CFSelenium / MXUnit format. The plugin can be found in the _formats_ folder.

### Support ###

The script-based version of CFSelenium is maintained by [Bob Silverberg](https://github.com/bobsilverberg) and the tag-based version is maintained by [Brian Swartzfager](https://github.com/bcswartz). Thanks also to [Marc Esher](https://github.com/marcesher) for the logic which starts and stops the Selenium-RC server automatically.

Please use the main repo's [issue tracker](https://github.com/bobsilverberg/CFSelenium/issues) to report bugs and request enhancements.