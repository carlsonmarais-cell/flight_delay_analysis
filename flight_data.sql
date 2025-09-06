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
-- checking for nulls
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

-- aggregation: For each carrier code, total delayed flights, ordered
select carrier, sum(arr_del15) as tot_delays
from airline_delay_cause
group by carrier -- why didnt this work when i didnt put group by
order by tot_delays desc
limit 5

-- add names with join: Same question as above but include carrier_name from carriers lookup table
select c.carrier_name, a.carrier, sum(arr_del15) as tot_delays
from airline_delay_cause a
join carriers c on c.carrier = a.carrier
group by carrier, carrier_name
order by tot_delays desc

-- total delay minutes: for each carrier, sum all delay minute columns into total_delay_minutes
-- using carrier delay this time

-- select distinct(carrier), sum(carrier_delay) as tot_delay_minutes
-- from airline_delay_cause
-- group by carrier, carrier_delay -- this by each row not grouped



-- avg min per delayed flight:

-- Having filter: show only carriers whose total delayed flights > x

-- top 5 carriers by delayed

-- Summary by carrier (with names)
SELECT 
  c.carrier_name, #is this assingign it the alias right here instead of select carrier_name as c
  a.carrier,                                           -- keep code too; useful for joins in BI
  SUM(a.arr_del15) AS total_delayed_flights,
  SUM(a.carrier_delay + a.weather_delay + a.nas_delay 
      + a.security_delay + a.late_aircraft_delay) AS total_delay_minutes,
  SUM(a.carrier_delay + a.weather_delay + a.nas_delay 
      + a.security_delay + a.late_aircraft_delay)
    / NULLIF(SUM(a.arr_del15), 0) AS avg_delay_minutes
FROM airline_delay_cause a #oh here you are creating hte aliases? There is a differenc ebetween carriers c and carriers as c, that smore for creating a column?
JOIN carriers c 
  ON a.carrier = c.carrier
GROUP BY c.carrier_name, a.carrier
ORDER BY total_delayed_flights DESC;

--