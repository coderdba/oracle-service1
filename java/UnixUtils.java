package com.gm.rest.spring.oracle1;

import java.lang.ProcessBuilder;
import java.util.*;
import java.io.File;
import java.io.File;
import java.io.IOException;

public class UnixUtils {
	
	public int runShell() throws Exception {
	
		String retval = null;
		int exitCode;
		
		//ProcessBuilder pb = new ProcessBuilder ("/bin/date");
		
		ProcessBuilder pb = new ProcessBuilder ("/bin/ls", "-l", "/tmp");
		File logfile = new File("/tmp/javaunix.log");
		
		pb.redirectErrorStream(true);
		pb.redirectOutput(logfile);
		
		Process p = pb.start();
		
		exitCode = p.waitFor();
		
		return exitCode;
	}
	
	public void runAnsible() throws Exception {

		ProcessBuilder pb = new ProcessBuilder("/usr/local/bin/ansible-playbook", 
				"-s", "/Users/username/twork/oracle_saas/ansible/oracle_saas1/oracle_saas.yml", 
				"-i", 
				"/Users/username/opt/ansible/hosts", 
				"-u", "ansible",
				"-e",
				"schema_name=test", "-e", "schema_action=CREATE");

		System.out.println (pb.command().toString());
		
		File logfile = new File("/tmp/javaansible.log");
		int exitCode;
		
		pb.redirectErrorStream(true);
		pb.redirectOutput(logfile);
		pb.directory(new File("/Users/username//twork/oracle_saas/ansible/oracle_saas1"));
		Process p = pb.start();
		
		exitCode = p.waitFor();

	}
}
