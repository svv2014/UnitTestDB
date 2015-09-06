UnitTestDB
==========
----------------------------------------------------
UTDB (Unit Test Oracle DB PL/SQL)

link to releases https://github.com/svv2014/UnitTestDB/releases

This script is a dummy for unit test. 
It is good for test of any kind PL/SQL code like procedures,functions,views,DML,DDL,trigers etc.

The concept is:
  - test must be selfsuficient
  - test can not contains code with DDL,grant,commit
  - test can not call functions/procedures with DDL,grant,commit
  - if test contains 'DML' operation then in the end must call 'rollback'
