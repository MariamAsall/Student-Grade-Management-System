
main_menu() {
    while true; do

        echo "STUDENT GRADE MANAGEMENT SYSTEM"
        echo "     1) Manage Students"
        echo "     2) Manage Subjects"
        echo "     3) Manage Grades"
        echo "     4) Reports & Statistics"
        echo "     5) Exit"

        read -p "Please choose only NUMBERS from (1-5): " choice

        case $choice in
            1)
                student_menu
                ;;
            2)
                subject_menu
                ;;
            3)
                grade_menu
                ;;
            4)
                reports_menu
                ;;
            5)
                echo "Exiting bye bye..."
                exit 0
                ;;
            "")
                echo "EMPTY, Please enter a number between 1 and 5."
                ;;
            *)
                echo "Something is wrong! Please enter a number between 1 and 5."
                ;;
        esac
    done
}


