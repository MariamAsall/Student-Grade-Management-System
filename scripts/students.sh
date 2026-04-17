student_menu(){
    while true ; do 
    echo "STUDENT MANAGEMENT MENU"
    echo "  1) Add Student"
    echo "  2) List Student"
    echo "  3) Update Student"
    echo "  4) Delete Student"
    echo "  5) Back to main menu"

    read -p "Please choose only NUMBERS from (1-5):" choice 

    case $choice in 
        1)
            add_student;;
        2)
            list_student;;
        3)
            update_student;;
        4)
            delete_student;;
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

