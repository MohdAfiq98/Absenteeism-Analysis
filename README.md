# Absenteeism Analysis

## Table of Content

## Project Overview
This project analyzes Human Resource department specifically interested in monitoring the worker absenteeism record for the whole year. The aim of this project is to provide insight into the worker performance over the year. By analyzing various aspects of the data, we seek to identify trends, make recommendations, and gain a deeper understanding of all worker absenteeism records.

## Data Sources 
The analysis consists of 3 different data sources from [Absent Data](https://absentdata.com/data-analysis/where-to-find-data/). Every information of data as below:
-	Absenteeism_at_work : Consists of 21 columns with 740 unique rows records of all worker informations in the company.
-	Compensation : Shows the compensation rate per hour for each worker.
-	Reasons : Holds the description of every reason based on unique number.
## Tools 
Here shows the tools used for this analysis specifically. We used SQL, MySQL, Microsoft Excel, and Microsoft Power BI. Every elaboration for each tool can be refer below :
-	MySQL : Data Exploration, Data Extraction and Data Analysis.
-	Microsoft Power BI : Data Cleaning and Data Visualization.   

## Data Exploration
In this initial exploration, we want to see whether all the data have relationship in between. To solve this, we planned to JOIN all the table and recheck whether there are missing value in the execution.
```sql
select *
from absenteeism_at_work a
left join compensation c
on a.ID = c.ID
left join reasons r
on a.Reason_for_absence = r.Number;              
```
Result  
Full result can refer in the result folder named “Join_Table_Output.csv”.  

![image](https://github.com/MohdAfiq98/Absenteeism-Analysis/assets/119799325/83f836bd-af13-4a67-a227-d8178663fb88)

 

After execution, result returned with a total of 740 rows shows that all three tables have been joined successfully.         

## Data Extraction and Analysis
In this section, we interested dividing the case into smaller section of scenario which :
-	We are interested in finding the healthiest worker in the Company. This result can be specifically based on their social smoker, social drinker, body mass index reading, and their absenteeism time in hours.      
-	Next, to find the compensation rate for each non-smoker workers per year if the given compensation budget  by the company is $983,221. This result needs to be done with some calculations manually by extracting the total number of non-smoker workers in the company.     
-	We want to compile all tables and create new columns to obtain finalized data that shows the worker absent with reason. This data will be exported to Power BI for further visualization process.             

#### 1. The Healthiest Worker in The Company
The healthiest worker in the company are the worker who is not a social smoker, not a social drinker, body mass index between 18.5 and 25, and also their absenteeism time in hours is less than average.

```sql
select * from absenteeism_at_work
where 
Social_drinker = 0 and 
Social_smoker = 0 and
-- Normal BMI is between 18.5 to 24.9 according to Google. Hence assuming condition BMI below 25 as healthy
Body_mass_index between 18.5 and 25 and
-- Comparing asenteeism time in hour using sub-query to get the average absenteeism time in hours
Absenteeism_time_in_hours < (select avg(Absenteeism_time_in_hours)from absenteeism_at_work);                                                 
```
Result  

Full result can refer the file named “The_Healthiest_Worker_Output.csv” in the Output file.  

![image](https://github.com/MohdAfiq98/Absenteeism-Analysis/assets/119799325/9291525e-0a0a-45d3-81d0-ae3e6478fd00)

 

Result shows that that are 125 workers classified as the healthiest worker in the company.

#### 2. Compensation Rate for Each Non-Smoker Worker Per Year
Let say the company have assigned a budget of $983,221 for the compensation per year. And the working hours per day is 8 hours with 5 days a week. Hence we can calculate that :

8 hours x 5 days = 40hours/week
1 year = 52weeks
1 year = 52 weeks x 40 hours = 2080hours/year

Now we want to find the total non-smoker worker that eligible for the compensation.

```sql
-- find how many non-smoker workers are eligible for the compensation 
select count(*) as "Number of Non Smoker" from absenteeism_at_work
where Social_smoker=0;
```

Result   
![image](https://github.com/MohdAfiq98/Absenteeism-Analysis/assets/119799325/7aa50d56-cd66-4809-919f-d272545d4288)  
 
From the extraction, we found that there are 686 worker eligible for the compensation. Hence to continue the calculation :

Total hours for all non-smoker workers per year :
2080 hours x 686 = 1,426,880 hours

Compensation rate per hour for all 686 worker :
$983,221 / 1,426,880 hours = 0.69/hour

Budget to compensate non-smoker workers in a year :
$0.69 x 2080 hours = $1435.20/year

So, it is clear that the rate of compensation for each non-smoker worker for the ccurrent year will be $0.69/hour.

Furthermore, the total budget need to be spent by the company for the non-smoker worker at the exact year only 0.14% from the current budget.

#### 3. Create A Join Table to Show The Worker Absent With Reason
Here is the extraction process to extract data from table and export it to Power BI for visualization purposes. In this scenario, we implemented below steps :

-	JOIN all table
-	Use CASE statement to create BMI category and Season Names column.
-	Export SQL query to Power BI for visualization.

```sql 
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
```

Result  
Full result can be obtained from the “Output” file named “Work_Absent_With_Reason.csv”.
![image](https://github.com/MohdAfiq98/Absenteeism-Analysis/assets/119799325/be146355-8711-43dd-98c1-8d3684598931)

Result shows that all data have been successfully joined and ready to export to Power BI for visualization.

## Dashboard Overview and Findings
In this section shows the full overview of the dashboard, the description of each section in the dashboard, and findings from the dashboard.

### Full Dashboard View  

![image](https://github.com/MohdAfiq98/Absenteeism-Analysis/assets/119799325/9fc9628e-334e-4b82-bcf8-2ca3a65e8b80)

The dashboard consists of slicer to filter different season names, overall data,
employees and categories, trends and time, and reason and comparisons.

#### 1. Slicer and Overall Data  

![image](https://github.com/MohdAfiq98/Absenteeism-Analysis/assets/119799325/27fff6fa-1eec-4e2a-a9a4-e6ea6186cdee)

In this dashboard section, we designed a slicer so that user can filter the data and visual based on the season names. The overall average of absenteeism time in hours can be seen using the card visual and we used the smart narative to prompt unique statistic findings from the data. 

#### 2. Employees and Categories  

![image](https://github.com/MohdAfiq98/Absenteeism-Analysis/assets/119799325/958020e0-97c8-4007-8762-e200058c8cd2)

The employees and categories section implement the total number employees in the company, how many total absenteeism hours in the company, and categorical data is visualized by using pie chart like the example of worker with education. pets, children, and BMI categories. User can simply click any classification obtained in the section and straight away obtain the data of the selected preferences.

#### 3. Trends and Time  

![image](https://github.com/MohdAfiq98/Absenteeism-Analysis/assets/119799325/52670ede-eaa9-4446-9d1c-a934af2598f7)  

Trends and time responsible for visualized the data into trends line based on specific category. In this secton, we want to observe the average absenteeism time in hours versus the month of absence. Secondly, we are interested in analyzing the trends of average absenteeism time in hours by the day of the week.

#### 4. Reasons and Comparisons  

![image](https://github.com/MohdAfiq98/Absenteeism-Analysis/assets/119799325/3f249c76-54b7-4091-b7b8-31425aa5fa43)  

Reasons and Comparisons section will show the top reasons given for absenteeism in the company and line area graph to show the average transportation expenses by distance from residence to work.

## Findings and Suggestions 
There are some findings obtained by the whole analysis.

1. It shows that most worker are absent during spring season with 391 employees and the top 3 reason for it is because of medical consultation, dental consultation, and unknown reason.
   
2. We realised that the Human Resource Department have huge amount of compensation budget which is $983,221. Since they currently want to reward the non-smokers worker and the total budget was only $1435.20/year, we suggested the Human Resource Department to either use the remainning budget on other ccompensation plan. For example, they can create a reward plan like :
   -  Worker who have least absenteeism for the year.
   -  A campaign towards healthy work lifetsyle.
   -  Provide medical assistant fund for unhealthy worker with proper terms based on their work loads, time travelling to work, and etc.
  
Hence, this will help to improve the absenteeism record among worker. Also gives them motivation to give commitment on their work place as well. Furthermore, create a healthy working environment for the company.

3. Based on the average absenteeism time in hours versus the month of absence trend, we can see the absenteeism starts low in the month of January and starts to rise until April. Then its settle back in May before rises towards maximum in the month of July. As we can see, most of the worker starts to absent during the summer and spring season.










