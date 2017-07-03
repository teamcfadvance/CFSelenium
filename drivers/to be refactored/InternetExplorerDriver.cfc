component output="false" extends="WebDriver" {

	public InternetExplorerDriver function init(
		string localDriverRepoPath = variables.defaultLocalDriverRepoPath
	) {
		setupDriver(
			driverName = "InternetExplorer",
			localDriverRepoPath = localDriverRepoPath
		);
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