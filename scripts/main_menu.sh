
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

subject_menu() {
    while true; do

        echo "SUBJECT MANAGEMENT MENU"
        echo "     1) Add Subject"
        echo "     2) List Subjects"
        echo "     3) Update Subject"
        echo "     4) Delete Subject"
        echo "     5) Back to Main Menu"

        read -p "Please choose only NUMBERS from (1-5): " choice

        case $choice in
            1)
                add_subject
                ;;
            2)
                list_subjects
                ;;
            3)
                update_subject
                ;;
            4)
                delete_subject
                ;;
            5)
                echo "Back to the main menu..."
                return
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

reports_menu() {
    while true; do

        echo "REPORTS & STATISTICS MENU"
        echo "     1) Student Transcript + GPA"
        echo "     2) Subject Statistics"
        echo "     3) Top Students by GPA"
        echo "     4) Failing Students Report"
        echo "     5) Full Grade Matrix"
        echo "     6) Back to the main menu"

        read -p "Please choose only NUMBERS from (1-6): " choice

        case $choice in
            1)
                show_transcript
                ;;
            2)
                subject_stats
                ;;
            3)
                top_students
                ;;
            4)
                failing_report
                ;;
            5)
                grade_matrix
                ;;
            6)
                echo "Back to the main menu..."
                return
                ;;
            "")
                echo "EMPTY, Please enter a number between 1 and 6."
                ;;
            *)
                echo "Something is wrong! Please enter a number between 1 and 6."
                ;;
        esac
    done
}