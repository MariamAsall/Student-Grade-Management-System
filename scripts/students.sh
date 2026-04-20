student_menu(){
    while true ; do 
    echo "STUDENT MANAGEMENT MENU"
    echo "  1) Add Student"
    echo "  2) List Student"
    echo "  3) Search Student "
    echo "  4) Update Student"
    echo "  5) Delete Student"
    echo "  6) Back to main menu"

    read -p "Please choose only NUMBERS from (1-6):" choice 

    case $choice in 
        1)
            add_student;;
        2)
            list_student;;
        3)
            search_student;;
        4)
            update_student;;
        5)
            delete_student;;
        6)
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
    echo "====== ADDING NEW STUDENT ======"
    while true; do 
        read -p "Enter student ID:" student_id
    filepath="${students_dir}/${student_id}.stu"
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
    files=$(ls "${students_dir}"/*.stu 2>/dev/null)

    if [[ -z "$files" ]]
    then
        echo "No students to list."
    else
        ls $files
    fi
}


search_student(){
    echo "====== SEARCH STUDENT ======"
    while true; do
        read -p "Enter the student's name to search: " search_name
        
        if [[ -z "$search_name" ]]; then
            echo "Search cannot be empty. Please try again."
            continue
        else
            break
        fi
    done

    echo "--- Search Results ---"
    
    for file in $(grep -il "$search_name" "${students_dir}"/*.stu 2>/dev/null); do
        {
            read -r id
            read -r name
            read -r email
            read -r year
        } < "$file"
        
        echo "ID: $id | Name: $name | Year: $year | Email: $email"
    done
}


update_student(){
    echo "====== Updating Students Data ======"
    while true; do
        read -p "Enter student ID you want to Update:" sid
        filepath="${students_dir}/${sid}.stu"
        if [[ -z "$sid" ]]
            then
            echo "ID is empty , please enter an ID" 
        elif [[ ! -f "$filepath" ]]
            then 
            echo "ID not Found , Enter Existing ID."
        else
            {
                read -r current_id
                read -r current_name
                read -r current_email
                read -r current_year
            } < "$filepath"

            echo "What would you like to update?"
            echo "1) Name"
            echo "2) Email"
            echo "3) Year"
            read -p "Enter your choice (1-3): " choice

            case $choice in 
                1)
                    while true; do 
                        read -p "Enter new student name: " current_name
                        if [[ -z "$current_name" ]]
                        then 
                            echo "Name is empty, please enter a name!"
                        else 
                            break
                        fi
                    done
                    ;; 
                2)
                    while true; do 
                        read -p "Enter new student email: " current_email
                        if [[ -z "$current_email" ]]
                        then 
                            echo "Email is empty, please enter a valid email!"
                        elif [[ ! "$current_email" =~ ^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+$ ]]
                        then
                            echo "Invalid Format. Email must contain @ and a domain dot."
                        else 
                            break
                        fi
                    done
                    ;;
                3) 
                    while true; do
                        read -p "Enter student year:"  current_year
                        if [[ ! "$current_year" =~ ^[1-6]$ ]]
                                then 
                                echo "Invalid year. Please enter a number from 1 to 6"
                        else 
                            break
                        fi
                    done
                    ;;
                *)
                    echo "Invalid choice! choose a number from (1-3)"
                    return 
                    ;;
            esac

            echo "$current_id" > "$filepath"
            echo "$current_name" >> "$filepath"
            echo "$current_email" >> "$filepath"
            echo "$current_year" >> "$filepath"

            echo "Student $sid updated successfully"
            break
        fi
    done
}

delete_student(){
    echo "====== DELETE STUDENT ======"
    while true; do 
        read -p "Enter Student you want to delete:" std
        filepath="${students_dir}/${std}.stu"

        if [[ -z "$std" ]]
        then
            echo "ID cannot be empty , please enter an ID" 
        elif [[ -f "$filepath" ]]
        then 
            rm "$filepath" 
            echo "Student Deleted Succussfully!"
            break
        else
            echo "No Student Found with this ID."
            break
        fi
    done
}