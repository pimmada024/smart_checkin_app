# Smart Class Check-in App

## Project Description

Smart Class Check-in App is a Flutter application for classroom attendance and learning reflection.
Students can check in before class and finish class after session completion.

Main features:
- GPS location capture
- QR code scan verification
- Before-class check-in form (previous topic, expected topic, mood)
- After-class reflection form (what learned today, feedback)
- Local data storage for prototype usage

## Setup Instructions

Prerequisites:
- Flutter SDK (stable)
- Dart SDK (comes with Flutter)
- Firebase CLI (for web hosting deployment)

Install dependencies:

```bash
flutter pub get
```

Optional checks:

```bash
flutter doctor
flutter analyze
```

## How to run the app

Run on local device/emulator:

```bash
flutter pub get
flutter run
```

Run on web:

```bash
flutter run -d chrome
```

Build web release:

```bash
flutter build web
```

## Firebase configuration notes

This project deploys the web version using Firebase Hosting.

Typical deployment flow:

```bash
flutter build web
firebase login
firebase init hosting
firebase deploy
```

Notes:
- `firebase.json` in this repo contains hosting configuration.
- Deploy command publishes `build/web` to Firebase Hosting.

## Live Demo

https://your-project.web.app