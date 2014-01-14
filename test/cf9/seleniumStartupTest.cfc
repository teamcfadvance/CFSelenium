component extends="CFSeleniumTestCase"   {

	function beforeTests() {
		selenium = createObject("component", "webSelenium").init();
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

