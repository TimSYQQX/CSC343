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

-- Define views for your intermediate steps here.

CREATE VIEW country_result 
AS SELECT country.name as countryName, party.id as party_id, party.name as partyName
FROM country JOIN party ON country.id = party.country_id;



CREATE VIEW election_results 
AS SELECT extract(year from e_date) as election_year, votes_valid, votes, party_id, election.id as election_id, (votes::float/votes_valid::float)*100.0 as election_percentage
FROM election JOIN election_result ON election_id = election.id
WHERE e_date >= '2001-01-01' AND e_date <='2016-12-31';

CREATE VIEW average_participation
-- the answer to the query 
insert into q3 

