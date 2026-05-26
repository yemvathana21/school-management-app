# Wrote Desktop\PSBU\PROJECT_STATUS.md
# PSBU School Management System - Project Status
## Last Session: May 22, 2026
## What was built
### Backend (Laravel)
- **Auth**: Login/logout with Sanctum tokens
- **API Endpoints**: 16 endpoints (classes, schedules, attendances, grades, announcements, assignments, QR)
- **Models**: User, Classes, Course, Schedule, Attendance, Grade, Announcement, Assignment
- **Filament Admin**: CRUD for all resources at /admin
- **DB**: SQLite with 12 tables, seeded with sample data
### Flutter App
- **Auth flow**: Splash -> Login/auto-login -> role-based routing
- **Student Shell**: Bottom nav with Home, Schedule, QR Scan (FAB), Class, Menu
- **Home**: Gradient header (greeting + avatar + bell + date), announcement carousel (4 colors), schedule timeline with "Now" badge, attendance stats cards, quick access grid
- **Schedule**: TabBar (Mon-Fri), colored course cards with time/location/teacher
- **QR Scan**: Camera scanner wired to POST /api/attendances (parses schedule_id|timestamp)
- **Classes**: List from API, tap to navigate to Class Detail screen
- **Class Detail**: Gradient header with stats, schedule list, student list
- **Grades**: Average card with progress bar, grouped by course, color-coded by type
- **Assignments**: List with overdue indicators and day countdown
- **Menu**: Profile card (navigates to Profile screen), Grades, Schedule, Assignments, Attendance, Settings, Logout
- **Profile**: User info display
- **Settings**: Push notifications toggle, dark mode toggle
- **Teacher Shell**: Dashboard (class/student count), Attendance (QR generation + status management), Grades (add grade form + history)
### Data Layer
- **7 Dart models** with fromJson
- **8 repositories** using Dio
- **8 Riverpod providers**
- **Hive** initialized for offline caching
- **LocalCacheService** ready for use
## Login Credentials
| Role | Email | Password |
|------|-------|----------|
| Student | student1@psbu.ac.id | password |
| Teacher | budi@psbu.ac.id | password |
| Admin | admin@psbu.ac.id | password |
## To Run
```bash
# Terminal 1: Backend
cd backend && php artisan serve
# Terminal 2: Flutter
cd app && flutter run
```
## To Fix for Android Emulator
In `app/lib/core/constants.dart`, change:
```dart
static const String baseUrl = 'http://localhost:8000/api';
```
to:
```dart
static const String baseUrl = 'http://10.0.2.2:8000/api';
```
## Next Ideas
1. Dark mode theme implementation
2. Push notifications (Firebase)
3. Parent/guardian accounts
4. Student assignment submission (file upload)
5. Chat/messaging feature
6. Export grades to PDF
7. Teacher grade import from CSV/Excel
8. Offline-first providers (wrap with LocalCacheService)
9. Unit/widget tests