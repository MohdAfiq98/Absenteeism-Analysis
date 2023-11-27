-- review all table
select * from absenteeism_at_work;
select * from compensation;
select * from reasons;

-- join all the table
select *
from absenteeism_at_work a
left join compensation c
on a.ID = c.ID
left join reasons r
on a.Reason_for_absence = r.Number;

-- Find the healthiest 
select * from absenteeism_at_work
where 
Social_drinker = 0 and 
Social_smoker = 0 and
-- Normal BMI is between 18.5 to 24.9 according to Google. Hence assuming condition BMI below 25 as healthy
Body_mass_index < 25 and 
-- Comparing asenteeism time in hour using sub-query to get the average absenteeism time in hours
Absenteeism_time_in_hours < (select avg(Absenteeism_time_in_hours)from absenteeism_at_work) ;
-- ______________________________________________
-- 	Compensation rate increase for non smokers
-- ______________________________________________

-- Budget is $983,221/year
-- 8hrs work per day times 5 day = 40hrs work in a week
-- a year have 52weeks. Hence 40hrs X 52weeks = 2080hrs

-- find how many non-smoker workers are eligible for the compensation 
select count(*) as "Number of Non Smoker" from absenteeism_at_work
where Social_smoker=0;

-- Hence total hours of working for all non smoker workers for 1 year is 2080hrs x 686 = 1,426,880hrs
-- Each worker are eligible to get compensation amount by $983,221 / 1,426,880hrs = $0.69/hr
-- Hence budget to compensate nonsmoker workers in a year will be $0.69 x 2080hrs = $1435.20/year

-- ______________________________________________
--   		Worker Absent with Reason
-- ______________________________________________

select distinct(a.ID), r.Reason, Month_of_absence, Body_mass_index,age, Day_of_the_week, 
case	when Body_mass_index < 18.5 then "Underweight"
		when Body_mass_index  between 18.5 and 25 then "Healthy Weight"
		when Body_mass_index  between 25 and 30 then "Overweight"
        when Body_mass_index > 18.5 then "Obese"
        else "Unkown" end as BMI_Category,
case	when Month_of_absence in (12,1,2) then "Winter"
		when Month_of_absence in (3,4,5) then "Spring"
        when Month_of_absence in (6,7,8) then "Summer"
        when Month_of_absence in (9,10,11) then "Autumn"
        else "Unkown" end as "Season_Names",
Seasons, Disciplinary_failure, Transportation_expense, Distance_from_Residence_to_Work,
Service_time, Hit_target,Disciplinary_failure,Education,Son,Social_drinker,
Social_smoker, pet, Weight, Height, Absenteeism_time_in_hours
from absenteeism_at_work a 
left join compensation c  
on a.ID and c.ID 
left join reasons r 
on a.Reason_for_absence = r.Number;