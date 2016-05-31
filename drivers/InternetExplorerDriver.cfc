component output="false" extends="WebDriver" {

	public InternetExplorerDriver function init() {
		// the path must be set on the initial run per server instance, but can be disabled after that
		setInternetExplorerPath( expandPath("../../assets/IEDriverServer.exe") );  // <- 64 version.  Switch to IEDriverServer_32bit.exe for 32 bit version

		var driver = createJavaObject(
			"org.openqa.selenium.ie.InternetExplorerDriver",
			variables.serverLibPath
		).init(5555);
		//setUseExistingInternetExplorerInstance( "true" );
		return super.init( driver=driver, driverType="Internet Explorer" );
	}
	
	public void function setInternetExplorerPath( required string path ) {
		createObject( "java", "java.lang.System" ).setProperty( "webdriver.ie.driver", arguments.path);
	}

	/*public void function setUseExistingInternetExplorerInstance( required string toggle ) {
		createObject( "java", "java.lang.System" ).setProperty( "webdriver.ie.useExisting", arguments.toggle );
	}*/
}