package com.gm.rest.spring.oracle1;

import java.lang.ProcessBuilder;
import java.util.*;
import java.io.File;
import java.io.IOException;

public class OracleUriFunctions {
	
	public int oracleAnsible(String schemaName, String schemaAction) throws Exception {

		int exitCode;
		String extraVarSchemaName   = "schema_name=" + schemaName;
		String extraVarSchemaAction = "schema_action=" + schemaAction;
		
		ProcessBuilder pb = new ProcessBuilder("/usr/local/bin/ansible-playbook", 
				"-s", "/Users/username/twork/oracle_saas/ansible/oracle_saas1/oracle_saas.yml", 
				"-i", 
				"/Users/username/opt/ansible/hosts", 
				"-u", "ansible",
				"-e",
				extraVarSchemaName, "-e", extraVarSchemaAction);

		System.out.println (pb.command().toString());
		
		File logfile = new File("/tmp/javaansible.log");

		pb.redirectErrorStream(true);
		pb.redirectOutput(logfile);
		pb.directory(new File("/Users/username//twork/oracle_saas/ansible/oracle_saas1"));
		Process p = pb.start();
		
		exitCode = p.waitFor();
		
		return exitCode;

	}
	
	// does not return returncode of ansible operation
	public void oracleAnsibleVoid(String schemaName, String schemaAction) throws Exception {

		int exitCode;
		String extraVarSchemaName   = "schema_name=" + schemaName;
		String extraVarSchemaAction = "schema_action=" + schemaAction;
		
		ProcessBuilder pb = new ProcessBuilder("/usr/local/bin/ansible-playbook", 
				"-s", "/Users/username/twork/oracle_saas/ansible/oracle_saas1/oracle_saas.yml", 
				"-i", 
				"/Users/username/opt/ansible/hosts", 
				"-u", "ansible",
				"-e",
				extraVarSchemaName, "-e", extraVarSchemaAction);

		System.out.println (pb.command().toString());
		
		File logfile = new File("/tmp/javaansible.log");

		pb.redirectErrorStream(true);
		pb.redirectOutput(logfile);
		pb.directory(new File("/Users/username//twork/oracle_saas/ansible/oracle_saas1"));
		Process p = pb.start();
		
		exitCode = p.waitFor();

	}
}
