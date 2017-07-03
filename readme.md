[CFSelenium](http://github.com/teamcfadvance/CFSelenium) - A Native CFML (ColdFusion) Client Library for the [Selenium WebDriver](http://www.seleniumhq.org/)
=============================================================================================================

### What is CFSelenium? ###

CFSelenium is a ColdFusion Component (CFC) which provides a native client library for the Selenium WebDriver. This allows you to write tests, using CFML, which will drive a browser and verify results.

This version has dropped support for Selenium-RC and Selenium-IDE. Also the tests have been rewritten for [TestBox](https://www.ortussolutions.com/products/testbox) by [Ortus Solutions](https://www.ortussolutions.com/).

### Requirements ###

1. [Lucee 4.5+](http://lucee.org/) or [Adobe ColdFusion 11+](http://www.coldfusion.com)
2. [TestBox](https://www.ortussolutions.com/products/testbox) if you want to run the test suite

### Implementation ###

Ensure that the standalone Selenium Server jar file is in your Java load path. You can add this to your Application.cfc to ensure the file is loaded.

    this.javaSettings = { loadPaths = [ '/path/to/cfselenium/lib/selenium-server-standalone-3.4.0.jar' ] };

To create an instance of Selenium WebDriver:

	selenium = new cfselenium.SeleniumWebDriver( driverType="firefox" );

Currently the Firefox WebDrivers for both Macintosh and Windows are provided. Other browsers and operating systems will be added as test coverage increases.

##### Using WebDriver

Example: Get a page title.

```
selenium = new cfselenium.SeleniumWebDriver( driverType="firefox" );
driver = selenium.getDriver();
driver.get( "https://www.google.com" );
writedump( var="#driver.getTitle()#" ); // evaluates to "Google"
driver.quit();
```

### Testing ###

#### Running the Tests

```
cd /path/to/my/webroot/ # or wherever you want to put stuff
git clone https://github.com/teamcfadvance/CFSelenium.git cfselenium
cd cfselenium
git checkout master
git clone https://github.com/Ortus-Solutions/TestBox.git testbox
cd testbox
git checkout master
```

##### Multi-CFML-Engine Testing using CommandBox

One super-easy way to do tests in different CFML engines is this is to install [CommandBox](https://www.ortussolutions.com/products/commandbox) by [Ortus Solutions](https://www.ortussolutions.com/) , run the executable, then, within CommandBox:

```
cd /path/to/my/webroot/ # or wherever you'd put it
# testing in Lucee 4.5, for instance
server start cfengine=lucee@4.5 # when done testing, run `stop`
# testing in ACF 11, for instance
server start cfengine=adobe@11 # when done testing, run `stop`
```

That will open a browser window with a random port (e.g., 62261), after which, browse to the following to run the tests and see the results:

* Functional tests:
	* WebDriver: http://localhost:62261/cfselenium/tests/

### Support ###

Please use the main repo's [issue tracker](https://github.com/teamcfadvance/CFSelenium/issues) to report bugs and request enhancements.

### Credits ###

The script-based version of CFSelenium was created by [Bob Silverberg](https://github.com/bobsilverberg) and the tag-based version was created by by [Brian Swartzfager](https://github.com/bcswartz). [Marc Esher](https://github.com/marcesher) provided the logic which starts and stops the Selenium-RC server automatically. [@Lampei](https://github.com/Lampei) and [Jamie Jackson](https://github.com/jamiejackson) added WebDriver support.

[Richard Herbert](https://github.com/richardherbert) refactored the WebDriver approach and removed support for Selenium-RC and Selenium-IDE. The tests were rewritten using TestBox/CommandBox and MXUnit has been removed.
