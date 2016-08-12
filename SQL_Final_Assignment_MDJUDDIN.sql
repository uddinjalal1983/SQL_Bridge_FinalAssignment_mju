--                                       SQL FINAL ASSIGNMENT                                 ---
--                                        MD. JALAL UDDIN



-- 1. create a new database called BuildingEnergy. The SQL script should be 
--    self-contained, such that if it runs again it will re-create the database./

drop schema if exists BuildingEnergy;
create schema BuildingEnergy;
use BuildingEnergy;

-- 2. You should first create two tables, EnergyCategories and EnergyTypes.
-- • Populate the EnergyCategories table with rows for Fossil and Renewable.
-- • Populate the EnergyTypes table with rows for Electricity, Gas, Steam, Fuel Oil, Solar, and Wind.
-- • In the EnergyTypes table, you should indicate that Electricity, Gas, Steam, and Fuel Oil are Fossil 
-- energy sources, while Solar and Wind are renewable energy sources.
-- When inserting data into the tables, be sure to use an INSERT statement and not the table import wizard.

DROP TABLE IF EXISTS EnergyCategories;
DROP TABLE IF EXISTS EnergyTypes;


CREATE TABLE EnergyCategories
(
  cat_id int PRIMARY KEY,
  category varchar(36) NOT NULL
);


CREATE TABLE EnergyTypes
(
  type_id int PRIMARY KEY,
  type varchar(36) NOT NULL,
  cat_id int references EnergyCategories(cat_id)
);

INSERT INTO EnergyCategories (cat_id, category) VALUES (1, 'Fossil');
INSERT INTO EnergyCategories (cat_id, category) VALUES (2, 'Renewable');

select * from EnergyCategories;

INSERT INTO EnergyTypes (type_id, type, cat_id) VALUES (1, 'Electricity', 1);
INSERT INTO EnergyTypes (type_id, type, cat_id) VALUES (2, 'Gas', 1);
INSERT INTO EnergyTypes (type_id, type, cat_id) VALUES (3, 'Steam', 1);
INSERT INTO EnergyTypes (type_id, type, cat_id) VALUES (4, 'Fuel Oil', 1);
INSERT INTO EnergyTypes (type_id, type, cat_id) VALUES (5, 'Solar', 2);
INSERT INTO EnergyTypes (type_id, type, cat_id) VALUES (6, 'Wind', 2);

select * from EnergyTypes;

-- 3. Write a JOIN statement that shows the energy categories and associated energy types that you entered. 

Select c.category as 'EnergyCategory', t.type as 'EnergyType' 
from EnergyTypes t 
Left join EnergyCategories c 
on c.cat_id = t.cat_id
order by  EnergyType, EnergyCategory;

-- 4. You should add a table called Buildings. There should be a many-to-many relationship between Buildings 
-- and EnergyTypes. Here is the information that should be included about buildings in the database:
-- • Empire State Building; Energy Types: Electricity, Gas, Steam
-- • Chrysler Building; Energy Types: Electricity, Steam
-- • Borough of Manhattan Community College; Energy Types: Electricity, Steam, Solar

DROP TABLE IF EXISTS Buildings;

CREATE TABLE Buildings
(
  build_id int PRIMARY KEY,
  build_name varchar(100) NOT NULL
);

INSERT INTO Buildings (Build_id, Build_name) VALUES (1, 'Empire State Building');
INSERT INTO Buildings (Build_id, Build_name) VALUES (2, 'Chrysler Building');
INSERT INTO Buildings (Build_id, Build_name) VALUES (3, 'Borough of Manhattan Community College');

select * from Buildings;

DROP TABLE IF EXISTS BETypes;

CREATE TABLE BETypes
(
  Build_id int references Buildings(Build_id),
  type_id int references EnergyTypes(type_id)
);

INSERT INTO BETypes (Build_id, type_id) VALUES (1, 1);
INSERT INTO BETypes (Build_id, type_id) VALUES (1, 2);
INSERT INTO BETypes (Build_id, type_id) VALUES (1, 3);

INSERT INTO BETypes (Build_id, type_id) VALUES (2, 1);
INSERT INTO BETypes (Build_id, type_id) VALUES (2, 3);

