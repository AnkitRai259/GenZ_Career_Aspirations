-- Create table 
Create table GenZ_Dataset
(
Time time,
Country	 varchar(50),
Pin_Code  varchar(10),	
Gender	   varchar(10),
Career_Influencing_Factors	varchar(100),
Interest_in_Abroad_Higher_Education  varchar(100),	
Likeliness_to_work_3_year_for_employer varchar(100),
Willingness_to_work_in_an_Undefined_Mission_Company varchar(10),
Likelihood_to_work_for_Company_mission_action_dismatch	varchar(10),
Likely_to_work_for_No_Social_Impact_Company varchar(10),
Preferred_working_environment	varchar(100),
Preffered_Employer_Type_to_work varchar(100),
Preferred_learning_environment_to_work	varchar(100),
Aspirational_job_Preference_1 varchar(100),
Aspirational_job_Preference_2 varchar(100),
Aspirational_job_Preference_3 varchar(100),
Aspirational_job_Preference_4 varchar(100),
Type_of_Manager	varchar(50),
Working_Setup varchar(100),
Likely_to_work_in_Company_Laid_Off_Employees varchar(20),
likeliness_to_work_7_years_for_1_Employer varchar(50),
Email varchar(100),
Expected_Salary_during_initial_3_years	varchar(50),
Expected_Salary_after_5_years varchar(50),
Expected_Salary_as_Fresher	varchar(50),
Kind_of_company	varchar(100),
Likely_to_work_under_Abusive_Manager varchar(10),
Working_Hours	varchar(20),
Frequency_of_full_week_break_to_maintain_work_life_balance	varchar(100),
Factors_influencing_Happiness_and_Productivity varchar(100),
Frustating_Factors_ varchar(100)
);


-- Altering table 
ALTER TABLE GenZ_Dataset
ALTER COLUMN Time TYPE DATE
USING TO_DATE(Time::TEXT, 'DD-MM-YYYY');

SET datestyle = 'DMY';


-- Loading data into tables
copy GenZ_Dataset(Time,Country,Pin_Code,Gender,Career_Influencing_Factors,Interest_in_Abroad_Higher_Education,
Likeliness_to_work_3_year_for_employer,Willingness_to_work_in_an_Undefined_Mission_Company,Likelihood_to_work_for_Company_mission_action_dismatch,
Likely_to_work_for_No_Social_Impact_Company,Preferred_working_environment,Preffered_Employer_Type_to_work,Preferred_learning_environment_to_work,
Aspirational_job_Preference_1,Aspirational_job_Preference_2,Aspirational_job_Preference_3,Aspirational_job_Preference_4,Type_of_Manager,
Working_Setup,Likely_to_work_in_Company_Laid_Off_Employees,likeliness_to_work_7_years_for_1_Employer,Email,
Expected_Salary_during_initial_3_years,Expected_Salary_after_5_years,Expected_Salary_as_Fresher,Kind_of_company,
Likely_to_work_under_Abusive_Manager,Working_Hours,Frequency_of_full_week_break_to_maintain_work_life_balance,	
Factors_influencing_Happiness_and_Productivity,Frustating_Factors_ )
from 'C:\sql queries assignment.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');


--Updating tables
update GenZ_Dataset
Set Likely_to_work_for_No_Social_Impact_Company = CASE
    WHEN Likely_to_work_for_No_Social_Impact_Company = 'Yes' THEN 'No'
    WHEN Likely_to_work_for_No_Social_Impact_Company= 'No' THEN 'Yes'
    ELSE NULL
END;
ALTER TABLE GenZ_Dataset
RENAME COLUMN Likely_to_work_for_No_Social_Impact_Company TO Likely_to_work_for_Social_Impact_Company;

Select * from GenZ_Dataset;

--1. What is the gender distribution of respondents from India?
Select Gender, Count(Gender)
from GenZ_Dataset
Where Country='India'
Group by Gender
Order by Count(Gender) DESC;

--2. What percentage of respondents from India are interested in education abroad and sponsorship?
Select Interest_in_Abroad_Higher_Education, count(*),( count(*)*100/ (select count(*) from GenZ_Dataset)) as Percentage
from GenZ_Dataset
where country = 'India' and Interest_in_Abroad_Higher_Education in ('Yes','Need Sponserships')
group by Interest_in_Abroad_Higher_Education;

--3. What are the 6 top influences on career aspirations for respondents in India?
Select Career_Influencing_Factors,Count(Career_Influencing_Factors)
From GenZ_Dataset
where Country='India'
Group by Career_Influencing_Factors
ORDER BY COUNT(Career_Influencing_Factors) DESC
LIMIT 6;

