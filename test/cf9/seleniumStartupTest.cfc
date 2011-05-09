component extends="cfselenium.CFSeleniumTestCase"   {

	function beforeTests() {
		selenium = createObject("component", "cfselenium.selenium").init();
		browserUrl = "http://wiki.mxunit.org/";
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
	
    function shouldBeAbleToStartIEOnWindowsVM() {
    	hostname = "192.168.56.101";
	    selenium = createobject("component","cfselenium.selenium").init(hostname, 4444);
	    assertTrue(len(selenium.getSessionId()) eq 0);
        selenium.start(browserUrl, "*iexplore");
	    assertFalse(len(selenium.getSessionId()) eq 0);
	}
	
	/* errors from Windows, but it is attempting to start a browser anyway
    function shouldBeAbleToStartFirefoxWindowsVM() {
    	hostname = "192.168.56.101";
	    selenium = createobject("component","selenium").init(browserUrl,hostname, 4444, "*firefox");
	    assertTrue(len(selenium.getSessionId()) eq 0);
        selenium.start();
	    assertFalse(len(selenium.getSessionId()) eq 0);
	}
	*/
	
}

