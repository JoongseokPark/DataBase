



-- DAY 5 FEB



select date_format(date_add(now(),interval -10000 day),'%Y-%m-%d')
from dual;

select 
	date_format(date_add(now(),interval -1 day),'%Y-%m-%d') < date_format(now(),'%Y-%m-%d')
from dual;

select 
	Round(Rand()) - rand()*20 
from dual;

select 'Yes' from dual
where date_format(date_add(now(),interval -1 day),'%Y-%m-%d') > date_format(now(),'%Y-%m-%d');


select date_add(date_format(date_add(now(),interval -1 day),'%Y-%m-%d'),interval 1 day)
from dual;


select 
	Round(avg(Highest_tmp),1) as AVG_HIGH
from temper t 
group by extract(month from RECORD_AT);





-- DAY 6 FEB





select *
from film
where original_language_id is not null;




-- DAY 13 FEB




select "This is mean temperture" as comment,
		avg(Lowest_tmp)
from temper t 
where extract(month from Record_at) = 2 and extract(day from Record_at) = 13;


select avg(avg_tmp),max(avg_tmp),min(avg_tmp) 
from temper t 
where extract(year from Record_at) < 2005 and extract(month from Record_at) = 2;

select *
from temper t 

insert into temper2 (recordAt,AvgTmp,MinTmp,Maxtmp)
select recordAt,avgTmp,lowestTmp,highestTmp 
from temper t;






-- DAY 14 FEB





select *
from temper t 
limit 10






-- DAY 16 FEB



select max(recordat), Min(recordat)
from temper t 




-- DAY 20 FEB

select *
from temper t 
where id in (1, 366)


-- DAY 26 FEB

select *
from temper t 
where id < 5 or id > 8798;


-- DAY 27 FEB

select extract(year from recordat),avg(AvgTmp)
from temper t 
group by extract(year from recordat);


SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY extract(year from recordat) ORDER BY MaxTmp desc) AS row_num
    FROM temper t 
    WHERE extract(year from recordat) BETWEEN 2000 AND 2024
) AS numbered_rows
WHERE row_num <= 5;
order by MaxTmp desc;

-- DAY 28 FEB !!Last Day!!

select id,recordat,
from temper t 

























