# Oracle Service

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ORACLE DATABASE SCHEMA SERVICE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


===============================
Two ways of using this service
===============================
- RUN ANSIBLE PLAYBOOK DIRECTLY
- USING THE REST API


=============================
RUN ANSIBLE PLAYBOOK DIRECTLY
=============================
Go to the directory ansible/oracle_saas1

Run the command: (replace abc with required schema name, and CREATE with CREATE or REMOVE
/usr/local/bin/ansible-playbook -s oracle_saas.yml -u ansible --key-file "~/.ssh/ansible.key" --extra-vars="schema_name=abc schema_action=CREATE"


=========================
USING THE REST API
=========================
--------------------------------------------------
There are three Sinatra REST API files:
--------------------------------------------------

api_orasaas.rb - with no html formatted output
api_orasaas_html.rb - invoked by html, gives formatted html output
api_orasaas_logging.rb - with no html, does more logging

-----------------------------
To run the Sinatra API server
-----------------------------
Go to env directory
$ cd env

Set environment:
- Set ruby environment: 
$ . envruby

- Set ansible environment: 
$ . envansible

Start the API: 
$ ruby <one of the API files mentioned above>

$ ruby api_orasaas.rb 
$ ruby api_orasaas_html.rb 
$ ruby api_orasaas_logging.rb 

============
CURL/HTML
============
-------------------------
cURL to create a DB
-------------------------

Start API server as described above - with api_orasaas.rb

For simplicity - all are GET's

Invoke REST URLs directly: (via curl or browser)
http://localhost:4567/create/db_name
http://localhost:4567/exists/db_name
http://localhost:4567/remove/db_name

-------------------------
To access using HTML:
-------------------------
NOTE: To get HTML input page:
      --> No webserver is installed, just invoke the html file:///Users/username/..../oracle_saas/html/oraservice.html

STEPS:
Start API server as described above - with api_orasaas_html.rb
Access the local html in a browser: file:///Users/username/..../oracle_saas/html/oraservice.html

Provide the inputs
Click one of the service buttons
$ 
