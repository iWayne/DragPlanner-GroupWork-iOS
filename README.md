_Last Updated: Fri, Sept 19th, 2015  @ 13:35P_

### Drag Planner

Welcome!

Drag Planner is an iOS app for easy schedule. Users can drag events on the date, pull the bottom of the event to change the duration, and move the event to set the start time. Events will also sync with different could.

Our philosophy is do most what apps can do, instead of forcing users to choose.

____

###REQUIREMENT

Swift 1.1/1.2

iOS above 8.4

____

###FLOW PATH
 
 - Add Event
 
   1. Tap '+' in the top-right corner in Daily View, and choose event color
   2. Type the title
   3. Hold and move the event to change the start time. (Move close to edge of the screen to change date)
   4. Pull the bottom of the event to change the duration
   5. Press 'Done' button to finish
 
 - Delete Event
 
   1. Press and hold an event until its backgroud colour changes
   2. Press 'Delete' button in the bottom of the screen
 
 - Modify Event
   1. Press and hold an event until its backgroud colour changes
   2. Tap the event, and modify the title
   3. Hold for a while, and move to change the start time
   4. Pull the bottom of the event to change the duration
   5. Press 'Done' button to finish

____

###DISCRIPTION

 [PDF Version](./presentation.pdf)

####Event Type

For data of events, we use SQL query to fetch from cloud and follow the API to get access to iCalender.

To overcome problem from the asynchronous thread when fetching (get data but never show on the screen), we force fetching process in the main thread. 

We also add gestures for multi function, like pulling down to change the duration, tap events to modify the title, and hold event for moving.


 - Red Event

  The most important event in the app. It comes with a notification and user need to response to that, so user will never miss this event. It will sync with cloud from Parse.com.

 - Yellow Event

  The important event that comes with only alarm. It sync with cloud from Parse.com

 - Blue Event

  The events from Apple Calendar. User need to provide authorization in order to read them. It show in our app because we want user don't worry about making any conflicts in schedule. But users can also modify these events. It will automatically sync with iCloud.


####View Type

In this part, we implement many libraries for different purposes. Like JTCalendar for Month View, MaCalendar for Daily View, MGSwipeTable for Missing-Event View.

Without directly implement, We modify much inside the libraries to guarantee they works together and smoothly. For instance, we modify the MaCalendar's API in order to read the position of the Sliding View, which help us to calculate the start time of the event. We also re-write the Event object, which originally didn't support adding events by dragging.

We also create many components in this part. Like the rectangles of events, which are separate from the library. We create them, let them above the MaCalender layer, and enable them to communicate with MaCalender data.


 - Main View

  It combines with two different view. A Month View and a Time Line View.

  For Month View, users can easily get the date. We also add the swipe gestures for switching the month.

  For Time line view, it shows the today's events for 


 - Daily View

  This view privide the most straightforward understand for the schedule. Users here can add, delete, modify events by just dragging them.

  Share function is also available to different target.


 - Missing Event

  Here list the red events that users didn't response to their notification. Users can review here and also check, delete, or reschedule the events.

____

###SCREENSHOTS

![MAIN](./Presentation Images/Main.jpg "Main View")

![DAY](./Presentation Images/Day View.jpg "Day View")
![MISSING](./Presentation Images/Missing Events.jpg "Missing")
![SHARE](./Presentation Images/Share.jpg "Share Func")


____

###AUTHOR

 - [Wayne/ Wei Shan](https://github.com/ishawn)
 - [Dong Li](https://github.com/mewhuan)
 - [Lien-Jung Chang](https://github.com/ljc391)

____

###REFERENCE & PROTOTYPE

 - [Prototype](http://invis.io/TQ2EC6LSR)
 - [JTCalendar](https://github.com/jonathantribouharet/JTCalendar)
 - [MACalendar](https://github.com/muhku/calendar-ui)
 - [MGSwipeTable](https://github.com/MortimerGoro/MGSwipeTableCell)
 - [Parse](https://parse.com)


____

###NEXT STEP

 * Debug and update for Swift 2.0
 * Re-organize the events as the sketch:

![DRAFT](./Presentation Images/Draft.jpg "Sketch")
