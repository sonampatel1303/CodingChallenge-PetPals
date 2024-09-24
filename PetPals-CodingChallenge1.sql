--creating database Petpals
create database PetPals

--creating tables
create table Pets(
PetID int primary key,
[Name] varchar(30),
Age int,
Breed varchar(35),
[Type] varchar(25),
AvailableForAdoption bit)

create table Shelters(
ShelterID int primary key,
[Name] varchar(50),
[Location] varchar(100))


create table Donations(
DonationID int primary key,
DonorName varchar(40),
DonationType varchar(35),
DonationAmount decimal(10,2),
DonationItem varchar(40),
DonationDate date
)

create table AdoptionEvents(
EventID int primary key,
EventName varchar(50),
EventDate datetime,
[Location] varchar(100))

create table Participants(
ParticipanntID int primary key,
ParticipantName varchar(50),
ParticipantType varchar(30),
EventID int
)
alter table Participants add constraint FK_Participants_AdoptionEvents
foreign key(EventID) references AdoptionEvents(EventID)

--inserting data
insert into Pets values
(1, 'Buddy', 3, 'Golden Retriever', 'Dog', 1),
(2, 'Mini', 2, 'Siamese', 'Cat', 1),
(3, 'Charlie', 5, 'Beagle', 'Dog', 0),
(4, 'Whiskers', 1, 'Persian', 'Cat', 1),
(5, 'Max', 4, 'Labrador', 'Dog', 1),
(6,'Bhalu',7,'German Shepherd','Dog',0)

select * from Pets

insert into Shelters values
(1, 'Care Community', '123 Bank colony,Mumbai'),
(2, 'Home and Pets', '45, Rangmahal square,Bhopal'),
(3, 'Furry Friends Shelter', '74 Palasia,Indore')

select * from Shelters

insert into Donations values
(1, 'Jahnvi Singh', 'Cash', 1000, '0', '2024-01-15'),
(2, 'Mishti Mehra', 'Item', 0, 'Dog Food', '2024-01-20'),
(3, 'Ameesh Mahajan', 'Cash', 50500, '0', '2024-02-05'),
(4, 'Bhupesh Dangi', 'Item', 0, 'Cat Toys', '2024-02-10')

select * from Donations

insert into AdoptionEvents values
(1, 'Adoption Fair', '2024-03-01', 'City Park,Mumbai'),
(2, 'Pet Adoption Day', '2024-04-15', 'TT Nagar,Bhopal'),
(3, 'Fun with Pets', '2024-05-20', 'Diya Garden,Indore')

select * from AdoptionEvents

insert into Participants values
(1, 'Sanjana Gaur', 'Shelter', 1),
(2, 'Deepak Chauahan', 'Shelter', 1),
(3, 'Shamita Gandhi', 'Adopter', 2),
(4, 'Mukesh Patidar', 'Adopter', 3)

select * from Participants


--5. Write an SQL query that retrieves a list of available pets (those marked as available for adoption)
--from the "Pets" table. Include the pet's name, age, breed, and type in the result set. Ensure that
--the query filters out pets that are not available for adoption.
select * from Pets where AvailableForAdoption=1

--6. Write an SQL query that retrieves the names of participants (shelters and adopters) registered
--for a specific adoption event. Use a parameter to specify the event ID. Ensure that the query
--joins the necessary tables to retrieve the participant names and types.
declare @eventid1 int
set @eventid1=1
select p.participantname,p.participanttype,e.eventname
from Participants p join AdoptionEvents e
on p.EventID=e.EventID where p.EventID=@eventid1

--7. Create a stored procedure in SQL that allows a shelter to update its information (name and
--location) in the "Shelters" table. Use parameters to pass the shelter ID and the new information.
--Ensure that the procedure performs the update and handles potential errors, such as an invalid
--shelter ID.

