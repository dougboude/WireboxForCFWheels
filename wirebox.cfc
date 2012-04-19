<!---
	Created by: Doug Boude (rhymes with 'loud')
	
	This plugin incorporates the Wirebox framework into CFWheels, providing the developer with the ability to compose wheels-enabled service layer objects,
	and call them from within controllers.
	
	Additionally, this plugin extends Wirebox with a Wheels-specific DSL that can be used to inject Wheels values into objects during their creation.
	
	See the 'ReadMeDude.txt' file for a Quick Start
	
	(acknowledgments: Borrowed the "find the configuration file" code below from Javier Julio's "ObjectFactory" plugin. Thanks Javier!)
--->
<cfcomponent output="false" mixin="controller" displayname="wirebox" 
		hint="I am the primary cfc in the cfwheels wirebox plugin. I add the 'service' method to your wheels controllers.">
	
    <cffunction name="init">
	<!--- default values for config cfc --->
		<cfset var WBconfigFile = "wirebox_config">
		<cfset var configClassPath = "plugins.wirebox.#WBconfigFile#" />
		
        <cfset this.version = "0.1">

		<!--- 
		Set Config Path
		checks config/<envirnonment>/<configFileName> then config/<configFileName>
		 --->
		<cfif FileExists(expandPath("/config/#APPLICATION.WHEELS.ENVIRONMENT#/#WBconfigFile#.cfc"))>
			<cfset configClassPath = "config.#APPLICATION.WHEELS.ENVIRONMENT#.#WBconfigFile#" />
		<cfelseif FileExists(expandPath("/config/#WBconfigFile#.cfc"))>
			<cfset configClassPath = "config.#WBconfigFile#" />
		<cfelse><!--- didn't find our config file anywhere; give the user a blank copy in their config folder --->
			<cffile action="copy" destination="#expandPath("/config/#WBconfigFile#.cfc")#" source="#expandPath("/plugins/wirebox/#WBconfigFile#.cfc")#" />
			<cfset configClassPath = "config.#WBconfigFile#" />
		</cfif>
		
		<!--- instantiating the wirebox framework, passing in the configuration binder class path --->
		<cfset application.wirebox = createObject("component","wirebox.system.ioc.Injector").init(configClassPath) />
		
        <cfreturn this>
    </cffunction>


<!--- ****************  PUBLIC METHODS *************************************** --->
	<cffunction name="service" returntype="any" access="public"
		hint="I introduce the 'service' function to the controllers so they can utilize wirebox service layer objects">
		
		<cfargument name="targ" type="string" required="false" />
		
		<cfreturn application.wirebox.getInstance(arguments.targ) />	
	</cffunction>

</cfcomponent>