INSERT INTO BETypes (Build_id, type_id) VALUES (3, 1);
INSERT INTO BETypes(Build_id, type_id) VALUES (3, 3);
INSERT INTO BETypes (Build_id, type_id) VALUES (3, 5);

select * from BETypes;

-- 5. Write a JOIN statement that shows the buildings and associated energy types for each building.

Select b.Build_name as 'Building', t.type as 'EnergyType' 
from Buildings b 
Left join BETypes e 
on b.Build_id = e.Build_id
Left join EnergyTypes t 
on e.type_id = t.type_id
order by Building;

-- 6. Please add this information to the BuildingEnergy database, inserting rows as needed in various tables.
-- Building: Bronx Lion House; Energy Types: Geothermal
-- Brooklyn Childrens Museum: Energy Types: Electricity, Geothermal

INSERT INTO Buildings (Build_id, Build_name) VALUES (4, 'Bronx Lion House');
INSERT INTO Buildings (Build_id, Build_name) VALUES (5, 'Brooklyn Childrens Museum');

INSERT INTO EnergyTypes (type_id, type, cat_id) VALUES (7, 'Geothermal', 2);

INSERT INTO BETypes (Build_id, type_id) VALUES (4, 7);
INSERT INTO BETypes (Build_id, type_id) VALUES (5, 1);
INSERT INTO BETypes (Build_id, type_id) VALUES (5, 7);

-- 7. Write a SQL query that displays all of the buildings that use Renewable Energies.

Select d.Build_name as 'Building', b.type as 'Energy Type', a.category as 'Energy Category' from EnergyCategories as a 
Left join EnergyTypes as b on a.cat_id = b.cat_id
Right Join BETypes as c on b.type_id = c.type_id 
Left Join Buildings as d on c.Build_id = d.Build_id
where a.category = 'Renewable';

-- 8. Write a SQL query that shows the frequency with which energy types are used in various buildings.

Select c.type as 'EnergyType', count(*) as 'Frequency' 
from Buildings a 
Left join BETypes b on a.Build_id = b.Build_id
Left join EnergyTypes c on b.type_id = c.type_id
Group By c.type
Order By count(*) Desc, EnergyType desc;

/*  9. Do one (or more if you want!) of the following. 9(c) and 9(d) are both challenging
 you are especially encouraged to work on in a group if you tackle one or both of these exercises!

  a. Create the appropriate foreign key constraints.
  
 Ans: cat_id column is the Foreign key for the EnergyTypes table but primary key for the EnergyCategories table. 
 Here is the example of creating EnergyTypes table with cat_id the foreign key.  

CREATE TABLE EnergyTypes
(
  type_id int PRIMARY KEY,
  type varchar(36) NOT NULL,
  cat_id int FOREIGN KEY references EnergyCategories(cat_id)
);

Similarly, Build_id and the type_id are the foreign key for the BETypes table 
but Build_id and type_id are the primary keys for Buildings table and EnergyTypes table respectively. 
Below is the example of creating BETypes table with foreign keys. 

CREATE TABLE BETypes
(
  Build_id int FOREIGN KEY  references Buildings(Build_id),
  type_id int FOREIGN KEY references EnergyTypes(type_id)
);


    b. Create an entity relationship (ER) diagram for the tables in the database. 
 You can sketch this by hand and include a photo or scan if you wish.
 Ans: I have attached 2 documents named HTML1.JPG and HTML2.JPG 

    c. Suppose you wanted to design a set of HTML pages to manage (add, edit, and delete) the information 
 in the various database tables; create a mockup of the user interface (on paper or using a package like Balsamiq Mockups).
 Ans:  I have attached 1 documents named Entity_Relationship_diagram.JPG


  d. Suppose you want to track changes over time in energy type preferences in New York City buildings. 
 What information should you add to each table? What might a report that shows the trends over time look like?

 Ans: We can create a store procedure for the time we need to track over the period. We will have 
time period such as day/month/year, EnergyType, Frequency as columns and than we run this store procedure 
anytime when we need to see the changes by generating a trend. 

-- sourdes: https://www.visual-paradigm.com/tutorials/erd.jsp
--          https://msdn.microsoft.com/en-us/library/bb933994.aspx
--          http://www.w3schools.com/sql/sql_foreignkey.asp                 */