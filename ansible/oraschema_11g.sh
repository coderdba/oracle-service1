usagefile=/tmp/ora_11g_schema.sh.usage

{

if [ $# -lt 2 ]
then
    echo Usage: $0 schema_name CREATE_or_REMOVE
    exit 1
fi

} > $usagefile

#export script_name=$0
export script_name=`basename $0`
export schema_name=$1
export schema_action=$2

loglocation=/tmp
#loglocation=~/

#outfile=~/${script_name}.${schema_name}.${schema_action}.out
#errfile=~/${script_name}.${schema_name}.${schema_action}.err
outfile=${loglocation}/${script_name}.${schema_name}.${schema_action}.out
errfile=${loglocation}/${script_name}.${schema_name}.${schema_action}.err

export schema_pass=${schema_name}_123_ABC

# CREATE SCHEMA SECTION
if [ "${schema_action}" == "CREATE" ]
then

{
sqlplus -s / as sysdba <<EOF

select sysdate from dual;

prompt Creating schema
prompt

create user $schema_name identified by $schema_pass default tablespace users temporary tablespace temp quota 100M on users;
grant resource to $schema_name;

EOF
} > $outfile 2>> $outfile

if (grep ORA- $outfile)
then

echo ERR - Error in SQL execution durig create schema > $errfile 2>> $errfile
echo
exit 1

else

echo SUCCESS >> $outfile

fi

# REMOVE SCHEMA SECTION
else if [ "${schema_action}" == "REMOVE" ]
then

{
sqlplus -s / as sysdba <<EOF

select sysdate from dual;

prompt Removing schema
prompt

drop user $schema_name cascade;

EOF
} > $outfile 2>> $outfile

if (grep ORA- $outfile)
then

echo ERR - Error in SQL execution during remove schema > $errfile 2>> $errfile
echo
exit 1

else

echo SUCCESS >> $outfile

fi

fi
fi
