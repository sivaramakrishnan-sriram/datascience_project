--Table name: Loan
--Data Analysis
--------------------------------------------------------------------------------------------------------------
select * from loan;

/*describe table*/
exec sp_columns loan
exec sp_columns salaries

--Data analysis on the basis of grade, interest rate, loan amount vs funded amount and loan status
select loan_amnt, funded_amnt_inv from loan where loan_amnt<>funded_amnt_inv;
select grade, sub_grade, int_rate from loan where grade='B' and sub_grade='B2';
select term, int_rate from loan;
select min(int_rate) from loan;
select * from loan where int_rate=5.31;
select home_ownership, loan_status from loan where home_ownership='MORTGAGE' and loan_status<>'Current';
select home_ownership, loan_status from loan where loan_status='Fully Paid';
select count(*) from loan where loan_status='Fully Paid';
select home_ownership, count(*) from loan group by home_ownership;
select count(*) from loan where addr_state='CA';
select count(*) from loan where emp_title is NULL;
select count(*) from loan; /*246,708*/
select count(*) from loan where emp_title is null and annual_inc is null;

--data analysis on null values
select count(*) from loan where annual_inc=0; /*517*/
select count(*) from loan where emp_title is null; /*33,642*/
select count(*) from loan where "desc" is not null;

/*selecting the followinf columns for current analysis:
grade/sub grade
emp_title
home_ownership
annual_inc
loan status
zip code
addr_state
*/
select loan_status, total_pymnt, funded_amnt_inv, (total_pymnt/funded_amnt_inv)*100 as paid from loan where ((total_pymnt/funded_amnt_inv)*100)>90;
select out_prncp, out_prncp_inv, total_pymnt, total_pymnt_inv, total_rec_prncp, total_rec_int, total_rec_late_fee, recoveries, 
select count(*) from loan where ((total_pymnt/funded_amnt_inv)*100)>90; /*10,894*/
select loan_status, zip_code from loan where loan_status like 'F%' order by zip_code;
select distinct zip_code from loan; /*887*/
select loan_status from loan where zip_code='6%';
Select name AS TableName, object_id AS ObjectID
From sys.tables
where name = 'loan';

/*creating a temporary logic/table for our analysis */

create table
    test1
    AS
        select 
            grade/sub grade,
            emp_title,
            home_ownership,
            annual_inc,
            loan status,
            zip code,
            addr_state
        FROM
            loan 
        where
            annual_inc<>0 AND
            emp_title is not null and
            loan_status<>'Charged Off' and
            zip_code like '9%',
            addr_state IN
            ('AK','CA','HI','OR') AND
            emp_title in
            (

            )

;

--Data Analysis on the basis of zip code and addr_state

select count(*) from loan where zip_code like '9%' and
annual_inc<>0 AND emp_title is not null and loan_status<>'Charged Off';
select zip_code, addr_state from loan where zip_code like '9%';
select emp_title from loan where
annual_inc<>0 AND
emp_title is not null and
loan_status<>'Charged Off' and
zip_code like '9%' and addr_state IN ('AK','CA','HI','OR'); /*32,933*/
select emp_title from loan where
annual_inc<>0 AND
emp_title is not null and
loan_status<>'Charged Off' and
zip_code like '9%' and addr_state IN ('AK','CA','HI','OR');
select count(*) from loan where addr_state is null;
-----------------------------------------------------------------------------------------------------
--------------------------------------------RESULTS--------------------------------------------------

--Data Cleaning Steps
--Step 1: code to see percent of null values in a all columns of a table and then sort

declare
cursor c1 is select column_name from user_tab_columns where table_name = 'LOAN';
--a cursor is declared that is taking column names as input
i integer;
j integer;
begin
FOR X1 in C1
LOOP 
/*this loop is finding the null values in a column and displaying count of null values.
Then, if the a column has null values less then 40% of the total rows, then it will display those column names only*/
  select count(1) into i from (
      select X1.column_name  from LOAN where X1.column_name is NULL
  );
  select count(1) into j from LOAN;
   dbms_output.put_line(X1.column_name ||' has '||i||' nulls'||chr(126));
  if  ((i/j)*100) < 40 
  then dbms_output.put_line(X1.column_name) ;
  end if;
end loop;
dbms_output.put_line('End of program');
end;

--Note: This code is written for Oracle database

--Step 2: Fuzzy matching emp_title from loan table
/*SELECT emp_title, AVG(annual_inc) AS Avgsalary, MIN(annual_inc) AS MinSalary, SUM(annual_inc) AS TotalSalary
FROM loan
GROUP BY emp_title;*/


/*FUZZY MATCHING*/

CREATE TABLE loan_finalmatch 
  ( 
     emp_title VARCHAR(20) 
  )

SET ANSI_NULLS ON
GO
 
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure FuzzyMatch_loan (
@MatchScore float = .8 --80% match or greater
) AS

 
TRUNCATE TABLE loan_TempMatch
INSERT INTO loan_TempMatch
SELECT ListA.emp_title AS Firstemp_title
FROM (
    SELECT emp_title, addr_state
    FROM loan
) ListA

JOIN (
    SELECT emp_title, addr_state
    FROM loan
) ListA

LEFT JOIN loan_FinalMatch fin ON loan.emp_title = fin.Secondemp_title
    WHERE fin.Secondemp_title IS NULL
) ListB
ON emp_title.mdq.Similarity(ListA.emp_title, ListB.emp_title, 0, 1.0, @MatchScore) >= @MatchScore
 
AND ListA.emp_title = ListB.emp_title
 
GO
--------------------------------------------------------------------------------------------------------------