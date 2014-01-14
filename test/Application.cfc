component {
	this.name = 'cfselenium tests';
	
	this.mappings[ '/cfselenium' ] = getDirectoryFromPath(getCurrentTemplatePath()) & "../";
	this.mappings[ '/test' ] = getDirectoryFromPath(getCurrentTemplatePath());
}