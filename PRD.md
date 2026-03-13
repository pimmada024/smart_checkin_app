# Smart Class Check-in & Learning Reflection App

**Course:** Mobile Application Development (1305216)
**Project Type:** Midterm Lab Prototype

---

# 1. Problem Statement

Universities need a reliable method to verify student attendance and participation in classroom activities. Traditional attendance systems typically rely on manual roll calls or simple checklists, which only confirm presence but do not provide insight into student engagement or learning experience.

The goal of this system is to develop a simple mobile application that allows students to check in to a class session and reflect on their learning experience. The system must ensure that students are physically present in the classroom and actively participate in the learning process.

To achieve this, the system will utilize several technologies including GPS location verification, QR code scanning, and student learning reflection forms. These features help confirm attendance, capture student expectations before class, and record learning outcomes after the class session.

---

# 2. Target Users

The primary users of the system are university students attending classroom sessions.

Secondary stakeholders include instructors or course administrators who may later review attendance records and student reflections.

User Characteristics:

* University students enrolled in a course
* Students using smartphones or web-based mobile applications
* Students required to check in and reflect during each class session

---

# 3. Feature List

The system will include two main operational features: **Class Check-in (Before Class)** and **Class Completion (After Class)**.

## 3.1 Class Check-in (Before Class)

Before the class begins, students must perform the following steps:

1. Press the **Check-in** button on the application.
2. The system automatically records:

   * GPS Location (latitude and longitude)
   * Timestamp of the check-in event.
3. Students scan the **class QR code** provided by the instructor.
4. Students complete a short form containing:

   * What topic was covered in the previous class.
   * What topic they expect to learn today.
   * Their mood before class using a mood scale.

### Mood Scale

| Score | Mood             |
| ----- | ---------------- |
| 1     | 😡 Very negative |
| 2     | 🙁 Negative      |
| 3     | 😐 Neutral       |
| 4     | 🙂 Positive      |
| 5     | 😄 Very positive |

After completing the form, the system saves the check-in data.

---

## 3.2 Class Completion (After Class)

At the end of the class session, students must complete the class completion process.

Students perform the following steps:

1. Press the **Finish Class** button.
2. Scan the **class QR code again** to verify the session.
3. The system records:

   * GPS location
   * Timestamp of completion.
4. Students fill in a short reflection form including:

   * What they learned during the class session.
   * Feedback about the class or the instructor.

The system then saves the class completion data.

---

# 4. User Flow

The expected user interaction flow is described below.

### Before Class (Check-in Process)

Student opens the application
↓
Home Screen appears
↓
Student presses **Check-in**
↓
System records GPS location and timestamp
↓
Student scans class QR code
↓
Student fills the check-in form:

* Previous class topic
* Expected topic for today
* Mood before class
  ↓
  Student submits the form
  ↓
  System saves the check-in data

---

### After Class (Class Completion Process)

Student opens the application
↓
Home Screen appears
↓
Student presses **Finish Class**
↓
Student scans the class QR code again
↓
System records GPS location and timestamp
↓
Student fills the reflection form:

* What they learned today
* Feedback about the class
  ↓
  Student submits the form
  ↓
  System saves the completion data

---

# 5. System Screens

The mobile application will contain at least the following screens:

1. **Home Screen**

   * Displays application title
   * Provides two main actions:

     * Check-in
     * Finish Class

2. **Check-in Screen**

   * Records GPS location
   * QR code scanning interface
   * Form fields:

     * Previous class topic
     * Expected topic today
     * Mood scale selection
   * Submit button

3. **Finish Class Screen**

   * QR code scanning interface
   * GPS location capture
   * Reflection form:

     * What did you learn today
     * Feedback about the class
   * Submit button

---

# 6. Data Fields

The system will store two main types of data: **Check-in data** and **Class completion data**.

## 6.1 Check-in Data

| Field         | Description                                    |
| ------------- | ---------------------------------------------- |
| studentName   | Name of the student                            |
| studentId     | Student identification number                  |
| timestamp     | Time of check-in                               |
| latitude      | GPS latitude                                   |
| longitude     | GPS longitude                                  |
| qrCode        | QR code content representing the class session |
| previousTopic | Topic covered in the previous class            |
| expectedTopic | Topic the student expects to learn today       |
| mood          | Mood rating before class (1–5)                 |

---

## 6.2 Class Completion Data

| Field        | Description                                    |
| ------------ | ---------------------------------------------- |
| timestamp    | Time when the class was finished               |
| latitude     | GPS latitude                                   |
| longitude    | GPS longitude                                  |
| qrCode       | QR code representing the class session         |
| learnedToday | Student reflection on what they learned        |
| feedback     | Student feedback about the class or instructor |

---

# 7. Tech Stack

The prototype system will use the following technologies:

### Frontend

Flutter (Mobile and Web Application Framework)

### Device Capabilities

* GPS Location Retrieval
* QR Code Scanning

### Data Storage (MVP)

Local storage using:

* localStorage (for Flutter Web)
  or
* SQLite (for mobile version)

### Deployment

Firebase Hosting will be used to deploy the web version of the application so it can be accessed via a public URL.

---

# 8. System Architecture (Prototype)

```
User
 │
 │  Flutter Mobile/Web Application
 │
 ├── Home Screen
 │
 ├── Check-in Screen
 │     ├ GPS Location
 │     ├ QR Code Scan
 │     └ Check-in Form
 │
 └── Finish Class Screen
       ├ QR Code Scan
       ├ GPS Location
       └ Reflection Form

Data Storage
   └ LocalStorage / SQLite

Deployment
   └ Firebase Hosting
```

---

# 9. Assumptions and Design Decisions

Since the provided requirements are incomplete, the following assumptions are made:

1. QR codes represent a class session identifier.
2. GPS location is recorded to confirm that students are physically present in the classroom.
3. The application stores data locally for the prototype version.
4. Firebase Hosting is used only for application deployment.

These assumptions allow the system to function as a working prototype within the exam constraints.


Smart Class Check-in App
│
├── Home Screen
│     ├── Button → Check-in
│     └── Button → Finish Class
│
├── Check-in Screen
│     ├── Get GPS Location
│     ├── Scan QR Code
│     ├── Form
│     │     ├ Previous class topic
│     │     ├ Expected topic today
│     │     └ Mood (1-5)
│     └── Submit
│
└── Finish Class Screen
      ├── Scan QR Code
      ├── Get GPS Location
      ├── Reflection Form
      │     ├ What did you learn today
      │     └ Feedback
      └── Submit