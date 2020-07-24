---------------------------------Analysis on the basis of region--------------------------------
select loan_status, count(*) from new_loan1 group by loan_status;
/*
Charged Off	433
Current	198306
Default	1
Fully Paid	8829
In Grace Period	958
Late (16-30 days)	342
Late (31-120 days)	1545            */

select loan_status, count(*) from new_loan1 where region='West' group by loan_status;
/*
Charged Off	146
Current	59339
Fully Paid	2435
In Grace Period	284
Late (16-30 days)	112
Late (31-120 days)	470  */

---------------------------------Salary Segments-------------------------------------
select emp_title, addr_state, annual_inc, ntile(3) over(order by annual_inc) segment
from loan order by annual_inc desc;

------------------------------------fully paid in as per region-----------------------

select count(*) from new_loan1 where region='Midwest' and loan_status='Fully Paid';   ---1471
select count(*) from new_loan1 where region='Northeast' and loan_status='Fully Paid';  ---1726
select count(*) from new_loan1 where region='South' and loan_status='Fully Paid';   ---3099
select count(*) from new_loan1 where region='West' and loan_status='Fully Paid';   ----2533

-------------------------Analysis based on earning levels(high/medium/low)------------------------

select count(*) from new_loan1 where earning_level=1 and region='Midwest';  -12,410
select count(*) from new_loan1 where earning_level=1 and region='Northeast'; --12,309
select count(*) from new_loan1 where earning_level=1 and region='South';   --22,556
select count(*) from new_loan1 where earning_level=1 and region='West';  ---15,511

select count(*) from new_loan1 where earning_level=2 and region='Midwest';  --13,469
select count(*) from new_loan1 where earning_level=2 and region='Northeast'; --15,467
select count(*) from new_loan1 where earning_level=2 and region='South';   --26,066
select count(*) from new_loan1 where earning_level=2 and region='West';  ---18,210

select count(*) from new_loan1 where earning_level=3 and region='Midwest';  --1
select count(*) from new_loan1 where earning_level=3 and region='Northeast'; --12,309
select count(*) from new_loan1 where earning_level=3 and region='South';   --22,556
select count(*) from new_loan1 where earning_level=3 and region='West';  ---20,292

select count(*) from new_loan1 where region='West' and loan_status='Fully Paid' and earning_level=3; ---1006
select count(*) from new_loan1 where region='West' and loan_status='Fully Paid' and earning_level=2; ----869
select count(*) from new_loan1 where region='West' and loan_status='Fully Paid' and earning_level=1;  ---658

select distinct emp_title from new_loan1 where region='West' and loan_status='Fully Paid' and earning_level=3 and tot_coll_amt>(0.5*funded_amnt); 

------------------------------------------------------------------------------------------------------------
-----------------------------------------------RESULTS------------------------------------------------------
------------------------------------------------------------------------------------------------------------

select (
select count(*) from salaries where        ---7136
jobtitle in (
    select distinct emp_title from new_loan1
    where region='West' and
    loan_status in ('Fully Paid','Current') and
    earning_level=3 and tot_coll_amt>(0.5*funded_amnt) and
    totalpay between (select min(annual_inc) from new_loan1 where earning_level=3) and
    (select max(annual_inc) from new_loan1 where earning_level=3)
)  
)
+(
select count(*) from salaries where        ---5316
jobtitle in (
    select distinct emp_title from new_loan1
    where region='West' and
    loan_status in ('Fully Paid','Current') and
    earning_level=2 and tot_coll_amt>(0.5*funded_amnt) and
    totalpay between (select min(annual_inc) from new_loan1 where earning_level=2) and
    (select max(annual_inc) from new_loan1 where earning_level=2)
) 
)
+(
select count(*) from salaries where           --1323
jobtitle in (
    select distinct emp_title from new_loan1
    where region='West' and
    loan_status in ('Fully Paid','Current') and
    earning_level=1 and tot_coll_amt>(0.5*funded_amnt) and
    totalpay between (select min(annual_inc) from new_loan1 where earning_level=1) and
    (select max(annual_inc) from new_loan1 where earning_level=1)
)
)

----ANSWER=13,775 people shortlisted for loan consideration. From this data set, we will pick top 1000 

----------------------------------------------END------------------------------------------------------