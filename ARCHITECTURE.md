# Project Requirement & Architecture Document

## 1. Project Summary

**Church Attendance & Management System**

The primary goal of this application is to digitize and streamline the management of church services, specifically focusing on **Student Attendance** and **Servant Management**. The system is designed as a dual-platform solution (Mobile & Web) to allow servants (admins/users) to manage student profiles and track attendance efficiently, even in offline environments.

While the initial phase focuses on **Attendance**, the architecture is designed to be scalable for future modules like "Results" and "Grade Management". A key requirement is handling **data conflicts** (e.g., multiple servants marking different statuses) and ensuring **cost-effective usage of Firestore** (minimizing reads).

---

## 2. Technical Specifications

### Tech Stack
*   **Framework**: Flutter (Mobile & Web).
*   **Backend**: Firebase (Firestore, Auth, Storage, Hosting).
*   **State Management**: `flutter_bloc`.
*   **Dependency Injection**: `get_it` + `injectable` (recommended).
*   **Code Generation**: `freezed`, `json_serializable`.

### Local DB Strategy: Hive vs. SQLite

**Comparison:**
*   **SQLite (via `sqflite` or `drift`):** Strong relational data integrity and complex querying capabilities. Good for generating complex reports directly on the device. However, it requires more boilerplate and rigid schema migrations.
*   **Hive:** NoSQL, key-value store. Extremely fast, lightweight, and pure Dart. It maps easily to Dart objects. Given the nature of "Attendance" (lists of students, daily records) and the need for "Offline Support", Hive's simplicity in syncing entire objects (or boxes) often outweighs the relational benefits of SQL for this specific scope.

**Recommendation: Hive**
*   **Why?** The data model is hierarchical (Class -> Students -> Attendance). Hive allows us to store "Daily Attendance" or "Student Profiles" as objects efficiently. It is faster to implement and works seamlessly with `freezed` models.
*   *Note:* Ensure you use `hive_flutter` and consider `Isar` (by the creator of Hive) if you need query capabilities later, but Hive is sufficient for the core requirements.

### Optimization (Firestore Read Quotas)

To strict "Read Quota" constraints, we must avoid reading 1 document per student per day.

**Strategy: "Daily Class Document"**
Instead of storing attendance on the Student document, store it in a dedicated `attendance` collection partitioned by Date and Class.

*   **Collection:** `attendance_sheets`
*   **Document ID:** `<ClassID>_<YYYY-MM-DD>` (e.g., `Grade5_2023-10-27`)
*   **Structure:**
    ```json
    {
      "date": "2023-10-27",
      "class_id": "Grade5",
      "records": {
        "studentID_1": { "status": "Present", "updated_by": "ServantA", "timestamp": 12345678 },
        "studentID_2": { "status": "Absent",  "updated_by": "ServantB", "timestamp": 12345679 }
      },
      "conflicts": ["studentID_3"]
    }
    ```
*   **Benefit:** Loading the attendance sheet for the whole class costs **1 Read**.

### Excel Handling

