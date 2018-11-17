-- Participate

SET SEARCH_PATH TO parlgov;
drop table if exists q3 cascade;

-- You must not change this table definition.

create table q3(
        countryName varchar(50),
        year int,
        participationRatio real
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;
DROP VIEW IF EXISTS participationRatio_in_period CASCADE;
DROP VIEW IF EXISTS full_countries CASCADE;
DROP VIEW IF EXISTS unfit_countries CASCADE;


-- Define views for your intermediate steps here.
create VIEW participationRatio_in_period
as select country_id, extract(year from e_date) as year, avg(votes_valid::float / electorate::float) as participationRatio
from election
where extract(year from e_date) >= 2001 and extract(year from e_date) <= 2016 
group by(country_id, year);

create VIEW all_countries as
select distinct country_id
from participationRatio_in_period;

create VIEW unfit_countries as 
select distinct p1.country_id, p1.year, p1.participationRatio, p2.country_id as country_id2, p2.year as year2, p2.participationRatio as p
from participationRatio_in_period p1 cross join participationRatio_in_period p2
where p1.country_id = p2.country_id and p1.year > p2.year and p1.participationRatio < p2.participationRatio;

-- create VIEW 
-- the answer to the query 
-- insert into q3 

