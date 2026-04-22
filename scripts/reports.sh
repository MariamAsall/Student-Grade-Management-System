
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

show_transcript() {
    read -p "Enter Student ID: " myid

    if [[ ! -f "${students_dir}/${myid}.stu" ]]; then
        echo "Error: Student '$myid' not found."
        return
    fi

    echo "---------------------------------------------------------"
    echo "TRANSCRIPT FOR STUDENT: $myid"
    echo "---------------------------------------------------------"
    total_points=0
    total_credits=0


    for file in sgms_data/grades/*.grd; do
        row=$(grep "^$myid |" "$file")

        if [[ -n "$row" ]]; then
         clean_row=$(echo "$row" | tr -d ' ')
        # basename is a built-in Linux command It look at a long file path and delets the folder part so you only see the file name.It sees the slashes / and deletes everything before the last one.

    for file in "${grade_dir}"/*.grd; do
        [[ -e "$file" ]] || continue
        row=$(grep "^$myid |" "$file")

        if [[ -n "$row" ]]; then

            subj=$(basename "$file" .grd)
            score=$(echo "$row" | cut -d'|' -f2 | xargs)
            
            credits=$(sed -n '3p' "${subjects_dir}/${subj}.sub")

            result=$(awk -v s="$score" -v c="$credits" 'BEGIN {
                if (s >= 85) p=4.0; else if (s >= 80) p=3.7;
                else if (s >= 75) p=3.3; else if (s >= 70) p=3.0;
                else if (s >= 65) p=2.7; else if (s >= 60) p=2.3;
                else if (s >= 55) p=2.0; else if (s >= 50) p=1.7;
                else if (s >= 45) p=1.0; else p=0.0;
                
                print (p * c)
            }')

            letter=$(echo "$row" | cut -d'|' -f3 | xargs)
            echo "$subj: Score $score ($letter) | Credits: $credits"

            total_points=$(awk "BEGIN {print $total_points + $result}")
            total_credits=$(awk "BEGIN {print $total_credits + $credits}")
        fi
    done

    if [[ $total_credits -gt 0 ]]; then
        gpa=$(awk "BEGIN {printf \"%.2f\", $total_points / $total_credits}")
        echo "---------------------------------------------------------"
        echo "CUMULATIVE GPA: $gpa"
        echo "---------------------------------------------------------"
    else
        echo "No grades found for this student."
    fi
}

subject_stats() {
    echo "--- SUBJECT STATISTICS ---"
    read -p "Enter Subject Code: " subject_code
    subject_code=$(echo "$subject_code" | tr '[:lower:]' '[:upper:]')

    grade_file="${grade_dir}/${subject_code}.grd"
    if [[ ! -f "$grade_file" ]]; then
        echo "Error: Grade file for $subject_code not found."
        return
    fi

    awk '
    BEGIN { FS = "|"; max = 0; min = 100; sum = 0; count = 0 }
    {
        score = $2; sum += score; count++
        if (score > max) max = score
        if (score < min) min = score
    }
    END {
        if (count > 0) {
            printf "Total Students: %d\n", count
            printf "Highest Score:  %.1f\n", max
            printf "Lowest Score:   %.1f\n", min
            printf "Class Average:  %.2f\n", sum / count
        } else {
            print "No data found."
        }
    }' "$grade_file"
}


get_weighted_points() {
    local score=$1
    local credits=$2

    awk -v s="$score" -v c="$credits" 'BEGIN {
        if (s >= 90) p=4.0; else if (s >= 85) p=4.0;
        else if (s >= 80) p=3.7; else if (s >= 75) p=3.3;
        else if (s >= 70) p=3.0; else if (s >= 65) p=2.7;
        else if (s >= 60) p=2.3; else if (s >= 55) p=2.0;
        else if (s >= 50) p=1.7; else if (s >= 45) p=1.0;
        else p=0.0;
        print (p * c)
    }'
}

top_students() {
    echo " TOP STUDENTS BY GPA "
   local temp_list=$(mktemp)
    for stu_file in sgms_data/students/*.stu; do
        sid=$(basename "$stu_file" .stu)
        name=$(sed -n '2p' "$stu_file")

        total_pts=0
        total_creds=0

        for grd_file in sgms_data/grades/*.grd; do
            row=$(grep "^$sid |" "$grd_file")
            if [[ -n "$row" ]]; then
                subj=$(basename "$grd_file" .grd)
                score=$(echo "$row" | cut -d'|' -f2 | tr -d ' ')
                credits=$(sed -n '3p' "sgms_data/subjects/$subj.sub")

               
                wp=$(get_weighted_points "$score" "$credits")

                total_pts=$(awk "BEGIN {print $total_pts + $wp}")
                total_creds=$((total_creds + credits))
            fi
        done

        if [[ $total_creds -gt 0 ]]; then
            gpa=$(awk "BEGIN {printf \"%.2f\", $total_pts / $total_creds}")
            echo "$gpa | $name ($sid)" >> "$temp_list"
        fi
    done

    
    sort -t'|' -k1,1rn "$temp_list" | head -n 10
    rm -f "$temp_list"
}

failing_students() {
    echo " FAILING STUDENTS REPORT "
    local temp_list=$(mktemp)
    
    for stu_file in sgms_data/students/*.stu; do
        sid=$(basename "$stu_file" .stu)
        name=$(sed -n '2p' "$stu_file")

        total_pts=0
        total_creds=0

        for grd_file in sgms_data/grades/*.grd; do
            row=$(grep "^$sid |" "$grd_file")
            if [[ -n "$row" ]]; then
                subj=$(basename "$grd_file" .grd)
                score=$(echo "$row" | cut -d'|' -f2 | tr -d ' ')
                credits=$(sed -n '3p' "sgms_data/subjects/$subj.sub")

                
                result=$(get_weighted_points "$score" "$credits")
                wp=$(echo "$result" | cut -d'|' -f1)

                total_pts=$(awk "BEGIN {print $total_pts + $wp}")
                total_creds=$((total_creds + credits))
            fi
        done

        if [[ $total_creds -gt 0 ]]; then
            gpa=$(awk "BEGIN {printf \"%.2f\", $total_pts / $total_creds}")
            echo "$gpa | $name ($sid)" >> "$temp_list"
        fi
    done

    echo "GPA  | NAME (ID)"
    awk -F'|' '$1 < 2.0 {print $0}' "$temp_list" | sort -n

    rm -f "$temp_list"
}


get_student_gpa() {
    local sid=$1
    local t_pts=0
    local t_creds=0


    for grd_file in sgms_data/grades/*.grd; do
        row=$(grep "^$sid |" "$grd_file")
        if [[ -n "$row" ]]; then
            subj=$(basename "$grd_file" .grd)
            score=$(echo "$row" | cut -d'|' -f2 | tr -d ' ')
            credits=$(sed -n '3p' "sgms_data/subjects/$subj.sub")


    for grd_file in "${grade_dir}"/*.grd; do
        [[ -e "$grd_file" ]] || continue
        row=$(grep "^$sid |" "$grd_file")
        if [[ -n "$row" ]]; then
            subj=$(basename "$grd_file" .grd)
            score=$(echo "$row" | cut -d'|' -f2 | xargs)
            creds=$(sed -n '3p' "${subjects_dir}/${subj}.sub")

            
            pts=$(awk -v s="$score" -v c="$creds" 'BEGIN {
                if (s >= 85) p=4.0; else if (s >= 80) p=3.7;
                else if (s >= 75) p=3.3; else if (s >= 70) p=3.0;
                else if (s >= 65) p=2.7; else if (s >= 60) p=2.3;
                else if (s >= 55) p=2.0; else if (s >= 50) p=1.7;
                else if (s >= 45) p=1.0; else p=0.0;
                print (p * c)
            }')
            t_pts=$(awk "BEGIN {print $t_pts + $pts}")
            t_creds=$((t_creds + creds))
        fi
    done

    if [[ $t_creds -gt 0 ]]; then
        awk "BEGIN {printf \"%.2f\", $t_pts / $t_creds}"
    else
        echo "0.00"
    fi
}

top_students() {
    echo "--- TOP 10 STUDENTS BY GPA ---"
    temp_list="${data_dir}/temp_ranking.txt"
    > "$temp_list"

    for stu_file in "${students_dir}"/*.stu; do
        [[ -e "$stu_file" ]] || continue
        sid=$(basename "$stu_file" .stu)
        name=$(sed -n '2p' "$stu_file")
        gpa_val=$(get_student_gpa "$sid")
        
        if (( $(awk "BEGIN {print ($gpa_val > 0)}") )); then
            echo "$gpa_val | $name ($sid)" >> "$temp_list"
        fi
    done

    sort -rn "$temp_list" | head -n 10
    rm -f "$temp_list"
}

failing_report() {
    echo "--- FAILING STUDENTS (GPA < 2.0) ---"
    for stu_file in "${students_dir}"/*.stu; do
        [[ -e "$stu_file" ]] || continue
        sid=$(basename "$stu_file" .stu)
        name=$(sed -n '2p' "$stu_file")
        gpa_val=$(get_student_gpa "$sid")

        if (( $(awk "BEGIN {print ($gpa_val < 2.0 && $gpa_val > 0)}") )); then
            echo "GPA: $gpa_val | $name ($sid)"
        fi
    done
}

grade_matrix() {
    echo "--- FULL GRADE MATRIX ---"
    printf "%-15s" "STUDENT"
    for sub_file in "${subjects_dir}"/*.sub; do
        [[ -e "$sub_file" ]] || continue
        printf "%-10s" "$(basename "$sub_file" .sub)"
    done
    printf "%-10s\n" "GPA"
    echo "-----------------------------------------------------------------------"

    for stu_file in "${students_dir}"/*.stu; do
        [[ -e "$stu_file" ]] || continue
        sid=$(basename "$stu_file" .stu)
        sname=$(sed -n '2p' "$stu_file")
        printf "%-15s" "$sname"


        printf "%-10s" "$sname" 

        
        for sub_file in sgms_data/subjects/*.sub; do
            subj_name=$(basename "$sub_file" .sub)
            score=$(grep "^$sid |" "sgms_data/grades/$subj_name.grd" 2>/dev/null | cut -d'|' -f2 | tr -d ' ')


        for sub_file in "${subjects_dir}"/*.sub; do
            [[ -e "$sub_file" ]] || continue
            s_code=$(basename "$sub_file" .sub)
            score=$(grep "^$sid |" "${grade_dir}/${s_code}.grd" 2>/dev/null | cut -d'|' -f2 | xargs)
            

            if [[ -n "$score" ]]; then
                printf "%-10s" "$score"
            else
                printf "%-10s" "-"
            fi
        done
        printf "%-10s\n" "$(get_student_gpa "$sid")"
    done
}