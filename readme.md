[CFSelenium](http://github.com/bobsilverberg/CFSelenium) - A Native CFML (ColdFusion) Client Library for Selenium-RC
=============================================================================================================

### What is CFSelenium? ###

CFSelenium is a ColdFusion Component (CFC) which provides a native client library for Selenium-RC. This allows you to write tests, using CFML, which will drive a browser and verify results via Selenium-RC.

### Requirements ###

1. [ColdFusion 7+](http://www.coldfusion.com) - ColdFusion 9+ is required for the script-based cfc. You can use the tag-based cfc, selenium_tags on CF 7 and 8.
2. The [Selenium-RC Server jar](http://code.google.com/p/selenium/downloads/list), the latest version of which is included in the distribution

### Versions ###

#### WebDriver (Preferred)

Note: This _currently_ only works properly on Lucee or [ACF11+](https://github.com/teamcfadvance/CFSelenium/pull/25#issue-157582346).

To create an instance of Selenium WebDriver:

	selenium = new SeleniumWebDriver(driverType="firefox"); // or "internetExplorer"

By default, the local WebDriver repository of drivers will be located at `${java.io.tmpdir}webdriver/`. On my system, this resolves to `C:\Users\jamie\AppData\Local\Temp\webdriver`, and the resulting repository looks something like this:

```
C:\Users\15037\AppData\Local\Temp\webdriver
|-- geckodriver
|   `-- win32
|       `-- 0.8.0
|           `-- geckodriver.exe
`-- IEDriverServer
    `-- Win32
        `-- 2.51
            `-- IEDriverServer.exe
```

To change the repository location, use the `defaultLocalDriverRepoPath` argument:

	selenium = new SeleniumWebDriver(driverType="firefox", defaultLocalDriverRepoPath="/your/custom/path");

##### Using WebDriver

Example: Get page title.

```
selenium = new cfselenium.SeleniumWebDriver( driverType="firefox" );
driver = selenium.getDriver();
driver.get("https://www.google.com");
dump(driver.getTitle()); // evaluates to "Google"
driver.quit();
```

#### Selenium-RC (Legacy)

To create an instance of Selenium-RC:

	selenium = new SeleniumRC();
	
You can also pass the host and port into the constructor, which default to localhost and 4444:

	selenium = new SeleniumRC("localhost", 4444);
	
##### Starting Selenium-RC Server (Optional)

Optionally, start the Selenium-RC server.  Selenium.cfc will automatically start the Selenium-RC server for you in the background if it isn't already started (note this does not work on CF7).

Note: When running IE tests, you may need to start the server manually, and *as the **administrator*** user, in order to get around [certain problems](https://github.com/teamcfadvance/CFSelenium/pull/25#issue-157582346). Also, you may need to set up [IE's "Protected Mode" settings](http://jimevansmusic.blogspot.com/2012/08/youre-doing-it-wrong-protected-mode-and.html) if you get an exception like `org.openqa.selenium.WebDriverException: Unexpected error launching Internet Explorer. Protected Mode must be set to the same value (enabled or disabled) for all zones. (WARNING: The server did not provide any stacktrace information)`. 

To start it manually, the command is similar to this:

	java -jar /path/to/cfselenium/Selenium-RC/selenium-server-standalone-2.53.0.jar

#### Using Selenium-RC

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

You can shut down the browser using the `stop()` method:

	selenium.stop();
	
### A Base Test Case for MXUnit ###

Also included in the distribution is a base test case for MXUnit, called CFSeleniumTestCase.cfc. This is designed to instantiate the selenium.cfc for you and start up a browser session once, before all of your tests run, and shut down the browser after all the tests have completed. To use this base test case, simply extend it in your own test case:

#### WebDriver

```
component extends="CFSelenium.CFSeleniumWebDriverTestCase"
```

#### Selenium-RC

```
component extends="CFSelenium.CFSeleniumRCTestCase"

public void function beforeTests(){
	browserURL = "http://github.com/";
	super.beforeTests(browserURL="http://github.com/");
}
```

### A Selenium-IDE Formatter Too ###

Also included in the distribution is a Firefox extension which will add a formatter to Selenium-IDE which will allow you to export tests in CFSelenium / MXUnit format. The plugin can be found in the _formats_ folder.

### Contributions

#### Git Workflow

(TODO: Flesh this out.)

Be sure to all tests pass in ACF10 and Lucee 4 before submitting a pull request. (See "Running Tests.")

#### Running Tests

```bash
cd /tmp/ # or wherever you want to put stuff
git clone https://github.com/teamcfadvance/CFSelenium.git cfselenium
cd cfselenium
git checkout master
git clone https://github.com/mxunit/mxunit.git mxunit
cd mxunit
git checkout master
```

Then, start a server using `/tmp/cfselenium` (or wherever you put it) as your web root.

##### Multi-CFML-Engine Testing using CommandBox

One super-easy way to do tests in different CFML engines is this is to install [CommandBox (3.1+)](http://integration.stg.ortussolutions.com/artifacts/ortussolutions/commandbox/3.1.0/), run the executable, then, within CommandBox:

```
cd /tmp/cfselenium # or wherever you'd put it
# testing in Lucee 4, for instance
server start cfengine=lucee@4 # when done testing, run `stop`
# testing in ACF 11, for instance
server start cfengine=adobe@11 # when done testing, run `stop`
```

That will open a browser window with a random port (e.g., 62261), after which, browse to the following to run tests and see results:

* Functional tests:
	* Selenium-RC: http://localhost:62261/test/cf9/
	* WebDriver: http://localhost:62261/test/v2/

### Support ###

Please use the main repo's [issue tracker](https://github.com/teamcfadvance/CFSelenium/issues) to report bugs and request enhancements.

### Credits ###

The script-based version of CFSelenium was created by [Bob Silverberg](https://github.com/bobsilverberg) and the tag-based version was created by by [Brian Swartzfager](https://github.com/bcswartz). [Marc Esher](https://github.com/marcesher) provided the logic which starts and stops the Selenium-RC server automatically. [@Lampei](https://github.com/Lampei) and [Jamie Jackson](https://github.com/jamiejackson) added WebDriver support.