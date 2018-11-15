SET search_path TO parlgov;
DROP TABLE IF EXISTS q1;

-- You must not change this table definition.
CREATE TABLE q1 (
    year INT,
	countryName VARCHAR(50),
	partyName VARCHAR(100), 
	voteRange VARCHAR(20)
	
);

DROP VIEW IF EXISTS country_result;
DROP VIEW IF EXISTS description;
DROP VIEW IF EXISTS final_election_result;
DROP VIEW IF EXISTS election_results;


CREATE VIEW country_result 
AS SELECT country.name as countryName, party.id as party_id, party.name as partyName
FROM country JOIN party ON country.id = party.country_id;



CREATE VIEW election_results 
AS SELECT extract(year from e_date) as election_year, votes_valid, votes, party_id, election.id as election_id, (votes::float/votes_valid::float)*100.0 as election_percentage
FROM election JOIN election_result ON election_id = election.id
WHERE e_date >= '1996-01-01' AND e_date <='2016-12-31';




CREATE VIEW final_election_result 
AS SELECT election_year, party_id, avg(election_percentage) as avg_percentage
FROM election_results
GROUP BY(election_year, party_id);

-- SELECT * FROM election_results as z1, election_results as z2
-- WHERE z1.votes IS NOT NULL AND  z2.votes IS NULL AND z1.party_id = z2.party_id;



CREATE VIEW description
AS SELECT party_id, election_year,avg_percentage,

    CASE WHEN  avg_percentage <= 5 AND avg_percentage > 0 THEN '(0,5]'
        WHEN  avg_percentage <= 10 AND avg_percentage > 5 THEN '(5,10]'
        WHEN avg_percentage <= 20 AND avg_percentage > 10 THEN  '(10,20]'
        WHEN  avg_percentage <= 30 AND avg_percentage > 20 THEN '(20,30]'
        WHEN  avg_percentage <= 40 AND avg_percentage > 30 THEN '(30,40]'
        WHEN  avg_percentage >= 40 THEN '(40,100]'
    END 
FROM final_election_result;

SELECT  election_year as year, countryName, partyName, description.case as voteRange 
FROM description NATURAL JOIN country_result;

-- CREATE VIEW result AS
--     SELECT country_result.name as country_name, election_result.name as party_name
--     FROM coutry_result JOIN election_result ON country_name.party_id = election_result.party_id


