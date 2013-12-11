component extends="CFSeleniumTestCase" {

	function beforeTests(){
		browserURL = "http://github.com/";
		super.beforeTests( version=1, browserURL=browserURL );
	}

	function testForReadmePage() {
		variables.selenium.open("/bobsilverberg/CFSelenium");
		assertTrue(variables.selenium.getTitle() contains "bobsilverberg/cfselenium");
		variables.selenium.click("link=readme.md");
		variables.selenium.waitForPageToLoad("30000");
		sleep(1000);
		assertTrue(variables.selenium.getTitle() contains "readme.md");
		variables.selenium.click("raw-url");
		variables.selenium.waitForPageToLoad("30000");
		assertEquals("", variables.selenium.getTitle());
		assertTrue(variables.selenium.isTextPresent("[CFSelenium]"));
	}

	
}

