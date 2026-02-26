# Proactive Expense Manager

A Flutter application for personal expense tracking with cloud synchronization, OTP-based authentication, and budget alert notifications.

---

## Features

- **Phone OTP Authentication** — Secure login via phone number and one-time password
- **Transaction Tracking** — Add and delete credit/debit transactions with notes and timestamps
- **Category Management** — Create and manage custom categories for expenses
- **Budget Alerts** — Set a monthly spending limit; receive local push notifications when exceeded
- **Cloud Sync** — Bidirectional sync of categories and transactions with the backend server
- **Restore on Login** — Existing users have their data automatically restored from the cloud on login
- **Per-User Database** — Separate SQLite database per user (keyed by phone number)
- **Onboarding** — First-time user walkthrough before authentication

---

## Tech Stack

| Concern | Library |
|---|---|
| State Management | `flutter_bloc` |
| Navigation | `go_router` |
| HTTP Client | `dio` + `retrofit` |
| Local Database | `sqflite` |
| Key-Value Storage | `shared_preferences` |
| Dependency Injection | `get_it` |
| Notifications | `flutter_local_notifications` |
| Responsive UI | `flutter_screenutil` |
| Serialization | `json_serializable` + `build_runner` |

---

## Architecture

The project follows **Clean Architecture** with a feature-first directory structure. Each feature is split into three layers:

```
feature/
├── data/
│   ├── datasources/     # Local (SQLite) + Remote (API) data sources
│   ├── models/          # JSON-serializable models with DB mapping
│   └── repositories/    # Implements domain repository contracts
├── domain/
│   ├── entities/        # Pure Dart objects, no framework dependencies
│   ├── repositories/    # Abstract repository contracts
│   └── usecases/        # Single-responsibility business operations
└── presentation/
    ├── bloc/            # Events, States, BLoC handler
    ├── pages/           # Screen widgets
    └── widgets/         # Feature-scoped UI components
```

### Features

| Feature | Responsibility |
|---|---|
| `auth` | OTP send/verify, account creation, logout |
| `transactions` | Add, delete, list transactions; sync to/from cloud |
| `categories` | Add, delete, list categories; sync to/from cloud |
| `sync` | Manual cloud push (upload new, delete removed records) |
| `dashboard` | Home screen with recent transactions and monthly summary |
| `settings` | Profile, budget limit, categories, sync, logout |
| `onboarding` | First-launch slide-based introduction |
| `main` | Bottom navigation shell |

---

## Project Structure

```
lib/
├── core/
│   ├── database/          # DatabaseHelper (SQLite setup, per-user DB)
│   ├── di/                # GetIt injection container
│   ├── network/           # Dio client, Retrofit API service
│   ├── router/            # GoRouter config and route constants
│   ├── services/          # LocalStorageService, NotificationService
│   ├── theme/             # Colors, text styles, Material3 theme
│   ├── error/             # Exception and failure types
│   └── utils/             # AppLogger
├── feature/               # Feature modules (see above)
├── ui/                    # Shared UI components (button, text field, divider)
└── gen/                   # Generated asset references
```

---

## Sync Design

The sync system uses a **soft-delete + is_synced flag** pattern:

| Column | Meaning |
|---|---|
| `is_synced = 0` | Created locally, not yet uploaded |
| `is_synced = 1` | Exists on the server |
| `is_deleted = 0` | Active record |
| `is_deleted = 1` | Soft-deleted, pending cleanup |

**Push sync order (to avoid FK violations):**
1. Delete soft-deleted transactions from cloud
2. Delete soft-deleted categories from cloud
3. Upload new categories (must exist before transactions reference them)
4. Upload new transactions

**Restore on login (existing users):**
1. Re-initialize user-specific SQLite database
2. Fetch and restore categories from cloud
3. Fetch and restore transactions from cloud

---

## Getting Started

### Prerequisites

- Flutter SDK (Dart 3.9.0+)
- Android Studio / Xcode for device/emulator

### Install dependencies

```bash
cd proactive_expense_manager
flutter pub get
```

### Run code generation

Required after modifying any `@JsonSerializable` or Retrofit annotated files:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Run the app

```bash
flutter run
```

---

## Environment

The app connects to:

```
Base URL: https://appskilltest.zybotech.in
```

Authentication uses a Bearer token stored in `SharedPreferences` and attached to every request via a Dio interceptor.

---

## Database Schema

```sql
CREATE TABLE categories (
  id        TEXT PRIMARY KEY,
  name      TEXT NOT NULL,
  is_synced INTEGER NOT NULL DEFAULT 0,
  is_deleted INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE transactions (
  id          TEXT PRIMARY KEY,
  amount      REAL NOT NULL,
  note        TEXT NOT NULL,
  type        TEXT NOT NULL,           -- 'debit' | 'credit'
  category_id TEXT NOT NULL,
  is_synced   INTEGER NOT NULL DEFAULT 0,
  is_deleted  INTEGER NOT NULL DEFAULT 0,
  timestamp   TEXT NOT NULL,
  FOREIGN KEY (category_id) REFERENCES categories(id)
);
```
