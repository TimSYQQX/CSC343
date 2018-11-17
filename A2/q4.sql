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
select country_id, count(left_right)
from party_position_with_country
where left_right <= 2
group by country_id;

create view r2_4_country as 
select country_id, count(left_right)
-- the answer to the query 
-- INSERT INTO q4 

