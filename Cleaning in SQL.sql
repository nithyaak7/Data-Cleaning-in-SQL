use data_excel;
show tables;
-- Data Cleaning in SQL

-- Look at the data
select * from housingdata;

-- Understand the data formats
describe housingdata;

-- Sale date  is text, need to convert the datatypes
select saledate, str_to_date(saledate,'%M %d, %Y') from housingdata;
-- add a column dateofsale to the table to store the value in Date format
alter table housingdata add column dateofsale date;
update housingdata set dateofsale = str_to_date(saledate,'%M %d, %Y');

-- Looking at the address field

select * from housingdata order by parcelid;

select count(*) from housingdata where propertyaddress=' ' or propertyaddress is null;
-- 18 property address needs to be updated	
/*
-- create a temp table with property address as blank
create temporary table new_tbl select * from housingdata where propertyaddress= ' ';

select count(*) from new_tbl;
select h.propertyaddress from new_tbl n left join housingdata h on h.parcelid = n.parcelid and h.uniqueid <>n.uniqueid where n.propertyaddress ='' group by h.propertyaddress;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               n.uniqueid  where h.propertyaddress <> ' ' group by parcelid;
*/
select h.parcelid,n.parcelid from housingdata h inner join housingdata n on h.parcelid=n.parcelid and h.uniqueid<>n.uniqueid where h.propertyaddress=''; -- group by h.parcelid;
select ifnull(h.propertyaddress,n.propertyaddress) from housingdata h join housingdata n on h.parcelid=n.parcelid and h.uniqueid<>n.uniqueid  where n.propertyaddress = '';

update housingdata h 
join housingdata n on h.parcelid=n.parcelid and h.uniqueid<>n.uniqueid 
set h.propertyaddress =  ifnull(h.propertyaddress,n.propertyaddress) 
where n.propertyaddress = '';

-- check for empty property address
select count(*) from housingdata where propertyaddress=' ' or propertyaddress is null;
-- none is empty

-- looking at the soldasvacant fields
select distinct soldasvacant from housingdata;
 
 -- Results are both N and No and Y and Yes. Change that to No and Yes
 
 update housingdata
 set soldasvacant = 'Yes' 
 where soldasvacant = 'Y';
 
 update housingdata
 set soldasvacant = 'No' 
 where soldasvacant = 'N';
 
-- check to see the changes are made
select distinct soldasvacant from housingdata;

-- look at the landuse types
select distinct landuse from housingdata order by landuse asc;
-- vacant res land and vacant residential land are similar, so can be grouped into a single type

update housingdata
set landuse = 'VACANT RESIDENTIAL LAND'
where landuse = 'vacant residential land';

-- 
select yearbuilt,saleprice from housingdata order by yearbuilt desc limit 10;

-- tax district looks clean
select distinct taxdistrict from housingdata; 