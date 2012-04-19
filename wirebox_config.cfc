<cfcomponent extends="wirebox.system.ioc.config.Binder" hint="I am a wirebox configuration binder class.">
	<!---  Please do not alter the customDSL or the wheelsORM lines. 
		You can modify scan locations if you opt to have your service layer objects live somewhere besides "services",
		or you wish to add additional services locations --->
		
	<cfset variables.wheelsORM = "/plugins/wirebox/wheelsORM.cfm" />	
		
	<!--- The Wirebox Configure method --->
	<cffunction name="configure">
		<cfscript>
		
			wirebox = {
				scanLocations = ["services"], // the folder we want wirebox to look in for service layer objects. Is an array, so add as many folders as you like. 
				customDSL = {wheels = "plugins.wirebox.wheelsDSL"}// do not remove. ever. It's like a tag on a mattress.  
			};
		</cfscript>

		<!--- 	************************* NOTES ****************************************************************		
		You can use wirebox to automagically inject wheels settings and its ORM capabilities
		into your service layer objects! Just use annotations like this:  "wheels:setting:[the setting name]".
		Here is an example of a wirebox mapping. Note the value being passed in uses the Wheels Domain Specific Language syntax:
		
		<cfset map("wormhole").to("services.wormhole").initArg(name="dsn",dsl="wheels:setting:datasourcename") />
			
		Additionally, IF your service layer object requires the ability to talk to Wheels Models, you MUST include
		".mixins(wheelsORM)" to your dependencies chain.
		As in, 
			<cfset map("mySLO")
				.to("services.mySLO")
				.initArg(name="dsn",dsl="wheels:setting:datasourcename")
				.mixins(wheelsORM) 
			/>
		
		if you fail to add the 'mixins' dependency, your object will not be able to make model() calls.
		
		for more information on using Wirebox and its myriad of options, visit http://wiki.coldbox.org/wiki/WireBox.cfm
		
		You can also get lots of help on the Coldbox/Wirebox google group (coldbox@googlegroups.com)
		********************************************************************************************************** --->
		
		<!--- add your wirebox object mappings below!  --->	 
 		
			 
	</cffunction>
</cfcomponent>