--8. Write an SQL query that calculates and retrieves the total donation amount for each shelter (by
--shelter name) from the "Donations" table. The result should include the shelter name and the
--total donation amount. Ensure that the query handles cases where a shelter has received no
--donations.
alter table Donations add ShelterID int
alter table Donations add constraint FK_Donations_Shelters
foreign key(ShelterID) references Shelters(ShelterID)

select s.[Name],sum(d.DonationAmount) as TotalAmount 
from Shelters s left join Donations d 
on s.ShelterID=d.ShelterID 
group by s.[Name]
select * from Donations

--9. Write an SQL query that retrieves the names of pets from the "Pets" table that do not have an
--owner (i.e., where "OwnerID" is null). Include the pet's name, age, breed, and type in the result
--set.alter table Pets add OwnerID intselect [Name],age,breed,[type] from Pets where OwnerID is null--10. Write an SQL query that retrieves the total donation amount for each month and year (e.g.,
--January 2023) from the "Donations" table. The result should include the month-year and the
--corresponding total donation amount. Ensure that the query handles cases where no donations
--were made in a specific month-year.

select format(DonationDate,'MMMM yyyy') as DonationTime,sum(DonationAmount) as TotalAmount
from Donations group by year(DonationDate),month(DonationDate),format(DonationDate,'MMMM yyyy')
order by year(DonationDate),month(DonationDate)

--11. Retrieve a list of distinct breeds for all pets that are either aged between 1 and 3 years or older
--than 5 years.
select distinct breed ,[Name],age
from Pets where age between 1 and 3 or age>5

--12. Retrieve a list of pets and their respective shelters where the pets are currently available for
--adoption.
alter table pets add ShelterID int
alter table pets add constraint FK_Pets_Shelters
foreign key(ShelterID) references Shelters(ShelterID)

select p.[Name],s.[Name],p.[ShelterID]
from Pets p join Shelters s on p.shelterID=s.ShelterID
where p.AvailableForAdoption=1

--13. Find the total number of participants in events organized by shelters located in specific city.
--Example: City=Chennai
select * from AdoptionEvents

select count(p.eventID) as TotalParticipants,e.EventName,e.eventid
from Participants p join AdoptionEvents e on p.EventID=e.EventID
where p.EventID=(select eventid from AdoptionEvents where [Location]='City Park,Mumbai')
group by e.EventName,e.EventID

--14. Retrieve a list of unique breeds for pets with ages between 1 and 5 years.
select distinct breed,age,[Name] from Pets where
age between 1 and 5

--15. Find the pets that have not been adopted by selecting their information from the 'Pet' table.
select * from Pets where AvailableForAdoption=1

--16. Retrieve the names of all adopted pets along with the adopter's name from the 'Adoption' and
--'User' tables.
select * from Participants
alter table Pets add constraint FK_Pets_Participants
foreign key(OwnerID) references Participants(ParticipanntID)

select p.[Name],pa.ParticipantName,pa.ParticipanntID from Pets p join Participants pa
on p.OwnerID=pa.ParticipanntID 

--17. Retrieve a list of all shelters along with the count of pets currently available for adoption in each
--shelter.
select s.[Name],s.shelterID ,count(p.shelterID) as TotalPets
from Shelters s left join Pets p on s.ShelterID=p.ShelterID
where p.AvailableForAdoption=1
group by s.[Name],s.shelterID


--18. Find pairs of pets from the same shelter that have the same breed.
select p.[Name],p1.[Name],p.breed,p.shelterID
from Pets p join Pets p1
on p.shelterID=p1.shelterID 
where p.Breed=p1.breed and p.[Name]<p1.[Name]
select * from pets

--19. List all possible combinations of shelters and adoption events.
select s.*,e.* from shelters s cross join AdoptionEvents e

--20. Determine the shelter that has the highest number of adopted pets
select top 1 count(p.availableforadoption) as Adopted,s.shelterid,s.[Name]
from pets p join Shelters s on p.shelterid=s.ShelterID where p.AvailableForAdoption=1
group by s.shelterid,s.Name
order by Adopted desc