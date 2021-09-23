use birdstrikes;

-- assignment 1
drop table if exists employee;
create table employee
(id integer not null,
employee_name varchar(250),
primary key(id));

-- assignment 2, answer = Tennesse
select state from birdstrikes limit 144,1; 

-- assignment 3, answer = 2000-04-18
select distinct flight_date from birdstrikes order by flight_date desc limit 1;

-- assignment 4, answer = 5345
select distinct damage, cost from birdstrikes order by cost desc limit 49,1;

-- assignment 5, answer = Colorado
select distinct state, bird_size from birdstrikes where state is not null and state !='' and bird_size is not null and bird_size != '';

-- assignment 6, answer = 7936
-- to get the flight id, and flight_date
select id,state, flight_date from birdstrikes where state = 'colorado' and weekofyear(flight_date)='52';
-- to get the current date
select now();
-- to get number of days elapsed since the last 52 week flight from Colorado
select datediff(now(),(select flight_date from birdstrikes where state = 'colorado' and weekofyear(flight_date)='52'));