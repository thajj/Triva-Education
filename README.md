# TRIVIA KIDS EDUCATION #

First Native APP develop during Covid-19....


## TODO - MUST HAVE ##

- [x] Create data model
- [x] Build project structure
- [x] Interface with OpenTBD
- [x] Category list
- [x] Quizz page
- [x] Reult page
- [x] Verify answer page
- [x] Improve page transition
- [x] Splash screen - [Tutorial here](https://medium.com/@diegoveloper/flutter-splash-screen-9f4e05542548)
- [x] Sound effect
- [x] Fix timer
- [x] Make app fullscreen and adjust widget position in quizz page
- [x] Make reponsvive
- [x] Improve UX of the category
- [x] Fix quizz page button overflow issue
- [x] Dont show null when no answer in the Quizz answer
- [x] Make current question indicator fixed
- [x] Block portrait orientation (Especially in mobile device)
- [x] Notify settings change when there's a change
- [x] Bring back color animation (fade out)
- [X] Fix timers for the first question
- [x] i8n for EN
- [ ] Add licence and use logo from openTDB
- [x] Plum sound effect when tapping some btn
- [ ] Precached audio file
- [x] Move setting to start page
- [x] Fix splash screen
- [ ] Animate logo after splash screen fade in App name + Logo
- [x] Update the font of Open Trivia
- [x] Fix broken wave animation
- [ ] Update credit
- [ ] Finish start
    - [ ] Play to close
    - [ ] Add share
    - [ ] Add rate App : https://pub.dev/packages/rating_dialog#-readme-tab-
- [x] Decide a name of the APP
- [x] Icon page - [Tutorial here](https://stackoverflow.com/questions/43928702/how-to-change-the-application-launcher-icon-on-flutter) and [here](https://androidmonks.com/flutter-change-app-name/#Changing_App_Icon_For_IOS)
- [ ] Test APK mobile no network
- [x] Hide home btn in APP bar when before release
- [x] branch before using the right BO
- [x] Open settings as dialog : - Open settings as dialog :
- [ ] Background detection - pause
- [ ] Setting UI
- [ ] 60sec remaining...
- [ ] Animated BG
- [ ] Button UI 
- [ ] Result animation : https://medium.com/@felixblaschke/fade-in-your-uis-in-flutter-c81b1c345f70
- [ ] Answer animation?

## Preparing the APP for release


- [x] Onboarding screen
- [x] Title + description

### [ANDROID](https://flutter.dev/docs/deployment/android)

- [x] Bundle package + review ID / package / label
- [x] Deploy for private access

### [IOS](https://flutter.dev/docs/deployment/ios)

- [ ] Bundle package + review ID / package / label
- [ ] Sign US docs...
- [ ] Pay fees for account creation
- [ ] Validate account for publication...


## Warning to fix
* No preferred FlutterEngine was provided. Creating a new FlutterEngine for this FlutterFragment

## TODO - NICE TO HAVE / ROAD MAP ##

* Adapt data model with home Back end - cat + q&A
* Add theme support
* Add game mode (free to play, random, no timer
* Improve the UX of the settings screen
* Impleement order control of question
* Profile support
* Implement notification
* Extract legend
* Add custom splash page in order to use animated_kit + server connection + warmup
* display the number of questions https://opentdb.com/api_count_global.php

### Resources

https://github.com/nisrulz/flutter-examples

Google sign in : https://github.com/nisrulz/flutter-examples/tree/master/google_signin
https://developers.google.com/android/guides/client-auth
https://stackoverflow.com/questions/54557479/flutter-and-google-sign-in-plugin-platformexceptionsign-in-failed-com-google/54696963#54696963

Facebook : https://github.com/roughike/flutter_facebook_login

INTL
https://github.com/flutter/website/blob/master/examples/internationalization/intl_example/lib/main.dart
// flutter pub get
// flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/main.dart
// flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/main.dart lib/l10n/intl_*.arb
