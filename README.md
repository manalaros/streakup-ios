# StreakUp

StreakUp is an iOS app built with SwiftUI and MVVM that helps users log workouts, track activity streaks, view weekly stats, and compete with friends on a leaderboard.

## Project structure

- `Models/` — API request/response models
- `Networking/` — API client and request handling
- `Services/` — app services such as Keychain storage
- `ViewModels/` — presentation logic and state
- `Views/` — SwiftUI screens
- `StreakUp/` — app entry point and assets

## Backend

The app connects to a separate Spring Boot backend with JWT authentication, PostgreSQL, and server-side calculations for streaks, statistics, and leaderboard ranking.

## Architecture goals

- SwiftUI only for the UI
- MVVM for app structure
- JWT stored in Keychain
- Networking separated from views
- Backend as the source of truth for business rules

## Current progress

- Core models aligned with the backend API
- Ready to implement the networking layer next
