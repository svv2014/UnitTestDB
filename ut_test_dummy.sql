/* For Java UT Test Runner
   $BEGIN
   ------------------------------------------------------
   $Author:
   ------------------------------------------------------
   $PACKAGE=<tested package name>
   $TEST_NAME=<Name tested functional>
   $TEST_DESCRIPTION="<Description>   "

   $END
*/
declare
  ------------------------------------------------------------------
  -- functional variables 
  Error            number := 0;      --Count of errors
  svCurrentStep    varchar2(256);    --Current step of Test Case
  sCnt             number := 1;      --Count for namber of checking
  svShowSuccessLog boolean := false; --show success log by default false;
  Failure exception;                 --Local exception when count errors more then 0
  TYPE t_times IS TABLE OF timestamp  INDEX BY VARCHAR2(40);
  stTimer t_times;
  Pragma EXCEPTION_INIT(Failure, -20100);
  
  ------------------------------------------------------------------
  -- set show success log
  procedure ut_showSuccessLog(inShow boolean) is 
  begin
     svShowSuccessLog := nvl(inShow,false);
  end ut_showSuccessLog;

  ------------------------------------------------------------------
  --Logging steps and actions
  procedure wtext(inText varchar2) is
    pragma AUTONOMOUS_TRANSACTION;
  begin
   dbms_output.put_line(inText);	 
   if SYS_CONTEXT('USERENV', 'MODULE') != 'PL/SQL Developer' then
      -- save text to log table if such exists
      for i in (select *
                  from user_tables
                 where table_name = 'UT_TEMP_TEST_TABLE'
                   and rownum = 1)
      loop
        execute immediate ('insert into ut_temp_test_table (ts,message,sessionid) values (systimestamp,''' ||
                          substr(inText, 0, 4000) || ''',' || SYS_CONTEXT('USERENV', 'SESSIONID') || ')');

      end loop;
    end if;
    commit;
  exception
    when others then
      rollback;
  end;
  
  procedure ut_text(inText varchar2) is
  begin
   wtext(inText);
  end;
  ---------------------------------------------------------------------
  --Adding before text **Current Step** and fill sys variable for debug
  procedure ut_curr_step(inText varchar2) is
  begin
    svCurrentStep := substr(inText,0, 256);
    wtext('**Current Step**  ' || svCurrentStep);
  end;
  ------------------------------------------------------------------
  --add Comment
  procedure ut_comment(inText varchar2) is
  begin
    wtext('**Comment**  ' || inText);
  end;
  ------------------------------------------------------------------
  --Check and Logging BOOLEAN
  procedure ut_check(inText varchar2, inBool boolean) is
    vText varchar2(4000);
  begin
    vText := substr(inText,0, 4000);
    if not inBool then
      Error := Error + 1;
      vText := substr(sCnt || '-FAILURE !!! ' || vText,0, 4000);
      wtext(vText);
    else
      vText := substr(sCnt || '-Well Done. ' || vText,0, 4000);
      if svShowSuccessLog then 
         wtext(vText);
      end if;
    end if;
    sCnt := sCnt + 1;
  end ut_check;
  ------------------------------------------------------------------
  --Check and Logging VARCHAR2
  procedure ut_check(inText varchar2, var1 varchar2, var2 varchar2) is
  begin
    ut_check('(' || var1 || ',' || var2 || ')' || inText, nvl(var1, 'null') = nvl(var2, 'null'));
  end ut_check;
  ------------------------------------------------------------------
  --Check and Logging NUMBER
  procedure ut_check(inText varchar2, var1 number, var2 number) is
  begin
    ut_check('(' || var1 || ',' || var2 || ')' || inText, nvl(var1, -99999) = nvl(var2, -99999));
  end ut_check;
  procedure ut_startTimer(name varchar2) is
  begin
       stTimer(name) := current_timestamp;
  end;
  procedure ut_finishTimer(name varchar2) is
  begin
      wtext('###Timer '||name||' :'||to_char(current_timestamp - stTimer(name)));
  end;
  procedure showAllContext is --showing session context
    tcontext dbms_session.AppCtxTabTyp;
    cnt number;
  begin
    dbms_session.list_context(list => tcontext,lsize => cnt);
    for c in 1..cnt loop 
       dbms_output.put_line(tcontext(c).namespace||':'||tcontext(c).attribute||':'||tcontext(c).value);
    end loop;
  end;
begin
  --********************* Description of functionality **************************************
  -- Procedures for use:
  --      Check procedures:
  --            ut_check('some comment for test', expression )           -- for BOOLEAN Check, 
  --                                                                        When expression FALSE then sys variable ERROR + 1
  --            ut_check('some comment for test', variable1, variable2 ) -- for check 2 Numbers or Character
  --      Text procedures:
  --            wtext('some text')                                 -- write text to log 
  --            ut_text('some text')                               -- write text to log 
  --            ut_curr_step('Descriotion current step of checks') -- adding before text **Current Step**
  --            ut_comment('Comment for some reason')              -- adding before text **Comment**
  --      Others:
  --            ut_startTimer('name timer')    --start timer
  --            ut_finishTimer('name timer')   --show time
  --            showAllContext                 --show session context
  --            ut_showSuccesLog(true)         --set true for seing in log Seccessed checks
  --                                             by default false
  --*****************************************************************************************
  --*****************************************************************************************
  --*****************************************************************************************
  --*****************************************************************************************
  --******************************Begin of test block****************************************
  wtext('-----------------------------------------------------------');
  wtext('--Description about test for head of log report');
  ut_startTimer('Total');
  --by default it is false, so, we put true to see all logs
  ut_showSuccessLog(true);
  declare
    --local variables for test
  begin
    -- Current test step 
    ut_curr_step('Test case #1');
    --TESTS
    ut_comment(' There some test for check two character values');
    ut_check(' test of two char ', 'Y', 'N');
    ut_check(' test of two char ', 'Y', 'Y');
    --need set false for hide Seccessed checks in log
    ut_showSuccessLog(false);
    ut_check(' test of two char ', 'Y', 'Y');
  end;
  ut_finishTimer('Total');
  --*******************************End of test block*****************************************
  --*****************************************************************************************
  --*****************************************************************************************
  --*****************************************************************************************
  --*****************************************************************************************

  --- Check for errors and raise error if have some one
  ut_curr_step('Check for Errors');
  if Error > 0 then
    ut_comment('FAILURE Test !!!, Errors = ' || error ||  ', checks:'||(sCnt-1)||', Error step = ''' ||
                            svCurrentStep || '''');
    raise Failure;
  end if;
  ut_comment('Test SUCCESS,total checks:'||(sCnt-1));
exception
  when Failure then
    raise_application_error(-20101,
                            'FAILURE Test !!! Errors = ' || error ||  ', checks:'||(sCnt-1)||', Error step = ''' ||
                            svCurrentStep || '''');
end;
/
