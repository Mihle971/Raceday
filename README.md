RaceDay — Part 1: System Planning and Database

RaceDay is a full-stack, web-based event management system built for the South African road running, walking, and cycling community. This repository (Part 1) contains the planning phase of the project: the database design (ERD), the API endpoint plan, and the SQL script that creates and seeds the database. No application code is written in this part — that happens in Part 2.

System Description

Event Organisers can create and manage events, set up categories within those events (e.g. a 10km and 21km category under one running event), capture participant results, and view who has enrolled. Participants can create an account, browse upcoming events, enter an event by selecting a category, view their own enrolments, and track their personal results over time.

User Roles

Organiser

Create, edit, and delete events
Manage event categories
Capture participant results
View all enrolments for their events

Participant

Create an account
Browse events
Enter an event by selecting a category
View their own enrolments
Track their personal results
Setup Instructions

To run the database script yourself:

Install SQL Server Management Studio (SSMS) and have a SQL Server instance running (local or remote).
Open SSMS and connect to your instance.
Select the new database (USE RaceDayDB;), then open docs/RaceDay_Schema.sql in SSMS.
Run the script. It will:
Create all six tables (Role, User, Event, Category, Enrolment, Result) in dependency order
Insert sample seed data (2 Organisers, 2 Participants, 3 Events, categories, enrolments, and results)
Run verification SELECT queries so you can see the data
The script runs cleanly on a fresh instance — no manual setup steps beyond creating the empty database.
