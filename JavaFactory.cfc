component
	hint="Creates Selenium objects from the Selenium Java library."
{

	public any function init() {
		var libPath = expandPath(
			getDirectoryFromPath(getCurrentTemplatePath())
			& "/lib"
		);
		variables.libs = arrayToList([
			libPath & "/webdrivermanager-1.4.5-SNAPSHOT-with-dependendies.jar",
			libPath & "/selenium-server-standalone-2.53.0.jar"
		]);
		return this;
	}
	
	public function createObject(
		required string className
	) {
		return createJavaObject(
			className = className,
			context = variables.libs
		);
	}
	
	private function createJavaObject(
		required string className,
		string context=""
	) {
		if (isCurrentCFMLEngineAdobe()) {
			return createObject("java", className);
		} else {
			// writeDump(var=arguments, abort=true);
			return createObject("java", className, context);
		}
	}
	
	/**
	* @hint Is the current CFML engine Adobe? (Note: Only considers Railo/Lucee as alternatives.)
	*/
	private boolean function isCurrentCFMLEngineAdobe() {
		if ( listFindNoCase("railo,lucee", server.coldfusion.productname) ) {
			return false;
		} else {
			return true;
		}
	}

}