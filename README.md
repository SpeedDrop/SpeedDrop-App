Original App Design Project - README Template
===

# SpeedDrop App

## Table of Contents

1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)

## Overview

### Description

Apple Carplay application that pauses your Apple Music when you go over the speed limit. 2 Screens, one for music and one for the actual app

### App Evaluation

[Evaluation of your app across the following attributes]
- **Category:** Utility
- **Mobile:** Yes, mainly CarPlay
- **Story:**  Be a safe driver
- **Market:** Drivers, People who speed up too much when listening to music
- **Habit:** Daily Use App
- **Scope:** Narrow Scope, not many features

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can view their current speed while driving
* User can see the speed limit for the current area they are in
* The user receives a warning if they start going over the speed limit
* The user's music is paused if they go too fast and will only resume once they slow down to the speed limit

**Optional Nice-to-have Stories**

* User can view a map while the app is open
* User receives a congratulatory message after a safe drive
* User can customize their app display

### 2. Screen Archetypes

- [X] Main Screen (Milestone 8 Gif)![UIProgress](https://github.com/user-attachments/assets/62039bb2-57cd-4758-9be6-67348523cb02)

* Tied to all must have stories
- [ ] App Customization (Optional)
* User can customize their app display

### 3. Navigation

**Flow Navigation** (Screen to Screen)

- [ ] Main Screen
  * Leads to Customization Screen
- [ ] Custmization Screen
  * Leads back into Main Screen


## Wireframes

<img width="1316" alt="image" src="https://github.com/user-attachments/assets/ad98dc2f-c264-48ef-8e59-b20f1f0ca995" />
<img width="1307" alt="image" src="https://github.com/user-attachments/assets/76126a3f-c2cb-4324-a145-e7521af29768" />
<img width="1313" alt="image" src="https://github.com/user-attachments/assets/6751845d-91e1-46cb-8d37-33d00beed774" />


### [BONUS] Digital Wireframes & Mockups
https://www.figma.com/design/PRz2KMEXdAqwmFlOyy4Y9n/SpeedDrop?node-id=0-1&t=ylfH7G6RmQ8zapXm-1

### [BONUS] Interactive Prototype
https://www.figma.com/proto/PRz2KMEXdAqwmFlOyy4Y9n/SpeedDrop?node-id=0-1&t=ylfH7G6RmQ8zapXm-1  
![SpeedDropDemoGif](https://github.com/user-attachments/assets/ffacb8fc-8793-494a-a903-d8d5ce87995b)




## Schema 


### Models

For our project we will not need any models/databases

### Networking

- https://smap.hereapi.com/v8/maps/attributes?
  * To get the speed limit for the current coordinates


## Milestone 4 Progress

### Main Screen - Kyla
![UIProgress](https://github.com/user-attachments/assets/62039bb2-57cd-4758-9be6-67348523cb02)

### Getting User Speed - Saul
<img width="371" alt="Screenshot 2025-04-20 at 7 03 54 PM" src="https://github.com/user-attachments/assets/fd77e8e9-8aa9-4f88-a5e8-136e52e7a4a7" />


## Speed Limit Implementation - Janniel

<img width="371" src="https://raw.githubusercontent.com/SpeedDrop/SpeedDrop-App/main/490695767_2821306194738058_7359752764216030707_n.png" />
Description: When the driver enters a new street, the app briefly displays a “Gathering data!” message. This indicates a short delay as the app fetches the current speed limit using real-time location data. Once retrieved, the correct speed limit is immediately shown to the user.
<img width="371" src="https://raw.githubusercontent.com/SpeedDrop/SpeedDrop-App/main/491005167_702941869069784_8269999360606935111_n.png" />

## Music Preview - Sergio
Unable to retreive preview at this moment. 
Creating a view screen so that user may be able to see the song currently playing. ability to adjust volume, pause, play, skip, replay/backtrack current song playing. 
will mimic current apple music player UI.

## Milestone 5 Progress 
### Main Screen Dynamic UI Formatting Added & Initial Car Customization Screen Created - Kyla
![UIUpdate](https://github.com/user-attachments/assets/f5f028fa-383f-4746-bb55-bebb28c00cfd)

### Getting User Speed - Saul
<a href="https://gifyu.com/image/bL2xW"><img src="https://s4.gifyu.com/images/bL2xW.gif" alt="ScreenRecording 04 27 202515 38 55 1 ezgif.com speed" border="0" /></a>

## Speed Limit Implementation - Janniel
![Alt text](9s6jma.gif)
API failed to work this week, but the implementation is currently on progress.
## Music Preview - Sergio
