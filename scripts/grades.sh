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
    awk -v s="$score" '
    BEGIN {
        if (s >= 90.0 && s <= 100.0) 
            print "A+"
        else if (s >= 85.0 && s < 90.0) 
            print "A"
        else if (s >= 80.0 && s < 85.0) 
            print "A-"
        else if (s >= 75.0 && s < 80.0) 
            print "B+"
        else if (s >= 70.0 && s < 75.0) 
            print "B"
        else if (s >= 65.0 && s < 70.0) 
            print "B-"
        else if (s >= 60.0 && s < 65.0) 
            print "C+"
        else if (s >= 55.0 && s < 60.0) 
            print "C"
        else if (s >= 50.0 && s < 55.0) 
            print "C-"
        else if (s >= 45.0 && s < 50.0) 
            print "D"
        else if (s >= 0.0 && s < 45.0) 
            print "F"
        else 
            print "INVALID"
    }'
}

get_gpa_points(){
    local score=$1
    awk -v s="$score" '
    BEGIN {
        if (s >= 85.0 && s <= 100.0)
             print "4.0" 
        else if (s >= 80.0 && s < 85.0) 
            print "3.7"
        else if (s >= 75.0 && s < 80.0) 
            print "3.3"
        else if (s >= 70.0 && s < 75.0)
             print "3.0"
        else if (s >= 65.0 && s < 70.0)
             print "2.7"
        else if (s >= 60.0 && s < 65.0) 
            print "2.3"
        else if (s >= 55.0 && s < 60.0) 
            print "2.0"
        else if (s >= 50.0 && s < 55.0) 
            print "1.7"
        else if (s >= 45.0 && s < 50.0) 
            print "1.0"
        else if (s >= 0.0 && s < 45.0) 
            print "0.0"
        else 
            print "INVALID"
    }'
}

Assign_Grade(){
    echo "====== Assigning GRADE to STUDENT ======"
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
            continue 
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

Update_grade(){
    echo "====== UPDATE EXISTING GRADE ======"
    while true; do 
        read -p "Enter the Code of subject ypu want to update: " subject
        grades_file=sgms_data/grades/${subject}.grd
        if [[ ! -f "$grades_file" ]]; then
            echo "Subject doesn't exist. Please Try again"
        else 
            break 
        fi
    done 

    while true; do 
        read -p "Enter Student ID you want to update its grade: " student_id 
        line=$(grep "^${student_id} |" "$grades_file")
        if [[ -z "$line" ]]; then
            echo "No grade found for Student $student_id in this subject."
            return
        else
            current_score=$(echo "$line" | cut -d'|' -f2)
            current_grade=$(echo "$line" | cut -d'|' -f3)

            echo "-----------------------------------------------------------"
            echo "Student Found! Current Score:$current_score" $current_grade
            echo "------------------------------------------------------------"
            break 
        fi
    done

    while true; do
        read -p "Enter grade score (0.0 - 100.0): " score
        if [[ ! "$score" =~ ^[0-9]+(\.[0-9]+)?$ ]];
            then 
            echo "Score is Invalid , must be a numeric between 0.0 and 100 please try again"
            continue 
        fi

        letter=$(get_letter_grade "$score")
        if [[ "$letter" == "INVALID" ]]; then
            echo "Score must be between 0.0 and 100.0. Please try again."
        else
            break
        fi
    done 

    sed -i "s/^${student_id} |.*/${student_id} | ${score} | ${letter}/"  "$grades_file"
    echo "Successfully Grade updated to $letter ($score) for Student $student_id in $subject."

}

delete_grade(){
    echo "====== DELETE EXISTING GRADE ======"
    while true; do 
        read -p "Enter Subject Code: " subject
        grades_file="sgms_data/grades/${subject}.grd"
        
        if [[ ! -f "$grades_file" ]]; then
            echo "Subject doesn't exist. Please try again."
        else 
            break 
        fi
    done 

    while true; do 
        read -p "Enter Student ID to delete their grade: " student_id 
        
        if ! grep -q "^${student_id} |" "$grades_file"; then
            echo "No grade found for Student $student_id in this subject."
            return
        else
            sed -i "/^${student_id} |/d" "$grades_file"
            echo "Successfully deleted grade for Student $student_id from $subject."
            break 
        fi
    done
}

view_grades_subject(){
    echo "====== VIEW GRADES BY SUBJECT ======"
    while true; do 
        read -p "Enter Subject Code to view grades: " subject
        subject=$(echo "$subject" | tr '[:lower:]' '[:upper:]')
        grades_file="sgms_data/grades/${subject}.grd"
        
        if [[ ! -f "$grades_file" ]]; then
            echo "Error: Subject doesn't exist or has no grades recorded yet."
            return 
        else 
            break 
        fi
    done 

    echo "---------------------------------------------------------"
    echo " Transcript for Subject: $subject"
    echo "---------------------------------------------------------"
    echo "Student ID | Score | Letter Grade"
    echo "---------------------------------------------------------"
    
    cat "$grades_file"
    
    echo "---------------------------------------------------------"
    echo "End of records."
}

view_grades_student(){
    echo "====== VIEW GRADES BY STUDENT ======"
    while true; do 
        read -p "Enter Student ID to view their grades: " student_id 
        if [[ ! -f "sgms_data/students/${student_id}.stu" ]]; then
            echo "This student doesn't exist. Please try again."
            continue
        else 
            break 
        fi
    done 

    echo "---------------------------------------------------------"
    echo " Grades for Student ID: $student_id"
    echo "---------------------------------------------------------"
    echo "Subject Code | Score | Letter Grade"
    echo "---------------------------------------------------------"

    found_grades=false

    for file in sgms_data/grades/*.grd; do
        if [[ -f "$file" ]]; then
            line=$(grep "^${student_id} |" "$file")
            
            if [[ -n "$line" ]]; then
                found_grades=true
                
                subject_code=$(basename "$file" .grd)
                
                score=$(echo "$line" | cut -d'|' -f2)
                letter=$(echo "$line" | cut -d'|' -f3)
                echo "$subject_code | $score | $letter"
            fi
        fi
    done

    
    if [[ "$found_grades" == false ]]; then
        echo "No grades recorded for Student $student_id yet."
    fi

}