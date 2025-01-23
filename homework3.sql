Create Table Match_Result (
Team_1 Varchar(20),
Team_2 Varchar(20),
Result Varchar(20)
)

Insert into Match_Result Values('India', 'Australia','India');
Insert into Match_Result Values('India', 'England','England');
Insert into Match_Result Values('SouthAfrica', 'India','India');
Insert into Match_Result Values('Australia', 'England',NULL);
Insert into Match_Result Values('England', 'SouthAfrica','SouthAfrica');
Insert into Match_Result Values('Australia', 'India','Australia');

select
	Country,
	count(*) as Matches_Played,
	sum(case when Country=Result then 1 else 0 end) as Matches_Won,
	sum(case when Result is NULL then 1 else 0 end) as Matches_Tied,
	count(*)-sum(case when Country=Result then 1 else 0 end)-sum(case when Result is NULL then 1 else 0 end) as Matches_Lost
from (
select Team_1 as Country, Result
from Match_Result
union all 
select Team_2 as Country, Result
from Match_Result) AS aLL_MATCHES
group by country