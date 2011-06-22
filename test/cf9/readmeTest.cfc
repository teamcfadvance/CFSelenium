component extends="cfselenium.CFSeleniumTestCase" {

	function beforeTests(){
		browserURL = "http://github.com/";
		super.beforeTests();
	}

	function testForReadmePage() {
		selenium.open("/bobsilverberg/CFSelenium");
		assertEquals("bobsilverberg/CFSelenium - GitHub", selenium.getTitle());
		selenium.click("link=readme.md");
		selenium.waitForPageToLoad("30000");
		sleep(1000);
		assertEquals("readme.md at master from bobsilverberg/cfselenium - github", selenium.getTitle());
		selenium.click("raw-url");
		selenium.waitForPageToLoad("30000");
		assertEquals("", selenium.getTitle());
		assertTrue(selenium.isTextPresent("[CFSelenium]"));
	}

	
}

