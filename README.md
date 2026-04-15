# Student-Grade-Management-System

## Project Overview
The Student Grade Management System is a Command Line Interface (CLI) application written entirely in Bash. It manages students, subjects, and grades using flat-file storage on disk, requiring no external databases. The system supports full CRUD (Create, Read, Update, Delete) operations, strict input validation, and dynamic generation of statistical reports.

## Project Structure
To support concurrent development without merge conflicts, the source code is divided into modular scripts within the `scripts/` directory. A build script compiles these into the final executable.

### File Architecture
```text
SGMS/
├── build.sh             # Compiles development scripts into sgms.sh
├── sgms.sh              # The final single executable (Auto-generated)
├── .gitignore           # Ignores generated script and local data
├── README.md            # Project documentation
├── scripts/             # Development source files
│   ├── main_menu.sh     # Core loop and CLI navigation
│   ├── students.sh      # Student CRUD operations
│   ├── subjects.sh      # Subject CRUD operations
│   ├── grades.sh        # Grade assignment and management
│   ├── reports.sh       # GPA calculation and statistics
│   └── utils.sh         # Shared validation and helper functions
└── sgms_data/           # Data storage (Auto-created on first run)
```

### Data Storage Specifications
Data is strictly stored using flat files with relative pathing. The system automatically generates the following directory structure upon execution:

| Directory | File Format | Contents |
| :--- | :--- | :--- |
| `sgms_data/students/` | `ID.stu` | One file per student storing: ID, Name, Email, Year (one value per line). |
| `sgms_data/subjects/` | `CODE.sub` | One file per subject storing: Code, Name, Credits (one value per line). |
| `sgms_data/grades/` | `CODE.grd` | One file per subject storing rows as: `student_id | score | letter`. |

## How to Run

1. Clone the repository to your local machine.
2. Navigate to the project root directory.
3. Grant execution permissions to the build script:
   ```bash
   chmod +x build.sh
   ```
4. Run the build script to compile the source code into the final executable:
   ```bash
   ./build.sh
   ```
5. Execute the compiled application:
   ```bash
   ./sgms.sh
   ```

## Team Members & Responsibilities

| Team Member | Assigned Modules & Responsibilities |
| :--- | :--- |
| **Mariam Asal** | **Core Architecture & Storage:** `build.sh`, `utils.sh`, `students.sh`, `subjects.sh`. Responsible for directory initialization, input validation logic, and student/subject CRUD operations. |
| **Mawada Alexandar** | **Grading & Reports:** `grades.sh`, `reports.sh`, `main_menu.sh`. Responsible for grade assignments, `sed`/`awk` operations for file parsing, GPA calculation matrix, and the primary user interface. |

## Validation Rules Implemented
The system enforces strict input validation to maintain data integrity:
* **Student ID:** Numeric only, up to 10 digits, strictly unique.
* **Email:** Must contain an '@' symbol and a domain dot.
* **Academic Year & Credits:** Restricted to integers between 1 and 6.
* **Subject Code:** Must follow the format of 2-5 letters followed by 2-4 digits (e.g., CS101).
* **Grades:** Floating-point values between 0.0 and 100.0, mapped to standard GPA points (0.0 to 4.0).

## Additional Features 
* Data Export: Capable of exporting generated reports to `.txt` or `.csv` files.
* Advanced Search: Implements real-time student search via partial name matching utilizing `grep`.
* Weighted GPA: Calculates accurate GPAs by factoring in specific subject credit hours.
```

***
