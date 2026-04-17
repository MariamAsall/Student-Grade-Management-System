grade_menu(){
    while true ; do 
    echo "STUDENT MANAGEMENT MENU"
    echo "  1) Assign Grade to Student"
    echo "  2) Update Existing Grade"
    echo "  3) Delete a Grade"
    echo "  4) View Grades by Subject"
    echo "  5) View Grades by Student"
    echo "  6) Back to main menu"

    read -p "Please choose only NUMBERS from (1-6):" choice 

    case $choice in 
        1)
            Assign_Grade;;
        2)
            Update_grade;;
        3)
            delete_grade;;
        4)
            view_grades_subject;;
        5)
            view_grades_student;;
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

