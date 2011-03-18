component extends="mxunit.framework.TestCase" {

	function setUp() {
		browserUrl = "http://wiki.mxunit.org/";
	}

	function tearDown() {
        selenium.stop();
	    assertTrue(len(selenium.getSessionId()) eq 0);
	}	
	
	private any function startSelenium(browserUrl, browserCommand) {

	    selenium = createobject("component","CFSelenium.selenium").init(browserUrl,"localhost", 4444, browserCommand);
	    assertTrue(len(selenium.getSessionId()) eq 0);
        selenium.start();
	    assertFalse(len(selenium.getSessionId()) eq 0);
	    return selenium;
		
	}
	
	
    function shouldBeAbleToStartFirefox() {
		startSelenium(browserUrl,"*firefox");
	}
	
    function shouldBeAbleToStartSafari() {
		startSelenium(browserUrl,"*safari");
	}
	
    function shouldBeAbleToStartGoogleChrome() {
		startSelenium(browserUrl,"*googlechrome");
	}
	
    function shouldBeAbleToStartIEOnWindowsVM() {
    	hostname = "192.168.56.101";
	    selenium = createobject("component","selenium").init(browserUrl,hostname, 4444, "*iexplore");
	    assertTrue(len(selenium.getSessionId()) eq 0);
        selenium.start();
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

