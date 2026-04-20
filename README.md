# Student-Grade-Management-System

## Project Overview
The Student Grade Management System is a Command Line Interface (CLI) application written entirely in Bash. It manages students, subjects, and grades using flat-file storage on disk, requiring no external databases. The system supports full CRUD (Create, Read, Update, Delete) operations, strict input validation, and dynamic generation of statistical reports.

## Project Structure
To support concurrent development without merge conflicts, the source code is divided into modular scripts within the `scripts/` directory. A build script compiles these into the final executable.

### File Architecture
```text
SGMS/
├── sgms.sh              # The final single executable (Auto-generated)
├── .gitignore           # Ignores generated script and local data
├── README.md            # Project documentation
├── scripts/             # Development source files
│   ├── main_menu.sh     # Core loop and CLI navigation
│   ├── students.sh      # Student CRUD operations
│   ├── subjects.sh      # Subject CRUD operations
│   ├── grades.sh        # Grade assignment and management
│   ├── reports.sh       # GPA calculation and statistics
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
5. Run the sgms script to compile the source code into the final executable:
  ```bash
   ./sgms.sh
   ```

## Team Members & Responsibilities

| Team Member | Assigned Modules & Responsibilities |
| :--- | :--- |
| **Mariam Asal** | <ul><li>**Student Management:** Perform full CRUD (Add, List, Update, Delete) operations.</li><li>**Student Validation:** Enforce rules for numeric IDs, names, email formats, and academic years.</li><li>**Student Storage:** Manage records inside `sgms_data/students/`.</li><li>**Grade Management:** Handle grade assignment, updates, deletions, and viewing logic.</li><li>**Grade Validation:** Validate 0.0-100.0 score ranges and map them to the correct grading scale.</li><li>**Grade Storage:** Manage grade records inside `sgms_data/grades/`.</li></ul> |
| **Mawada Alexandar** | <ul><li>**Main Menu:** Handle core application routing and navigation.</li><li>**Subject Management:** Perform full CRUD operations for subjects.</li><li>**Subject Validation:** Enforce alphanumeric format for subject codes and integer checks for credit hours.</li><li>**Subject Storage:** Manage records inside `sgms_data/subjects/`.</li><li>**Reports & Statistics:** Generate dynamic reports including Transcripts, Subject Statistics, Top/Failing Students, and the Full Grade Matrix.</li><li>**Data Processing:** Utilize `awk` for floating-point calculations, averages, and GPA point mapping.</li></ul> |
## Additional Features 
* Data Export: Capable of exporting generated reports to `.txt` or `.csv` files.
* Advanced Search: Implements real-time student search via partial name matching utilizing `grep`.
* Weighted GPA: Calculates accurate GPAs by factoring in specific subject credit hours.
