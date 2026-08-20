# HRDesk

HRDesk is a native iOS app that helps HR teams recruit, track, and grow talent. Built with SwiftUI and Core Data, it covers the full hiring flow — from posting jobs and sourcing candidates, through the interview pipeline, to hiring and team management — all with built-in analytics.

## Features

- **Authentication** — Sign up / login with local accounts (credentials stored in Core Data). Session is persisted across app launches.
- **Home Dashboard** — Quick overview with stats and a task list (To-Dos).
- **Pipeline** — Kanban-style candidate pipeline across hiring stages, with drag-and-drop candidate cards, candidate detail/edit views, and stage-based tracking.
- **Interviews** — Schedule upcoming interviews with candidates and interviewers, edit, and view interview history.
- **Jobs** — Post, edit, and manage job openings with status and candidate tracking.
- **Employees** — Manage the team: departments, positions, salaries, and joining dates.
- **Analysis** — Visual analytics built with Swift Charts: KPIs, recruitment funnel, stage conversions, candidate distribution, applications per job, hiring by department, and rejection reasons.
- **Notifications** — Local reminders for upcoming interviews and due tasks; notifications show as banners even when the app is in the foreground, and an instant confirmation fires when an interview is scheduled.

## Requirements

- Xcode 26 or later
- iOS 26.5+ (SwiftUI, Swift Charts, Core Data)
- Swift 5 / Swift 6

## Getting Started

1. Clone the repository.
2. Open `HRDesk.xcodeproj` in Xcode.
3. Select the **HRDesk** scheme and a Simulator (or device) destination.
4. Run (⌘R).

### Building from the command line

```bash
xcodebuild -project HRDesk.xcodeproj -scheme HRDesk -destination 'generic/platform=iOS Simulator' build
```

## Project Structure

```
HRDesk/
├── App/          App entry point, splash, authentication flow, root & main tab views
├── Components/   Reusable UI components (buttons, cards, fields, rings, rows)
├── Models/       Core Data model (HRDesk.xcdatamodeld) + plain model types
├── Services/     Core Data container/service, session management, notifications
├── Utils/        Enums and view extensions
├── ViewModels/   MVVM view models (auth, candidates, jobs, interviews, etc.)
└── Views/        Feature screens
    ├── Auth/         Login & signup
    ├── Home/         Dashboard and To-Do task management
    ├── Pipeline/     Kanban pipeline, candidates, interviews
    ├── Jobs/         Job postings
    ├── Employees/    Team management
    ├── Profile/      Profile, settings, notifications, privacy, help
    └── Analysis/     Charts and analytics dashboards
```

## Architecture

- **MVVM** — SwiftUI views, view models per feature, and Core Data repositories in Services.
- **Core Data Entities** — `UserEntity`, `CandidateEntity`, `JobEntity`, `InterviewEntity`, `EmployeeEntity`, `TodoEntity`.
- **State** — Shared container (`PersistenceController`) provides the managed object context through the environment; `SessionManager` and view models are injected as environment objects.
- **Notifications** — `NotificationService` (a `UNUserNotificationCenterDelegate`) schedules interview/task reminders at their due time, shows banners while the app is foregrounded, and clears the app badge on activation.
