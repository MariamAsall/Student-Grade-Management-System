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


add_student(){
    echo "====== ADDING A STUDENT ======"
    while true; do 
        read -p "Enter student ID:" student_id
        filepath="sgms_data/students/${student_id}.stu"

        if [[ ! $student_id =~ ^[0-9]{1,10}$ ]]
        then 
            echo "Invalid ID , Try again! "
        elif [[ -f "$filepath" ]]
        then
            echo "ID already exist, enter new one"
        else 
            break
        fi
    done
    
    while true; do 
        read -p "Enter student name:"  name
        if [[ -z "$name" ]]
        then 
            echo "Name is empty , please enter a name!"
        else 
            break
        fi
    done

    while true; do 
    read -p "Enter student eamil:" email
    if [[ -z "$email" ]]
    then 
        echo "Email is empty , please enter a valid email!"
    
    elif [[ ! "$email" =~ ^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+$ ]]
    then
        echo "Invalid Format. Email must contain @ and a domain dot."
    else 
        break
    fi
    done

    while true; do 
    read -p "Enter student year:"  year
    if [[ ! "$year" =~ ^[1-6]$ ]]
            then 
            echo "Invalid year. Please enter a number from 1 to 6"
    else 
        break
    fi
    done
    
    echo "$student_id" > "$filepath"
    echo "$name" >> "$filepath"
    echo "$email" >> "$filepath"
    echo "$year" >> "$filepath"
}



list_student(){
    echo "====== STUDENTS LIST ======"
    files=$(ls sgms_data/students/*.stu 2>/dev/null)

    if [[ -z "$files" ]]
    then
        echo "DB Empty No students to list."
    else
        for std in $files
            do 
               cat "$std"
            done
    fi
}