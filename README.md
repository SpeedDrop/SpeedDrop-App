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

- [ ] Main Screen
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


## Schema 


### Models

For our project we will not need any models/databases

### Networking

- https://smap.hereapi.com/v8/maps/attributes?
  * To get the speed limit for the current coordinates
