# My-Meteo-App

This is a small exercise to test 2 frameworks I didn't use before: _AlamoFire_ and _Gloss_.

The app **geolocates** the user (if he allows it, else it considers he's in Paris), then **gets 64 data points** on infoclimat.fr API and displays them in a **Master/Detail** splitview app.

As it's just an exercise, several trade-offs were made:
- No UI/UX design effort whatsoever
- Not even averaging data points per day: data points are all displayed in a rough list
- iOS9+ only
- no localization of strings
- no observation of connexion status change (no implementation of Reachability for instance)

At the time I write this (06/22/2016), there is a bug with CocoaPods current version when using the UI Test module in XCode, so I could not implement any UI Test while using CocoaPods (this is a [known issue](https://github.com/CocoaPods/CocoaPods/issues/5110))
