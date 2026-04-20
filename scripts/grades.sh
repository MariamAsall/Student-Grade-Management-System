grade_menu(){
    while true ; do 
    echo "GRADE MANAGEMENT MENU"
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


get_letter_grade(){
    local score=$1
    awk -v sq="$score" '
    BEGIN {
        if (sq >= 90.0 && sq <= 100.0) 
            print "A+"
        else if (sq >= 85.0 && sq < 90.0) 
            print "A"
        else if (sq >= 80.0 && sq < 85.0) 
            print "A-"
        else if (sq >= 75.0 && sq < 80.0) 
            print "B+"
        else if (sq >= 70.0 && sq < 75.0) 
            print "B"
        else if (sq >= 65.0 && sq < 70.0) 
            print "B-"
        else if (sq >= 60.0 && sq < 65.0) 
            print "C+"
        else if (sq >= 55.0 && sq < 60.0) 
            print "C"
        else if (sq >= 50.0 && sq < 55.0) 
            print "C-"
        else if (sq >= 45.0 && sq < 50.0) 
            print "D"
        else if (sq >= 0.0 && sq < 45.0) 
            print "F"
        else 
            print "INVALID"
    }'
}

get_gpa_points(){
    local score=$1
    awk -v sq="$score" '
    BEGIN {
        if (sq >= 85.0 && sq <= 100.0)
             print "4.0" 
        else if (sq >= 80.0 && sq < 85.0) 
            print "3.7"
        else if (sq >= 75.0 && sq < 80.0) 
            print "3.3"
        else if (sq >= 70.0 && sq < 75.0)
             print "3.0"
        else if (sq >= 65.0 && sq < 70.0)
             print "2.7"
        else if (sq >= 60.0 && sq < 65.0) 
            print "2.3"
        else if (sq >= 55.0 && sq < 60.0) 
            print "2.0"
        else if (sq >= 50.0 && sq < 55.0) 
            print "1.7"
        else if (sq >= 45.0 && sq < 50.0) 
            print "1.0"
        else if (sq >= 0.0 && sq < 45.0) 
            print "0.0"
        else 
            print "INVALID"
    }'
}

Assign_Grade(){
    while true; do
        read -p "Enter Student ID: " student_id
        if [[ ! -f "sgms_data/students/${student_id}.stu" ]] ;
        then 
            echo "This student doesn't exist."
        else
            break
        fi 
    done 

    while true; do 
        read -p "Enter Subject Name: " subject
            if [[ ! -f "sgms_data/subjects/${subject}.sub" ]]; then
                echo "Subject Not Found! Enter another one."
        else
            break
        fi
    done 

    grades_file="sgms_data/grades/${subject}.grd"
        if [[ -f "$grades_file" ]] && grep -q "^${student_id} |" "$grades_file"; then
            echo "Student already has a grade for this subject."
            return
        fi
    while true; do
        read -p "Enter grade score (0.0 - 100.0): " score
        if [[ ! "$score" =~ ^[0-9]+(\.[0-9]+)?$ ]];
            then 
            echo "Score is Invalid , must be a numeric between 0.0 and 100 please try again"
        fi

        letter=$(get_letter_grade "$score")
        if [[ "$letter" == "INVALID" ]]; then
            echo "Score must be between 0.0 and 100.0. Please try again."
        else
            break
        fi
    done 

    echo "${student_id} | ${score} | ${letter}" >> "$grades_file"
    echo "Grade $letter ($score) assigned to $student_id for $subject successfully!"
}