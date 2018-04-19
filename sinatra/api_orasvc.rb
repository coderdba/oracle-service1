require 'sinatra'
require 'fileutils'
require 'date'

# =============

# -------------------------------
# GLOBAL VARIABLES
# -------------------------------

homedir=ENV['HOME']

# ==============

# -------------------------------
# URL - CREATE - Schema-creator 
# -------------------------------
#post "/create/:schema_name" do
get "/create/:schema_name" do

schema_name = params[:schema_name]

templog="#{homedir}/twork/oracle_saas/logs/#{schema_name}_create.log"
schema_create_log="#{homedir}/twork/oracle_saas/logs/schema_create.log"
schema_create_err="#{homedir}/twork/oracle_saas/logs/schema_create.err"
schema_inventory="#{homedir}/twork/oracle_saas/logs/schema_inventory.txt"
timestamp=Time.now.strftime("%Y-%m-%d-%H:%M")

inventory_status_line=":#{schema_name}:CREATE:#{timestamp}:"

# CHECK IF ALREADY CREATED AND EXIT IF SO

if File.readlines(schema_inventory).grep(/:#{schema_name}:/).size > 0

  message="<br>INFO - Schema #{schema_name} has been created already <br> <br> ... talk to administrator if you have forgotten its credentials <br><br>"
  puts message
  message

else


# BEGIN WORK
puts "INFO - Trying to create schema #{schema_name}"  

f = File.open(templog, 'w+')
old_out = $stdout
$stdout = f

#puts 'here_1'

Dir.chdir ("#{homedir}/twork/oracle_saas/ansible/oracle_saas1")

# CALL ANSIBLE PLAYBOOK
retval = %x(/usr/local/bin/ansible-playbook -s oraclesvc.yml -u ansible --extra-vars="schema_name=#{schema_name} schema_action=CREATE")
puts retval

f.close
$stdout = old_out

puts "Schema Logfile is #{templog}"

# CHECK SUCCESS OR FAILURE
#if File.readlines(templog).grep(/ORA-/).size > 0 
#if File.readlines(templog).grep(/ORA-/).size > 0 || File.readlines(templog).grep(/Err/).size > 0
if File.readlines(templog).grep(/ORA-/).size > 0 || File.readlines(templog).grep(/"failed": true/).size > 0

  inventory_status_line="#{inventory_status_line}:FAILURE"
  message="<br>ERR - Schema creation error #{schema_name} <br><br> Schema may already exist or there may be other error <br><br> Contact administrator <br><br>"   

  f = File.open(schema_create_err, 'a')
  f.puts message
  f.close

  # DO NOT place failed schemas in inventory
  #f = File.open(schema_inventory, 'a')
  #f.puts inventory_status_line
  #f.close

  puts message
  message

else

  inventory_status_line="#{inventory_status_line}:SUCCESS"
  #message="INFO - Schema creation success #{schema_name} <br><br>"  
  message="<br>INFO - Database schema #{schema_name} has been created <br><br> Host: ed01-scan, Port: 1521, <br>Oracle NUID: #{schema_name}, Password: Sent to your email"

  f = File.open(schema_create_log, 'a')
  f.puts message
  f.close

  f = File.open(schema_inventory, 'a')
  f.puts inventory_status_line
  f.close

  puts message
  message

end

end

end

# ==============

# ---------------------------------------------
# URL to check if my schema is created already
# ---------------------------------------------
get "/exists/:schema_name" do

schema_name = params[:schema_name]

schema_inventory="#{homedir}/twork/oracle_saas/logs/schema_inventory.txt"

# BEGIN WORK

if File.readlines(schema_inventory).grep(/:#{schema_name}:/).size > 0

  schema_record=File.readlines(schema_inventory).grep(/:#{schema_name}:/) 

  message="<br>INFO - Database #{schema_name} has been created <br><br> Details - #{schema_record}"
  message

else

  message="<br>WARN - Schema #{schema_name} has not been created ... Check with administrator <br><br>"  
  message

end

end

# =============

# -------------------------------
# URL REMOVE - Schema-remove URL
# -------------------------------
#post "/remove/:schema_name" do
get "/remove/:schema_name" do

schema_name = params[:schema_name]

templog="#{homedir}/twork/oracle_saas/logs/#{schema_name}_remove.log"
schema_remove_log="#{homedir}/twork/oracle_saas/logs/schema_remove.log"
schema_remove_err="#{homedir}/twork/oracle_saas/logs/schema_remove.err"
schema_inventory="#{homedir}/twork/oracle_saas/logs/schema_inventory.txt"
schema_inventory_schema_removed="#{homedir}/twork/oracle_saas/logs/schema_inventory.txt.removed.#{schema_name}"
timestamp=Time.now.strftime("%Y-%m-%d-%H:%M")

# CHECK IF ALREADY REMOVED AND EXIT IF SO

if File.readlines(schema_inventory).grep(/:#{schema_name}:/).size <= 0

  message="<br>INFO - Schema #{schema_name} has been removed already ... talk to administrator if you are still able to access it"
  puts message
  message

else


# BEGIN WORK
puts "INFO - Trying to remove schema #{schema_name}"  

f = File.open(templog, 'w+')
old_out = $stdout
$stdout = f

#puts 'here_1'

Dir.chdir ("#{homedir}/twork/oracle_saas/ansible/oracle_saas1")

# CALL ANSIBLE PLAYBOOK
retval = %x(/usr/local/bin/ansible-playbook -s oraclesvc.yml -u ansible --extra-vars="schema_name=#{schema_name} schema_action=REMOVE")
puts retval

f.close
$stdout = old_out

puts "Schema Logfile is #{templog}"

# CHECK SUCCESS OR FAILURE
#if File.readlines(templog).grep(/ORA-/).size > 0
#if File.readlines(templog).grep(/ORA-/).size > 0 || File.readlines(templog).grep(/Err/).size > 0
if File.readlines(templog).grep(/ORA-/).size > 0 || File.readlines(templog).grep(/"failed": true/).size > 0

  puts "Log file is #{schema_remove_log}"
  puts "Err file is #{schema_remove_err}"

  message="ERR - Schema removal error for #{schema_name} .... talk to administrator"  

  f = File.open(schema_remove_err, 'a')
  f.puts message
  f.close

  puts message
  message

else

  message="INFO - Schema removal success #{schema_name}"  

  f = File.open(schema_remove_log, 'a')
  f.puts message
  f.close

  File.open(schema_inventory_schema_removed, 'w') do |out_file|
    File.foreach(schema_inventory) do |line|
       out_file.puts line unless line =~ /:#{schema_name}:/
    end
  end

  #IO.copy_stream(schema_inventory_schema_removed, schema_inventory)
  FileUtils.cp(schema_inventory_schema_removed, schema_inventory)

  puts message
  message

end

end

end
