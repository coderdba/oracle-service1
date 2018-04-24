package com.gm.rest.spring.oracle1;

import com.gm.rest.spring.oracle1.UnixUtils;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class Controller {

	@RequestMapping("/")
	public String welcome() {	
		return "<br><br> Welcome to Oracle Service <br><br>";
	}
	
	@RequestMapping("/runshell")
	public String runShell() throws Exception {	
		UnixUtils unixUtils = new UnixUtils();
		return "Shell returned " + Integer.toString(unixUtils.runShell());
				//+ Integer.toString (unixUtils.runShell());	
	}
	
	@RequestMapping("/runansible")
	public String runAnsible() throws Exception {	
		UnixUtils unixUtils = new UnixUtils();
		unixUtils.runAnsible();
		return "Completed";
				
		//return "Shell returned " + Integer.toString(unixUtils.runShell());
				//+ Integer.toString (unixUtils.runShell());	
	}
	
	@RequestMapping(value = "/schema/create/{schemaName}", method = RequestMethod.GET)
	//public @ResponseBody
	public String oracleSchemaCreate(@PathVariable("schemaName") String schemaName) throws Exception {	
		
		OracleUriFunctions oraFunction = new OracleUriFunctions();
		int retcode;
		
		oraFunction.oracleAnsible(schemaName, "CREATE");
		
		return "Completed " + retcode;
	
	}
	
	@RequestMapping(value = "/schema/remove/{schemaName}", method = RequestMethod.GET)
	//public @ResponseBody
	public String oracleSchemaRemove(@PathVariable("schemaName") String schemaName) throws Exception {
		
		OracleUriFunctions oraFunction = new OracleUriFunctions();
		int retcode;
		
		oraFunction.oracleAnsible(schemaName, "REMOVE");
		
		return "Completed " + retcode;
	
	}
	
	// POST WITH JSON FORMATTED REQUEST BODY
	@RequestMapping(value = "/schema/json/create", method = RequestMethod.POST)
	public String oracleSchemaCreateJsonRequest(@RequestBody SchemaRequest schemaRequest) throws Exception {	
		
		System.out.println("Inside oracleSchemaCreateJsonRequest");
		
		OracleUriFunctions oraFunction = new OracleUriFunctions();
		int retcode;
		
		retcode = oraFunction.oracleAnsible(schemaRequest.getSchemaName(), "CREATE");
		
		return "Completed" + retcode;
		
	}
}
