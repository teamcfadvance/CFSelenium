component output="false" extends="WebDriver" {
  
	public InternetExplorerDriver function init() {
		//setInternetExplorerPath( expandPath("../../assets/IEDriverServer.exe") );
		//setUseExistingInternetExplorerInstance( "true" );
		//local.service = createObject("java", "org.openqa.selenium.ie.InternetExplorerDriverService" );
		//writedump(var=local.service.createDefaultService(),abort=true);
		return super.init( driver=createObject( "java", "org.openqa.selenium.ie.InternetExplorerDriver" ).init(5555), driverType="Internet Explorer" );
	}
	
	public void function setInternetExplorerPath( required string path ) {
		createObject( "java", "java.lang.System" ).setProperty( "webdriver.ie.driver", arguments.path);
	}

	/*public void function setUseExistingInternetExplorerInstance( required string toggle ) {
		createObject( "java", "java.lang.System" ).setProperty( "webdriver.ie.useExisting", arguments.toggle );
	}*/
}