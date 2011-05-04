component extends="cfselenium.CFSeleniumTestCase" {

	function testForReadmePage() {
		selenium = new CFSelenium.selenium("http://github.com/");
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
	}
	
	function teardown() {
		selenium.stop();
	}
	
}

