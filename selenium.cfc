component accessors="true" hint="A CFML binding for Selenium" {

	public Selenium function init( string driverType="", string driverPath="" ) {
		structAppend(variables,arguments,true);
		variables.sessionId = "";
		
		setDriverByType( arguments.driverType );

		return this;
	}
	
	public drivers.WebDriver function getDriver() {
		return variables.driver;
	}
	
	public void function setDriver( required WebDriver driver ) {
		variables.driver = arguments.driver;
	}
	
	public void function setDriverByType( string driverType="" ) {
		// just implement Internet Explorer and firefox for now
		if ( arguments.driverType == "ie" || arguments.driverType == "InternetExplorer" ) {
			variables.driver = new drivers.InternetExplorerDriver();
		} else if ( arguments.driverType == "firefox" || arguments.driverType == "ff" ) {
			variables.driver = new drivers.FireFoxDriver();
		} else {
			variables.driver = new drivers.WebDriver();
		}
	}

}