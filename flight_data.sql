-- show databases;
-- use airline_data;
-- select database();

CREATE DATABASE airline_data;
-- Practice and EDA
-- building tables
USE airline_data;
SHOW TABLES;

-- csv view
SELECT *
FROM airline_delay_cause

-- Carrier table to bring in full name during visualization
CREATE TABLE carriers AS
SELECT DISTINCT carrier, carrier_name
FROM airline_delay_cause;

-- 20 carriers in df
select count(*)
from carriers

-- airport table lookup
create table airports as 
select distinct airport, airport_name
from airline_delay_cause;

-- 357 airports
select count(*)
from airports;

-- Practice SQL with ?s from ChatGPT
-- checking for col nulls --> no nulls
select arr_del15
from airline_delay_cause a
where a.arr_del15 is null

-- List every carrier code and name (sorted by code)
select c.carrier, c.carrier_name
from carriers c
order by carrier  

-- count rows:  How many rows are in airline_delay_cause
select count(*)
from airline_delay_cause  -- 1,868 rows

-- distinct count: how many distinct carriers appear in airline_delay_cause
select count(distinct carrier) as unique_carriers
from airline_delay_cause -- 20 unique carriers

-- aggregation: For each carrier code, total delayed flights, order it
select carrier, sum(arr_del15) as tot_delays
from airline_delay_cause
group by carrier 
order by tot_delays desc
limit 5

-- add names with join: Same question as above but include carrier_name from carriers lookup table
select c.carrier_name, a.carrier, sum(arr_del15) as tot_delays
from airline_delay_cause a
join carriers c on c.carrier = a.carrier
group by carrier, carrier_name
order by tot_delays desc

-- total delay minutes: for each carrier 
-- using carrier delay this time
select carrier, sum(carrier_delay) as delay_by_carrier #whydont i need distinct carrier here? is it because of the group by at the end
from airline_delay_cause a
group by carrier
order by delay_by_carrier desc
#how would this be dif if i got from carriers taable and joined. what advanatge could i get from that or is there none

-- avg min per delayed flight by carrier:
select c.carrier, sum(a.carrier_delay)/sum(a.carrier_ct) as avg_min
from airline_delay_cause a
join carriers c on c.carrier = a.carrier
where a.carrier in ('UA', 'DL', 'AA') -- where in: in analysis, make a top 5 carriers table instead of this
group by c.carrier
order by avg_min desc

-- Find of all delays, what % is caused by the carrier
select carrier, sum(arr_delay + carrier_delay + weather_delay + nas_delay + security_delay + late_aircraft_delay) as total_delay_min,
round(100* sum(carrier_delay)/sum(arr_delay + carrier_delay + weather_delay + nas_delay + security_delay + late_aircraft_delay),1) as pct_carrier_min
from airline_delay_cause
group by carrier
order by pct_carrier_min desc

-- Try above one with subquery instead of another col with repeated aggregate

-- Having filter: show only carriers whose total delayed flights > x

--