component extends="cfselenium.CFSeleniumTestCase" {

	function beforeTests(){
		browserURL = "http://github.com/";
		super.beforeTests();
	}

	function testForReadmePage() {
		selenium.open("/bobsilverberg/CFSelenium");
		assertTrue(selenium.getTitle() contains "bobsilverberg/cfselenium");
		selenium.click("link=readme.md");
		selenium.waitForPageToLoad("30000");
		sleep(1000);
		assertTrue(selenium.getTitle() contains "readme.md");
		selenium.click("raw-url");
		selenium.waitForPageToLoad("30000");
		assertEquals("", selenium.getTitle());
		assertTrue(selenium.isTextPresent("[CFSelenium]"));
	}

	
}