**Recommended Package:** `excel` (https://pub.dev/packages/excel)
*   **Why?** It is a pure Dart package (no native dependencies), making it compatible with both Mobile and Web.
*   **Usage:**
    *   **Import:** Parse `.xlsx` to `List<StudentModel>` for bulk addition.
    *   **Export:** Generate `.xlsx` from the `attendance_sheets` data for reporting.

---

## 3. Feature Logic: The Conflict Issue

**Scenario:** Servant A marks Student X as "Present". Servant B marks Student X as "Absent".

**Proposed Logical Flow:**

1.  **Optimistic Updates (Local):** App allows the servant to mark attendance offline/online instantly.
2.  **Sync/Merge Logic:**
    *   When saving to Firestore (via a Transaction or merging):
    *   Fetch the latest `attendance_sheet` for that day.
    *   Check `records[studentID]`.
3.  **Conflict Detection Algorithm:**
    *   If `existing_status` exists AND `existing_status != new_status`:
        *   **Flag as Conflict.**
        *   Update status to **"Absent"** (default safety rule).
        *   Add a metadata flag: `is_conflict: true` or add to a `review_queue`.
4.  **UI Resolution:**
    *   The UI displays a "Warning/Conflict" icon next to the student.
    *   A Servant with "Admin" rights (or any servant, depending on rules) must tap the icon to resolve it (Manually confirm "Present" or "Absent").
    *   Once resolved, `is_conflict` is set to `false`.

---

## 4. Recommended File Structure

We will use a **Feature-First Architecture** combined with **Clean Architecture** principles. This ensures scalability and separation of concerns.

```text
lib/
├── main.dart                  # Entry point
├── core/                      # Shared logic, utils, constants
│   ├── config/                # Firebase options, env variables
│   ├── error/                 # Failure classes, exceptions
│   ├── services/              # Third-party services (ExcelService, FileService)
│   ├── utils/                 # Date formatters, validators
│   └── widgets/               # Shared UI components (Buttons, Inputs)
├── data/                      # Data layer (Repositories implementations)
│   ├── datasources/
│   │   ├── local/             # Hive setup, DAOs
│   │   └── remote/            # Firestore, Firebase Auth
│   ├── models/                # DTOs (Data Transfer Objects), JSON serialization
│   └── repositories/          # Repository implementations
├── domain/                    # Business Logic (Entities, Repository Interfaces)
│   ├── entities/              # Pure Dart classes (Student, AttendanceRecord)
│   ├── repositories/          # Abstract Repository interfaces
│   └── usecases/              # Specific business actions (MarkAttendance, ImportStudents)
├── features/                  # Feature-based modules
│   ├── auth/                  # Authentication Feature
│   │   ├── presentation/      # Bloc, Screens, Widgets
│   │   ├── domain/
│   │   └── data/
│   ├── students/              # Student Management
│   │   ├── presentation/
│   │   │   ├── bloc/          # StudentBloc
│   │   │   ├── screens/       # StudentListScreen, AddStudentScreen
│   │   │   └── widgets/
│   │   └── ...
│   └── attendance/            # Attendance Feature
│       ├── presentation/
│       │   ├── bloc/          # AttendanceBloc
│       │   └── screens/       # AttendanceSheetScreen
│       ├── logic/             # Conflict resolution logic could live here or in domain
│       └── ...
└── injection_container.dart   # GetIt dependency injection setup
```

**Key Locations:**
*   **Excel Services:** `lib/core/services/excel_service.dart`.
*   **Conflict Logic:** Inside `lib/features/attendance/domain/usecases/resolve_attendance_conflict.dart` or within the `AttendanceRepository` implementation.
*   **Hive TypeAdapters:** `lib/data/datasources/local/hive_adapters.dart`.

---

## 5. Implementation Roadmap

### Phase 1: Foundation & Local DB
1.  **Setup Project:** Initialize Flutter, configure `flutter_bloc`, `get_it`, `freezed`.
2.  **Local Data Layer:** Setup **Hive**. Create `StudentModel` and `AttendanceModel` with Hive adapters.
3.  **Repositories:** Implement `LocalStudentRepository` to CRUD students and save attendance locally.

### Phase 2: Firebase Integration
1.  **Auth:** Implement Firebase Auth (Login/Sign up).
2.  **Firestore:** Connect the repositories to Firestore.
3.  **Sync Logic:** Implement the "Daily Class Document" structure. Ensure local changes are pushed to Firestore when online.

### Phase 3: The Core Features (Attendance & Conflicts)
1.  **Attendance UI:** Build the grid/list view for marking attendance.
2.  **Conflict Handling:** Implement the logic to detect differences between local and remote state during sync. Default to "Absent" and flag conflicts.

### Phase 4: Excel Import/Export
1.  **Service:** Create `ExcelService` using the `excel` package.
2.  **Import:** Build a UI to pick a file, parse it, and bulk-create Student entities in Hive/Firestore.
3.  **Export:** Query `attendance_sheets`, format data, and save/share the `.xlsx` file.

### Phase 5: UI/UX Refinement
1.  **Polishing:** Apply the specific clean specifications.
2.  **Review:** Ensure Read Quotas are respected (check Firestore usage).
