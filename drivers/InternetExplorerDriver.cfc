component output="false" extends="WebDriver" {
  
	public InternetExplorerDriver function init() {
		// the path must be set on the initial run per server instance, but can be disabled after that
		setInternetExplorerPath( expandPath("../../assets/IEDriverServer.exe") );  // <- 64 version.  Switch to IEDriverServer_32bit.exe for 32 bit version

		//setUseExistingInternetExplorerInstance( "true" );
		return super.init( driver=createObject( "java", "org.openqa.selenium.ie.InternetExplorerDriver", "#ExpandPath('../../Selenium-RC/selenium-server-standalone-2.37.0.jar')#" ).init(5555), driverType="Internet Explorer" );
	}
	
	public void function setInternetExplorerPath( required string path ) {
		createObject( "java", "java.lang.System" ).setProperty( "webdriver.ie.driver", arguments.path);
	}

	/*public void function setUseExistingInternetExplorerInstance( required string toggle ) {
		createObject( "java", "java.lang.System" ).setProperty( "webdriver.ie.useExisting", arguments.toggle );
	}*/
}