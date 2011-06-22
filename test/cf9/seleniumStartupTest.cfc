component extends="cfselenium.CFSeleniumTestCase"   {

	function beforeTests() {
		selenium = createObject("component", "cfselenium.selenium").init();
		browserUrl = "http://wiki.mxunit.org/";
	}
	
	function tearDown() {
		selenium.stop();
	}

    function shouldBeAbleToStartFirefox() {
		selenium.start(browserUrl,"*firefox");
	}
	
    function shouldBeAbleToStartSafari() {
		selenium.start(browserUrl,"*safari");
	}
	
    function shouldBeAbleToStartGoogleChrome() {
		selenium.start(browserUrl,"*googlechrome");
	}
	
}

