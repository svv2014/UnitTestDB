UnitTestDB(https://github.com/svv2014/UnitTestDB/releases)
==========
----------------------------------------------------
UTDB (Unit Test Oracle DB PL/SQL)

This functional made on the script for development needs to test PL/SQL code.

The concept current UT:
  - be self sufficient
  - should not contain code or do call to functions/procedures with:  DDL,grant,commit
  - if contain 'DML' operations then in the end should contain 'rollback' operation.
