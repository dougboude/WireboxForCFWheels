<cfcomponent implements="wirebox.system.ioc.dsl.IDSLBuilder" >
	
	<!--- include the core wheels functionality so our DSL can perform its 'get' calls --->
	<cfinclude template="wheelsORM.cfm" />
	
	<!--- init --->
    <cffunction name="init" output="false" access="public" returntype="any" hint="Configure the DSL Builder for operation and returns itself" colddoc:generic="wirebox.system.ioc.dsl.IDSLBuilder">
    	<cfargument name="injector" type="any" required="true" hint="The linked WireBox injector" />
    	<cfset instance = {injector = arguments.injector} />
		<cfreturn this />
    </cffunction>
	
	<!--- process --->
    <cffunction name="process" output="false" access="public" returntype="any" hint="Process an incoming DSL definition and produce an object with it.">
		<cfargument name="definition" 	required="true"  hint="The injection dsl definition structure to process. Keys: name, dsl"/>  
		<cfargument name="targetObject" required="false" hint="The target object we are building the DSL dependency for. If empty, means we are just requesting building"/>
		
		<cfset var aNamespace = listToArray(arguments.definition.dsl,":") />
		<cfset var retval = "" />
		
		<cfswitch expression="#arraylen(aNamespace)#"><!--- did we get a 3 item value? We should have... --->
			<cfcase value="3">
				<!--- we're looking at a value like wheels:setting:mysetting --->
				<cfswitch expression="#aNamespace[2]#">
					<cfcase value="setting">
						<!--- calling our wirebox plugin's private method. We have access because we extended the wirebox.cfc. It in turn calls the cfwheels 'get' method. --->
						<cfset retval = get(name=aNamespace[3]) />
					</cfcase>
					<cfdefaultcase>
						<cfthrow message="You used an invalid scope value in your DI annotation. You wrote:#arguments.definition.dsl#. The value #aNamespace[2]# is invalid. A proper value should consist of 'wheels:[model|setting]:[custom value]'" type="IOC Plugin" />
					</cfdefaultcase>
				</cfswitch>				
			</cfcase>
			<cfdefaultcase>
				<!--- the user failed to indicate what value to use. Let's throw an error. --->
				<cfthrow message="You used an invalid value in your DI annotation! You wrote:#arguments.definition.dsl#. A proper value should consist of 'wheels:setting:[custom value]'" type="IOC Plugin" />
			</cfdefaultcase>
		</cfswitch>
		<cfreturn retval />
    </cffunction>
</cfcomponent>