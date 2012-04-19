Welcome to the wonderful world of Wirebox! And the sweet gooey goodness of being able to easily use service layer objects (objects that are NOT tied to any table!) in your Wheels controllers!

With this plugin, you can now utilize Wirebox service layer objects (for a human definition, see http://www.dougboude.com/blog/1/2007/02/Just-What-IS-a-Service-Layer-Anyway.cfm for a concise analogy).

EXAMPLE CONTROLLER CODE:
	<cffunction name="importUsers">

		<cfset result = service("importService").importData(params.dataIn) />
		
		<cfset flashInsert(msg=result) />
		
		<cfset redirectTo(action="index") />
	</cffunction>

NOTICE THE CALL TO THE "SERVICE()" METHOD; this method is added to all controllers by this plugin. Use it exactly as you use the Wheels native 'model()' call!


GETTING STARTED

1. Download the latest version of Wirebox and drop it into your web root (/wirebox) (http://www.coldbox.org/download)

2. Reload the app. The plugin will place an empty copy of the wirebox configuration file in your config directory.
   THIS will be the place where you will define your service layer objects.
    (note: You can also place configuration CFCs of the same name in your individual environment folders!)

3. Now we'll edit your configuration CFC. Two things you need to do:
   a) decide where your service layer objects will live. By default, the plugin assumes that you have created a folder off the web root called "services", and that's where your little babies will be living. If this is NOT the case, you can easily change this location to whatever you want it to be.
   b) Tell Wirebox about your service layer objects, IF any of them will require special handling during creation (which most of them probably will). If not, then there's nothing for you to do except drop your service layer objects into the services folder and start using them.

4. Reload the app


GETTING STARTED WITH WIREBOX
Wirebox is a Dependency Injection framework that is extremely robust and acts as an object factory. When you want a service layer object, Wirebox will create it and give it to you.

As with any robust framework, it is extremely flexible and allows you to do nearly anything you can imagine with regard to object creation. You can:
	inject Wheels setting values into an object;
	inject Wheels' built in ORM capabilities (and other utility functions) into an object. I.e., the ability to call Wheels models from within your object;
	inject service layer objects into other service layer objects;
	and much more!
	
WIREBOX QUICK START

Because Wirebox IS so robust and the documentation would literally take you an hour to parse through, here is a quick start to give you some examples of defining service layer objects in your config.cfc:

THE SCENARIO
you have two CFCs that are service layer objects. A dataImport object, and a persistenceStorage object. The first performs data imports, the second acts as liaison between your app and the place you store your session variables (probably session, but could be client scope or whatever).

In order to perform its job, dataImport.cfc needs to have the Wheels datasourcename value, a pre-defined message that was set in the Wheels settings, and an instance of the persistenceStorage object at the time that dataImport is created. 

in our config.cfc's 'config' method we would add:

		<cfscript>
			//create shortcut to our wheels datasourcename setting
			map("dsn").toDSL("wheels:setting:datasourcename");
			
			//define our persistence layer object
			map("sessionStorage")
				.to("services.wormhole")
				.asSingleton();
			
			//define our import service layer object
			mapPath("services.importService")
				.asSingleton()
				.initArg(
					name="dsn",
					ref="dsn")
				.initArg(
					name="messageprefix",
					dsl="wheels:setting:messageprefix"
				)
				.property(name="sessionService",ref="sessionStorage")
				.mixins(wheelsORM);//give this object the ability to access Wheels models
		</cfscript>




There are SO many different ways to accomplish the example above. Besides defining injected values in the config.cfc, for example, you COULD opt to utilize Wirebox's "annotations", wherein you markup your service layer object in such a way that Wirebox knows what you want to inject, where, and how.
I highly recommend that you take some time to check out the wirebox docs at http://wiki.coldbox.org/wiki/WireBox.cfm, especially the section on configuring wirebox and mapping objects (http://wiki.coldbox.org/wiki/WireBox.cfm#Mapping_DSL)





