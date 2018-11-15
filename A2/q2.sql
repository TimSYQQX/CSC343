SET search_path TO parlgov;
DROP TABLE IF EXISTS q2 cascade;

-- You must not change this table definition.
CREATE TABLE q2 (
    countryName VARCHaR(100),
    partyName VARCHaR(100),
    partyFamily VARCHaR(100),
    wonElections INT,
    mostRecentlyWonElectionId INT,
    mostRecentlyWonElectionYear INT
);
DROP VIEW IF EXISTS country_result cascade;
DROP VIEW IF EXISTS country_party_with_name cascade;
DROP VIEW IF EXISTS party_with_name cascade;


DROP VIEW IF EXISTS result_party cascade;
DROP VIEW IF EXISTS final_party cascade;
DROP VIEW IF EXISTS intermediate_party cascade;

DROP VIEW IF EXISTS better_party cascade;
DROP VIEW IF EXISTS winning_party_wins cascade;
DROP VIEW IF EXISTS winning_party cascade;
DROP VIEW IF EXISTS election_max_vote cascade;
DROP VIEW IF EXISTS average_wins cascade;
DROP VIEW IF EXISTS country_with_family cascade;


DROP VIEW IF EXISTS party_num cascade;



CREATE VIEW election_max_vote
AS SELECT election_id, country_id, max(votes) as max_vote,e_date
FROM  election JOIN  election_result on election_id = election.id
GROUP BY(election_id,country_id,e_date);



CREATE VIEW winning_party
AS SELECT party_id,country_id, election_max_vote.election_id, e_date
FROM  election_max_vote JOIN  election_result on election_max_vote.election_id = election_result.election_id and votes = max_vote;



CREATE VIEW total_wins_country
AS SELECT country_id, count(election_max_vote.election_id) as total_wins
FROM  election_max_vote JOIN  election_result on election_max_vote.election_id = election_result.election_id and votes = max_vote
GROUP BY(country_id);


CREATE VIEW party_num
AS SELECT country_id, count(id) as party_num
FROM party GROUP BY(country_id);


CREATE VIEW average_wins
AS SELECT party_num.country_id, (total_wins::float/party_num::float) as average_wins
FROM total_wins_country JOIN party_num on party_num.country_id = total_wins_country.country_id;
--sub Average Number of elections won by the parties in country

CREATE VIEW winning_party_wins
AS SELECT party_id,country_id, count(election_id) as wins
FROM winning_party
GROUP BY(party_id,country_id);


CREATE VIEW better_party
AS SELECT party_id,country_id, wins
FROM winning_party_wins 
WHERE  wins > 3* (
    SELECT  average_wins
    FROM average_wins
    WHERE average_wins.country_id = winning_party_wins.country_id
);

CREATE VIEW intermediate_party
AS SELECT party_id,country_id,max(e_date) as mostRecentlyWonElectionDate
FROM winning_party
GROUP BY (party_id,country_id)
ORDER BY (party_id);

CREATE VIEW final_party
AS SELECT intermediate_party.party_id,intermediate_party.country_id, mostRecentlyWonElectionDate, election_id
FROM winning_party JOIN intermediate_party on intermediate_party.party_id = winning_party.party_id AND intermediate_party.mostRecentlyWonElectionDate = winning_party.e_date;

CREATE VIEW result_party
AS SELECT better_party.party_id,final_party.country_id, mostRecentlyWonElectionDate,election_id, wins
FROM final_party JOIN better_party on better_party.party_id = final_party.party_id;



CREATE VIEW party_with_name
AS SELECT  name as partyName, party_id, result_party.country_id, wins as wonElections ,election_id as mostRecentlyWonElectionId, extract(year from mostRecentlyWonElectionDate)::INT as mostRecentlyWonElectionYear
FROM  party RIGHT JOIN result_party on party.id = result_party.party_id;



CREATE VIEW country_party_with_name
AS SELECT country.name as countryName, party_id, partyName, country_id,  wonElections, mostRecentlyWonElectionId, mostRecentlyWonElectionYear
FROM country RIGHT JOIN party_with_name ON country.id = party_with_name.country_id;

insert into q2  SELECT countryName, partyName, family as partyFamily, wonElections, mostRecentlyWonElectionId, mostRecentlyWonElectionYear
FROM country_party_with_name LEFT JOIN party_family on country_party_with_name.party_id = party_family.party_id;