main_menu() {
    while true; do
        echo "======================================"
        echo "  STUDENT GRADE MANAGEMENT SYSTEM    "
        echo "======================================"
        echo "     1) Manage Students"
        echo "     2) Manage Subjects"
        echo "     3) Manage Grades"
        echo "     4) Reports & Statistics"
        echo "     5) Exit"

        read -p "Choose an option (1-5): " choice

        case $choice in
            1) student_menu ;;
            2) subject_menu ;;
            3) grade_menu ;;
            4) reports_menu ;;
            5) echo "Exiting SGMS... Goodbye!"; exit 0 ;;
            "") echo "EMPTY, please enter a number." ;;
            *) echo "Invalid choice, please try again." ;;
        esac
    done
}