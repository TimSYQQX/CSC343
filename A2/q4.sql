-- Left-right

SET SEARCH_PATH TO parlgov;
drop table if exists q4 cascade;

-- You must not change this table definition.


CREATE TABLE q4(
        countryName VARCHAR(50),
        r0_2 INT,
        r2_4 INT,
        r4_6 INT,
        r6_8 INT,
        r8_10 INT
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS intermediate_step CASCADE;
DROP VIEW IF EXISTS party_position_with_country CASCADE;
-- Define views for your intermediate steps here.
create view party_position_with_country as 
select country_id, left_right
from party join party_position on id = party_id
where left_right is not NULL and country_id is not NULL;
 
create view r0_2_country as
select country_id, count(left_right) as r0_2
from party_position_with_country
where left_right <= 2
group by country_id;

create view r2_4_country as
select country_id, count(left_right) as r2_4
from party_position_with_country
where left_right > 2 and left_right <= 4
group by country_id;

create view r4_6_country as
select country_id, count(left_right) as r4_6
from party_position_with_country
where left_right > 4 and left_right <= 6
group by country_id;

create view r6_8_country as
select country_id, count(left_right) as r6_8
from party_position_with_country
where left_right > 6 and left_right <= 8
group by country_id;

create view r8_10_country as
select country_id, count(left_right) as r8_10
from party_position_with_country
where left_right > 8 and left_right <= 10;
group by country_id;

create view coutry_interval AS
select country_id, r0_2, r2_4, r4_6, r6_8, r8_10
from r0_2_country join r4_6_country join r4_6_country join r6_8_country join r8_10_country

-- the answer to the query 
-- INSERT INTO q4 