--4.How do career aspiration influences vary by gender in India?
 SELECT Career_Influencing_Factors,Gender,Count(*)
 FROM GenZ_Dataset
 Where Country='India'
 Group by Gender,Career_Influencing_Factors
 Order by Career_Influencing_Factors,Count(*) DESC;

 --5.What percentage of respondents are willing to work for a company for at least 3 years?
 SELECT Likeliness_to_work_3_year_for_employer,( COUNT(*) * 100/(SELECT COUNT(*) FROM GenZ_Dataset)) as percentage
 from GenZ_Dataset
 where Country ='India' AND Likeliness_to_work_3_year_for_employer IN ('Yes','Try for Right Company')
 Group by Likeliness_to_work_3_year_for_employer
 Order by percentage desc;

 --6.How many respondents prefer to work for socially impactful companies?
 SELECT Likely_to_work_for_Social_Impact_Company, COUNT(*)
 FROM GenZ_Dataset
 where Country ='India' and Likely_to_work_for_Social_Impact_Company='Yes'
 group by Likely_to_work_for_Social_Impact_Company;

					       

 --7.How does the preference for socially impactful companies vary by gender?
 SELECT Gender,Likely_to_work_for_Social_Impact_Company, Count(*)
  FROM GenZ_Dataset
 where Country ='India' and Likely_to_work_for_Social_Impact_Company is not null
 group by Gender,Likely_to_work_for_Social_Impact_Company
 Order by Gender ,Count(*) Desc;

 --8. What is the distribution of minimum expected salary in the first three years among respondents?
 SELECT Expected_Salary_during_initial_3_years, COUNT(*)
 FROM GenZ_Dataset
 WHERE Country='India'
 Group by Expected_Salary_during_initial_3_years
 Order by Count(*) desc;

 --9.  What is the expected minimum monthly salary in hand?
 Select Expected_Salary_as_Fresher, count(*)
 from GenZ_Dataset
 where Country='India' and Expected_Salary_as_Fresher is not null
 Group by Expected_Salary_as_Fresher
 Order by Count(*) desc;

 --10. What percentage of respondents prefer remote working?
 SELECT Preferred_working_environment, (Count(*)*100/( select count(*) from GenZ_Dataset))as percentage
 from GenZ_Dataset
 WHERE Country='India' and Preferred_working_environment='Remote'
 Group by Preferred_working_environment;

 --11.  What is the preferred number of daily work hours?
SELECT Working_Hours, ( COUNT(*)*100/ (SELECT COUNT(*) FROM GenZ_Dataset)) as percentage
from GenZ_Dataset
where Country = 'India'
Group by Working_Hours
ORDER BY COUNT(*) DESC;

--12. What are the common work frustrations among respondents?
SELECT Frustating_Factors_, COUNT(*)
FROM GenZ_Dataset
WHERE Country='India' and Frustating_Factors_ <>'N/A'
Group by Frustating_Factors_
Order by Count(*) desc;

--13. How does the need for work-life balance interventions vary by gender?
SELECT Gender,Frequency_of_full_week_break_to_maintain_work_life_balance,count(*)
from GenZ_Dataset
where Country = 'India' AND Frequency_of_full_week_break_to_maintain_work_life_balance IS NOT NULL
group by Gender,Frequency_of_full_week_break_to_maintain_work_life_balance
ORDER BY Gender, COUNT(*) DESC;

--14. How many respondents are willing to work under an abusive manager?
SELECT Likely_to_work_under_Abusive_Manager, COUNT(*)
FROM GenZ_Dataset
WHERE Country='India' and Likely_to_work_under_Abusive_Manager='Yes'
group by Likely_to_work_under_Abusive_Manager;

--15. What is the distribution of minimum expected salary after five years?
SELECT Expected_Salary_after_5_years, COUNT(*)
FROM GenZ_Dataset
WHERE Country='India'
Group by Expected_Salary_after_5_years
order by Count(*) desc;

--16. What are the remote working preferences by gender?
SELECT Preferred_working_environment,Gender, COUNT(*)
FROM GenZ_Dataset
where Country='India' 
Group by Gender,Preferred_working_environment
ORDER BY Preferred_working_environment,count(*) desc;

--17. What are the top work frustrations for each gender?
SELECT Frustating_Factors_,Gender, Count(*)
from GenZ_Dataset
where Country='India' AND Frustating_Factors_ <>'N/A'
Group by Gender,Frustating_Factors_
Order by Frustating_Factors_,Count(*)desc;

--18. What factors boost work happiness and productivity for respondents?
SELECT Factors_influencing_Happiness_and_Productivity,COUNT(*)
FROM GenZ_Dataset
where Country='India' and Factors_influencing_Happiness_and_Productivity<>'N/A'
Group by Factors_influencing_Happiness_and_Productivity
Order by Count(*) desc;

--19. What percentage of respondents need sponsorship for education abroad?
SELECT Interest_in_Abroad_Higher_Education, (COUNT(*)*100/ (SELECT COUNT(*) FROM GenZ_Dataset))as percentage
FROM GenZ_Dataset 
WHERE Country='India' AND Interest_in_Abroad_Higher_Education ='Need Sponserships'
GROUP BY Interest_in_Abroad_Higher_Education ;

