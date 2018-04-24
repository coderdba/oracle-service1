package com.gm.rest.spring.oracle1;

import java.io.*;

public class SchemaRequest implements Serializable {
	
	private String schemaName;
	
    public String getSchemaName() {
        return schemaName;
    }
    
    public void setSchemaName(String schemaName) {
        this.schemaName = schemaName;
    }

}
