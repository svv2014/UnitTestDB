UnitTestDB
==========
----------------------------------------------------
UTDB (Unit Test Oracle DB PL/SQL)

link to releases https://github.com/svv2014/UnitTestDB/releases

This script itself unit test for test any kind of PL/SQL code like procedures,functions,views,DML,DDL,trigers etc.

The concept current UT:
  - be self sufficient
  - must not contain code or call to functions/procedures with:  DDL,grant,commit
  - if if contains 'DML' operations then in the end should contain 'rollback' operation.

