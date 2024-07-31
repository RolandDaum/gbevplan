# GBE VPlan

![Project Banner](https://github.com/RolandDaum/gbevplan/blob/main/docs/gbevplan_banner_borderradius.png?raw=true)

A mobile app made with Flutter and Firebase to display your timetable and get in app access to the school Substitution plan. (GBE only)

## Table of Contents


- [Table of Contents](#table-of-contents)
- [Introduction / Storyline](#introduction--storyline)
- [Features](#features)
- [Installation](#installation)
- [Under the hood](#under-the-hood)
- [Current state \& Future plans](#current-state--future-plans)


## Introduction / Storyline

###### Gymnasium Bad Essen - Vertretungsplan

GBE VPlan was an idea me and a friend of mine had a couple of years ago. The plan was simple. Take the current boring substitution plan, web scraping all the data out of it and display it in a more convenient modern looking way. Unfortunately we never really started to work on this project.

Now, almost 2 years later, I discovered Flutter, an awesome Crossplattform development Framework, primary for building mobile apps. Soon I started to try it out and build my [first prototype](/RolandDaum/gbevplan/tree/OUTDATED-w11design) of the app in a Windows 11 styled App design. Due to school I stopped working on the project and complete restarted last summer holiday, now using the already existing Google Material 3 Widget Component library. After a few weeks of continues development I am at a state which is quite far from the original Idea but still a useful tool for a student and with potential an infinite long list of features that could be added to it.

## Features

- Easy access to your daily timetable with a clean layout and clearly recognizable structure

- Automatic weekday selection

- Automatic selection of the current lesson

- There isn't more than you need

- Easy in app access to the original schools Substitution plan

- Get notified as soon as a new Substitution plan has been released (max. 1h later)

- Edit your lessons quickly and never think about when you have which subject

- Change the overall app theme colour just the way you like

- Possible thanks to Material's ThemeData Generation via seed colour

- Switch between dark/light/system mode with the click of a button

## Installation

If you want to take advantage of the app or just want to try it out, head over to the GitHub release section and download and install the [latest version](https://github.com/RolandDaum/gbevplan/releases/latest).

From there on the app should guide you just fine through the setup process, and you shouldn't have any problem with it, if you're going to the GBE.

Unfortunately due to apples requirement to use a Mac with any kind of m1, m2, m3 CPU to compile and deploy IOS apps, I'm not able to generate an IOS build. Therefore, you will only be able to use the app on Android for the time being.

## Under the hood

The entire app is written in dart with the use of the Flutter Framework. All the non client sided storage and fetching the UUIDs of the original Substitution plan is done in Firebase.

Firebase is a Google Dev-Kit for mobile and web Applications. In my case I used Firestore to store the different Timetables for each grade and the real-time database for quick repetitive, but necessary data access. Firebase also allows you to send push notification which I took use of to notify the user when a new substitution plan has been released. The fourth and final tool from Firebase I used are the cloud functions. You're basically writing a JS or TS script and let it run on different triggers, e.g. on schedule or on change in the Database.

## Current state & Future plans

Right now the app is just working fine for all grades which timetable is based on a course basis. The functionality of display lower grades that have fixed school classes with shared lessons is not implemented. In addition, of missing data I'm also only capable to provide service for my own grade and no one else (sorry).

Also, the original idea of calculating your timetable with the changes of the Substitution plan has not been implemented due to lag of time. No doubt it would be awesome to have this, but it is quite some work to fetch and process the data from the HTML table correct, so that no wrong or misleading information about lessons or the timetable are displayed.

###### Features to be implemented

- More settings

  - Notifications

    - en/disable

    - more detailed notifications

  - Option to use System Theme as the seed colour for the app

- Substitution plan calculation

  - Proper webscraing and processing of the HTML table (Firebase Cloud Functions)

- Stats page

  - See how many lessons are left on the day, week, month, school year

    - Something like a school streak (How many days in a row did I go to school without skipping any course)

  - Stats of the most visited courses (only makes sense in higher grades)

- Admin app

  - Quick Access to change stuff in the Firebase database or real-time db

    - e.g. there is a wrong room entry for a lesson