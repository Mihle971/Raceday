-- RaceDay System - Part 1 Database Script


-- Start by creating a Role table
--This table will store the two roles in the system: Organiser and Participan, we use a separate table for roles instead of just typing
-- "Organiser" or "Participant" directly into the User table,
-- because it keeps our data clean and avoids duplication.
 
CREATE TABLE Role (
    RoleId INT IDENTITY(1,1) PRIMARY KEY,   -- here is auto-incrementing unique ID for each role
    RoleName VARCHAR(50) NOT NULL UNIQUE    -- The name of the role, must be unique so that there is no duplicaation
);


--  User table stores every person who registers on RaceDay, whether they
-- are an Organiser or a Participant we use 1 table for both roles instead of two separate tables because the login and
-- registration process is exactly the same for both.

CREATE TABLE [User] (
    UserId INT IDENTITY(1,1) PRIMARY KEY,        -- Each user gets unique id
    FirstName VARCHAR(50) NOT NULL,              -- First name of the user
    LastName VARCHAR(50) NOT NULL,               -- Last name of the user
    Email VARCHAR(100) NOT NULL UNIQUE,          -- For logging in, it must be unique so two users can't share an email
    PasswordHash VARCHAR(255) NOT NULL,          -- We store a HASHED password, never the plain text password
    RoleId INT NOT NULL,                         -- Links to the Role table (Foreign Key)
    DateRegistered DATETIME NOT NULL DEFAULT GETDATE(), -- Automatically rec when the user signed up
    -- This foreign  makes sure RoleId always points to a real row in the Role table
    CONSTRAINT FK_User_Role FOREIGN KEY (RoleId) REFERENCES Role(RoleId)
);


-- Event table stores each event. Every event 
-- is created and owned by one Organiser.

CREATE TABLE Event (
    EventId INT IDENTITY(1,1) PRIMARY KEY,       -- Unique ID for each event
    EventName VARCHAR(100) NOT NULL,             -- The name of the event
    EventDate DATE NOT NULL,                     -- The date the event takes place
    Location VARCHAR(100) NOT NULL,              -- this states where the event is held
    Description VARCHAR(500) NULL,               -- Optional extra info about the event
    OrganiserId INT NOT NULL,                    -- Which User Organiser created this event
    -- This FOREIGN KEY links OrganiserId back to a real User (an Organiser)
    CONSTRAINT FK_Event_User FOREIGN KEY (OrganiserId) REFERENCES [User](UserId)
);


--  Category table
-- Participants don't enter an Event directly - they enter a
-- CATEGORY within an event (e.g. "10km Race" inside the
-- Soweto Marathon event). So every Category belongs to one Event.

CREATE TABLE Category (
    CategoryId INT IDENTITY(1,1) PRIMARY KEY,    -- Unique ID for each category
    EventId INT NOT NULL,                        -- Which event this category belongs to
    CategoryName VARCHAR(50) NOT NULL,           -- e.g. "10km Race", "21km Half Marathon"
    MaxParticipants INT NOT NULL DEFAULT 100,    -- Maximum number of people allowed to enter this category
    -- This FOREIGN KEY links EventId back to a real Event
    CONSTRAINT FK_Category_Event FOREIGN KEY (EventId) REFERENCES Event(EventId)
);


--  Enrolment table
-- This is a "junction" (linking) table. It records that a
-- specific Participant (User) has entered a specific Category.
-- We need this table because ONE participant can enter MANY
-- categories, and ONE category can have MANY participants -
-- a many-to-many relationship, which a relational database
-- can only represent by using a table like this in the middle.
 
CREATE TABLE Enrolment (
    EnrolmentId INT IDENTITY(1,1) PRIMARY KEY,    
    UserId INT NOT NULL,                         
    CategoryId INT NOT NULL,                     
    EnrolmentDate DATETIME NOT NULL DEFAULT GETDATE(), 
    CONSTRAINT FK_Enrolment_User FOREIGN KEY (UserId) REFERENCES [User](UserId),
    CONSTRAINT FK_Enrolment_Category FOREIGN KEY (CategoryId) REFERENCES Category(CategoryId),
    CONSTRAINT UQ_Enrolment_UserCategory UNIQUE (UserId, CategoryId)
);




CREATE TABLE Result (
    ResultId INT IDENTITY(1,1) PRIMARY KEY,      
    EnrolmentId INT NOT NULL UNIQUE,             
    FinishTime TIME NOT NULL,                    
    Position INT NULL,                           -- Their ranking/position in the category (optional, may not always be recorded)
    CapturedDate DATETIME NOT NULL DEFAULT GETDATE(), -- When the Organiser captured this result
    -- This FOREIGN KEY links back to a real Enrolment
    CONSTRAINT FK_Result_Enrolment FOREIGN KEY (EnrolmentId) REFERENCES Enrolment(EnrolmentId)
);



-- SEED DATA
-- This section fills the tables with realistic sample data so
-- we can test and demonstrate that the database actually works.

-- This section we insert the two roles used throughout the system
INSERT INTO Role (RoleName) VALUES ('Organiser'), ('Participant');

 
INSERT INTO [User] (FirstName, LastName, Email, PasswordHash, RoleId) VALUES
('Thabo', 'Rakhale', 'thabo.rakhale@raceday.com', 'hashedpassw', 1),
('Ntsako', 'Sefele', 'ntsakos.sefele@raceday.com', 'hashedpassword', 1),
('Aseza', 'Makanda', 'aseza.makanda@raceday.com', 'hashedpword', 2),
('Leshka', 'Pitso', 'leshka.pitos@raceday.com', 'hashed_pw', 2);

 
INSERT INTO Event (EventName, EventDate, Location, Description, OrganiserId) VALUES
('Sprinting', '2022-11-28', 'eTekwini', 'Usain Bolts competitor at uShaka Marine', 1),
('Marathon', '2026-11-30', 'Mthatha', 'Community road running event through Mthatha.', 1),
('Park Run Charity Walk', '2026-05-16', 'Glenharvie', 'Charity walk supporting local community projects.', 2);


INSERT INTO Category (EventId, CategoryName, MaxParticipants) VALUES
(1, '100m Sprint', 500),
(1, '34km Marathon', 300),
(2, '12km Marathon', 400),
(2, '41.1km Half Marathon', 400),
(3, '10km Walk', 200);


INSERT INTO Enrolment (UserId, CategoryId) VALUES
(3, 1),  -- Aseza enters the 100m Sprint
(4, 3),  -- Ntsako enters the 34km Marathon
(3, 5);  -- Leshka enters the 10km Walk


INSERT INTO Result (EnrolmentId, FinishTime, Position) VALUES
(1, '32:10', 45),
(2, '03:58:22', 12);


-- In this section we verify queries to confirm whether data 
-- was put correctly


SELECT * FROM Role;
SELECT * FROM [User];
SELECT * FROM Event;
SELECT * FROM Category;
SELECT * FROM Enrolment;
SELECT * FROM Result;
