UnitTestDB [PL/SQL]
==========
----------------------------------------------------
UTDB (Unit Test for Oracle DB [PL/SQL])

link to releases https://github.com/svv2014/UnitTestDB/releases

This script is a dummy for a unit test.
It has support functions for test of procedures,functions,views,DML,DDL,trigers etc.

While wrighting unit test keep in mind:
  - code should not contain DDL,grant,commit.
  - don't call function/procedure that calls explicetly or implicetly DDL,grant,commit
  - after all 'DML' operations in the end of a test should be 'rollback'
