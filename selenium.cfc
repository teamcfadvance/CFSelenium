component accessors="true" hint="A CFML binding for Selenium" {
	
	variables.JavaFactory = new JavaFactory();

	public Selenium function init( string driverType="", string driverPath="" ) {
		structAppend(variables,arguments,true);
		variables.sessionId = "";
		
		setDriverByType( arguments.driverType );

		return this;
	}
	
	public cfselenium.drivers.WebDriver function getDriver() {
		return variables.driver;
	}
	
	public void function setDriver( required cfselenium.drivers.WebDriver driver ) {
		variables.driver = arguments.driver;
	}
	
	public void function setDriverByType( string driverType="" ) {
		// just implement Internet Explorer and firefox for now
		if ( arguments.driverType == "ie" || arguments.driverType == "InternetExplorer" ) {
			variables.driver = new cfselenium.drivers.InternetExplorerDriver();
		} else if ( arguments.driverType == "firefox" || arguments.driverType == "ff" ) {
			variables.driver = new cfselenium.drivers.FireFoxDriver();
		} else {
			variables.driver = new cfselenium.drivers.WebDriver();
		}
	}

}
