/*
 * Format for Selenium Remote Control CFML client.
 */

load('remoteControl.js');

this.name = "grails-junit3";

/**
 * Combines commands involving waits into single *AndWait commands, using the
 * hook provided in filterForRemoteControl(). Returns the modified list.
 *
 * @param commands
 */
function postFilter(filteredCommands) {
    var i = 1;
    
    while (i < filteredCommands.length) {
        var command = filteredCommands[i];
        if (command.command == 'waitForPageToLoad') {
            filteredCommands[i-1].command += 'AndWait';
            filteredCommands.splice(i, 1);
        }
        else {
            ++i;
        }
    }
    return filteredCommands;
}
    
function testMethodName(testName) {
    return "test" + capitalize(testName);
}

function assertTrue(expression) {
    return "assertTrue " + expression.toString();
}

function verifyTrue(expression) {
    return "assertTrue " + expression.toString();
}

function assertFalse(expression) {
    return "assertFalse " + expression.toString();
}

function verifyFalse(expression) {
    return "assertFalse " + expression.toString();
}

function assignToVariable(type, variable, expression) {
    return type + " " + variable + " = " + expression.toString();
}

function ifCondition(expression, callback) {
    return 'if (' + expression.toString() + ") {\n"
        + indents(1) + callback() + "\n"
        + '}';
}

function joinExpression(expression) {
    return expression.toString() + ".join(',')";
}

function waitFor(expression) {
    return "selenium.waitFor {\n"
        + indents(1) + expression.toString() + "\n"
        + '}';
}

function assertOrVerifyFailure(line, isAssert) {
    var message = '"expected failure"';
    var failStatement = "fail(" + message + ")";
    return "try {\n"
        + indents(1) + line + "\n"
        + indents(1) + failStatement + "\n"
        + "}\n"
        + 'catch (e) {}';
}

Equals.prototype.toString = function() {
    return "selenium." + this.e2.toString() + " == " + this.e1.toString();
}

Equals.prototype.assert = function() {
    return "assertEquals " + this.e1.toString() + ", " + this.e2.toString();
}

Equals.prototype.verify = function() {
	this.assert();
}

NotEquals.prototype.toString = function() {
    return this.e1.toString() + " != " + this.e2.toString();
}

NotEquals.prototype.assert = function() {
    return "assertEquals " + this.e1.toString() + ", " + this.e2.toString();
}

NotEquals.prototype.verify = function() {
	this.assert();
}

RegexpMatch.prototype.toString = function() {
	return this.expression + " =~ " + slashyString(this.pattern);
}

function pause(milliseconds) {
    return "sleep " + parseInt(milliseconds);
}

function echo(message) {
    return "println " + xlateArgument(message);
}

function statement(expression, command) {
    expression.command = command ? command.command : "";
    return expression.toString();
}

function array(value) {
    var str = '[ ';
    for (var i = 0; i < value.length; i++) {
        str += string(value[i]);
        if (i < value.length - 1) str += ", ";
    }
    str += ' ]';
    return str;
}

CallSelenium.prototype.toString = function() {
    var result = '';
    
    if (this.negative) {
        result += '! ';
    }
    if (options.receiver) {
        result += options.receiver + '.';
    }
    if (/AndWait$/.test(this.command)) {
        result += this.command;
    }
    else {
        result += this.message;
    }
    result += '(';
    
    for (var i = 0; i < this.args.length; i++) {
        result += this.args[i];
        if (i < this.args.length - 1) {
            result += ', ';
        }
    }
    
    result += ')';
    return result;
}

function formatComment(comment) {
    return comment.comment.replace(/.+/mg, function(str) {
            return "// " + str;
        });
}

function slashyString(value) {
	if (value != null) {
		return '/' + value + '/';
	} else {
		return '""';
	}
}

this.options = {
    receiver: "selenium",
    packageName: "com.example.tests",
    superClass: "GroovyTestCase",
    indent: '4',
    initialIndents: '2'
};

options.getHeader = function() {
    var timeout = options['global.timeout'] || '30000';
    return "component extends=\"mxunit.framework.TestCase\" displayName=\"${className}\" {\n\n"
        + indents(1) + "public void function setUp() {\n"
        + indents(2) + "browserUrl = \"enter_starting_url_here\";\n"
        + indents(2) + "selenium = new selenium(browserUrl);\n"
        + indents(2) + "selenium.setTimeout(" + timeout + ");\n"
        + indents(2) + "selenium.start();\n"
        + indents(1) + "}\n\n"
        + indents(1) + "public void function tearDown() {\n"
        + indents(2) + "selenium.stop();\n"
        + indents(1) + "}\n\n"
        + indents(1) + "public void function ${methodName}() {\n";
}

options.footer = indents(1) + "}\n"
    + "}\n";

this.configForm = 
	'<description>Package</description>' +
	'<textbox id="options_packageName" />' +
	'<description>Superclass</description>' +
	'<textbox id="options_superClass" />' +
    '<description>Indent</description>' +
    '<menulist id="options_indent"><menupopup>' +
    '<menuitem label="Tab" value="tab" />' +
    '<menuitem label="2 spaces" value="2" />' +
    '<menuitem label="4 spaces" value="4" />' +
    '<menuitem label="8 spaces" value="8" />' +
    '</menupopup></menulist>';

