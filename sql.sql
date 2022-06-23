create table driver (
	id number primary key,
	full_name nvarchar2(30) not null,
    adress  nvarchar2(100) not null,
    phone_number number(11,0) not null,
    levell nvarchar2(10) not null
);
create table route(
	id number primary key,
	distance nvarchar2(100) not null,
    numberstop nvarchar2(100) not null
);
create table assignment(
	driver_id number not null constraint driver_id references driver(id),
	route_id number not null constraint route_id references route(id),
	quantity number not null -- số lượt phân công
);
DROP TABLE assignment;
Drop TABLE route;
DROP TABLE driver;
insert into route values(100,2,5)
insert into assignment(id,driver_id,route_id,quantity) values (2, 10000, 100,9);
insert into driver values(10000,'Lộc','Ninh Bình','6543','Loại A')
select * from route
select * from driver
