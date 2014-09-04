HomeKit
---

Feature list :
 
  - **New:** works with Xcode6 alright
  - discover devices and add them to your primary home
  - manage your primary home
  - add a room to your primary home
  - change the name of your primary home
  - add an accessory to your primary home
  - see the list of services of a accessory
  - see the list of characteristics of a service
  - change the values of these characteristics : power, hue, saturation

To do :

  - implement UI to change the values of other kinds of characteristics
  - action sets and triggers (currently)

How to play with this demo
===

  - `git clone` this repo
  - open the `.xcodeproj` with Xcode 6 (I uses beta 2 and 3)
  - in Xcode, go to `XCode` -> `Open Developers Tools` -> `HomeKit Accessory Simulator` and create at least one accessory with a lamp service
  - run on simulator, but first go to the second tab to configure your primary home
  - if you run on a device, **Siri works**