Drop schema if exists educ_exp;
create schema Educ_Exp;
use educ_exp;

drop table if exists Educ_exp;
create table educ_exp
(id int not null auto_increment,
country varchar(50),
institute_type varchar(50),
exp_type varchar(25),
yr_1995 double,
yr_2000 double,
yr_2005 double,
yr_2009	double,
yr_2010	double,
yr_2011 double,
primary key(id));

Load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Term_2\\education_expenditure.csv'
Into Table educ_exp
Fields Terminated By ','
Optionally Enclosed By '"'
Lines Terminated By '\r'
Ignore 1 Lines
(country,institute_type,exp_type,@p_yr_1995,@p_yr_2000,@p_yr_2005,@p_yr_2009,@p_yr_2010,@p_yr_2011)
Set
yr_1995 = nullif(@p_yr_1995, ''),
yr_2000 = nullif(@p_yr_2000, ''),
yr_2005 = nullif(@p_yr_2005, ''),
yr_2009 = nullif(@p_yr_2009, ''),
yr_2010 = nullif(@p_yr_2010, ''),
yr_2011 = nullif(@p_yr_2011, '');

drop table if exists Uni_rank;
Create table Uni_rank
(id int not null auto_increment,
world_rank varchar(25),
university_name varchar(100),
country_name varchar(50),
teaching_score double,
int_score double,
research_score double,
citations_score double,
income_score double,
total_score double,
num_students int,
stud_staff_ratio double,
int_students varchar(5),
female_male_ratio varchar(25),
rank_year year,
primary key(id));

Load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Term_2\\times_Data.csv'
Into Table Uni_rank
Fields Terminated By ','
Optionally Enclosed By '"'
Lines Terminated By '\r\n'
Ignore 1 Lines
(world_rank,university_name,country_name,@p_teaching_score,@p_int_score,@p_research_score,@p_citations_score,@p_income_score,@p_total_score,@p_num_students,@p_stud_staff_ratio,@p_int_students,@p_female_male_ratio,rank_year)
Set
num_students = nullif(@p_num_students, ''),
stud_staff_ratio = nullif(@p_stud_staff_ratio, ''),
int_students = nullif(@p_int_students, ''),
female_male_ratio = nullif(@p_female_male_ratio, ''),
teaching_score = nullif(@p_teaching_score, '-'),
int_score = nullif(@p_int_score, '-'),
research_score = nullif(@p_research_score, '-'),
citations_score = nullif(@p_citations_score, '-'),
income_score = nullif(@p_income_score, '-'),
total_score = nullif(@p_total_score, '-');

Drop table if exists Educ_DW;
Create table Educ_DW as 
select country,institute_type,exp_type,yr_1995,yr_2000,yr_2005,yr_2009,yr_2010,yr_2011,

world_rank,university_name,teaching_score,int_score,research_score,citations_score,income_score,
total_score,num_students,stud_staff_ratio,int_students,female_male_ratio,rank_year

from educ_exp
left join uni_rank
on educ_exp.country = uni_rank.country_name;

