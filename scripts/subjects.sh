#! /usr/bin/bash
shopt -s extglob

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

add_subject() {
    while true; do
      echo "ADD NEW SUBJECT"
      while true; do
        read -p "Enter Subject Code 2-5 letters + 2-4 digits, for examble: CS101, MATH203 " code

        if [[ "$code" == "" ]]; then
        echo "Subject code cannot be empty!"
        continue
        fi

        if [[ ! $code =~ ^[A-Za-z]{2,5}[0-9]{2,4}$ ]]; then
            echo "Not right. please write it as the example: CS101 or MATH203"
            continue
        fi


        if [[ -f "sgms_data/subjects/$code.sub" ]]; then
                echo "Subject already exists!"
                continue
        fi
        break 
    done

   while true; do
    read -p "Enter Subject Name: " name

    if [[ "$name" == "" ]]; then
        echo "subject name cannot be empty"
        continue
    fi
    break 
  done


    while true; do
        read -p "Please enter credit hours number between 1 and 6 : " credits
        if [[ $credits =~ ^[1-6]$ ]]; then
            break
        fi
        echo "Credits must be a number between 1 and 6"
    done

    echo "$code" > "sgms_data/subjects/$code.sub"
    echo "$name" >> "sgms_data/subjects/$code.sub"
    echo "$credits" >> "sgms_data/subjects/$code.sub"

    echo "Subject added successfully!"
}

list_subjects() {
    echo " ALL SUBJECTS "

    for file in sgms_data/subjects/*.sub; do
         
        if [[ -f "$file" ]]; then
            cat "$file"
        fi
    done
}
