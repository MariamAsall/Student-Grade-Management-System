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


get_letter_grade() {
    echo "$1" | awk '{
        if ($1 >= 90.0 && $1 <= 100.0) 
            print "A+"
        else if ($1 >= 85.0 && $1 < 90.0) 
            print "A"
        else if ($1 >= 80.0 && $1 < 85.0) 
            print "A-"
        else if ($1 >= 75.0 && $1 < 80.0) 
            print "B+"
        else if ($1 >= 70.0 && $1 < 75.0) 
            print "B"
        else if ($1 >= 65.0 && $1 < 70.0) 
            print "B-"
        else if ($1 >= 60.0 && $1 < 65.0) 
            print "C+"
        else if ($1 >= 55.0 && $1 < 60.0) 
            print "C"
        else if ($1 >= 50.0 && $1 < 55.0) 
            print "C-"
        else if ($1 >= 45.0 && $1 < 50.0) 
            print "D"
        else if ($1 >= 0.0 && $1 < 45.0) 
            print "F"
        else 
            print "INVALID"
    }'
}

get_gpa_points() {
    echo "$1" | awk '{
        if ($1 >= 85.0 && $1 <= 100.0)
             print "4.0" 
        else if ($1 >= 80.0 && $1 < 85.0) 
            print "3.7"
        else if ($1 >= 75.0 && $1 < 80.0) 
            print "3.3"
        else if ($1 >= 70.0 && $1 < 75.0)
             print "3.0"
        else if ($1 >= 65.0 && $1 < 70.0)
             print "2.7"
        else if ($1 >= 60.0 && $1 < 65.0) 
            print "2.3"
        else if ($1 >= 55.0 && $1 < 60.0) 
            print "2.0"
        else if ($1 >= 50.0 && $1 < 55.0) 
            print "1.7"
        else if ($1 >= 45.0 && $1 < 50.0) 
            print "1.0"
        else if ($1 >= 0.0 && $1 < 45.0) 
            print "0.0"
        else 
            print "INVALID"
    }'
}

Assign_Grade(){
    echo "Assigning Grade to Student"
    while true; do
        read -p "Enter Student ID: " student_id
        if [[ ! -f "${students_dir}/${student_id}.stu" ]] ;
        then 
            echo "This student doesn't exist."
        else
            break
        fi 
    done 

    while true; do 
        read -p "Enter Subject Name: " subject
            if [[ ! -f "${subjects_dir}/${subject}.sub" ]]; then
                echo "Subject Not Found, Enter another one."
        else
            break
        fi
    done 

    grades_file="${grade_dir}/${subject}.grd"
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
    echo "Updating an Existing Grade"
    while true; do 
        read -p "Enter the Code of subject ypu want to update: " subject
        grades_file=${grade_dir}/${subject}.grd
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
            echo "No grade found for this Student."
            return
        else
            current_score=$(echo "$line" | cut -d'|' -f2)
            current_grade=$(echo "$line" | cut -d'|' -f3)

            echo "-----------------------------------------------------------"
            echo "Student Found Current Score:$current_score" $current_grade
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
    echo "Deleting an Existing Grade"
    while true; do 
        read -p "Enter Subject Code: " subject
        grades_file="${grade_dir}/${subject}.grd"
        
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
    echo "Viewing Grades by Subjects"
    while true; do 
        read -p "Enter Subject Code to view grades: " subject
        grades_file="${grade_dir}/${subject}.grd"
        
        if [[ ! -f "$grades_file" ]]; then
            echo "Subject doesn't exist or has no grades yet."
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
    echo "Viewing Grades by Students"
    while true; do 
        read -p "Enter Student ID to view their grades: " student_id 
        if [[ ! -f "${students_dir}/${student_id}.stu" ]]; then
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

    found_grades=0

    for file in "${grade_dir}"/*; do
        if [[ -f "$file" ]]; then
            line=$(grep "^${student_id} |" "$file")
            
            if [[ -n "$line" ]]; then
                # FIXED: Change to 1 when found
                found_grades=1
                
                subject_code=$(basename "$file" .grd)
                
                score=$(echo "$line" | cut -d'|' -f2)
                letter=$(echo "$line" | cut -d'|' -f3)
                echo "$subject_code | $score | $letter"
            fi
        fi
    done

    if [[ $found_grades -eq 0 ]]; then
        echo "No grades recorded for Student $student_id yet."
    fi
}