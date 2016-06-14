component output="false" extends="WebDriver" {

	setupDriver("InternetExplorer");

	public InternetExplorerDriver function init() {
		var driver = variables.JavaFactory.createObject(
			"org.openqa.selenium.ie.InternetExplorerDriver"
		).init(5555);
		//setUseExistingInternetExplorerInstance( "true" );
		return super.init( driver=driver );
	}

	/*public void function setUseExistingInternetExplorerInstance( required string toggle ) {
		createObject( "java", "java.lang.System" ).setProperty( "webdriver.ie.useExisting", arguments.toggle );
	}*/

}