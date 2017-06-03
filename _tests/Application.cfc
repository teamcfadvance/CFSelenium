/**
* Copyright Since 2005 Ortus Solutions, Corp
* www.ortussolutions.com
**************************************************************************************
*/
component {
	this.name = left( 'CFSelenium_Test_Suite_' & hash( getCurrentTemplatePath() ), 64 );

	this.sessionManagement = true;

	this.mappings[ "/testbox" ] = getDirectoryFromPath( getCurrentTemplatePath() ) & '../testbox';

	this.mappings[ '/cfselenium' ] = getDirectoryFromPath( getCurrentTemplatePath() ) & '../';
	this.mappings[ '/_tests' ] = getDirectoryFromPath( getCurrentTemplatePath() );

	this.javaSettings = { loadPaths = [ getDirectoryFromPath( getCurrentTemplatePath() ) & '../lib/selenium-server-standalone-3.4.0.jar' ] };
}
