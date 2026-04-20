
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

student_transcript() {
    read -p "Enter Student ID: " myid

    if [[ ! -f "sgms_data/students/$myid.stu" ]]; then
        echo "Student not found"
        return
    fi

    echo "TRANSCRIPT for the student $myid"
    total_points=0
    total_credits=0

    for file in sgms_data/grades/*.grd; do
        row=$(grep "^$myid|" "$file")

        if [[ -n "$row" ]]; then
        # basename is a built-in Linux command It look at a long file path and delets the folder part so you only see the file name.It sees the slashes / and deletes everything before the last one.
            subj=$(basename "$file" .grd)
            score=$(echo "$row" | cut -d'|' -f2)
            credits=$(sed -n '3p' "sgms_data/subjects/$subj.sub")

   
            result=$(awk -v s="$score" -v c="$credits" 'BEGIN {
                if (s >= 90) { p=4.0; l="A+" }
                else if (s >= 85) { p=4.0; l="A" }
                else if (s >= 80) { p=3.7; l="A-" }
                else if (s >= 75) { p=3.3; l="B+" }
                else if (s >= 70) { p=3.0; l="B" }
                else if (s >= 65) { p=2.7; l="B-" }
                else if (s >= 60) { p=2.3; l="C+" }
                else if (s >= 55) { p=2.0; l="C" }
                else if (s >= 50) { p=1.7; l="C-" }
                else if (s >= 45) { p=1.0; l="D" }
                else { p=0.0; l="F" }
                
              
                print (p * c) "|" l
            }')

            weighted_points=$(echo "$result" | cut -d'|' -f1)
            letter=$(echo "$result" | cut -d'|' -f2)

            echo "$subj: Score $score ($letter) | Credits $credits"

            total_points=$(awk "BEGIN {print $total_points + $weighted_points}")
            total_credits=$(awk "BEGIN {print $total_credits + $credits}")
        fi
    done

    if [[ $total_credits -gt 0 ]]; then
        gpa=$(awk "BEGIN {printf \"%.2f\", $total_points / $total_credits}")
        echo "CUMULATIVE GPA: $gpa"
    else
        echo "No grades found for this student."
    fi
}

subject_statistics() {
    echo " SUBJECT STATISTICS "
    read -p "Enter Subject Code (e.g., CS101): " subject_code

    grade_file="sgms_data/grades/$subject_code.grd"
    if [[ ! -f "$grade_file" ]]; then
        echo "not found"
        return
    fi

    awk '
    BEGIN {
        FS = "|"
        max = 0
        min = 100
        sum = 0
        count = 0
    }
    {
        score = $2
        sum += score
        count++

        if (score > max) max = score
        if (score < min) min = score
    }
    END {
        if (count > 0) {
            avg = sum / count
            print "Total Students: " count
            print "Highest Score:  " max
            print "Lowest Score:   " min
            printf "Class Average:  %.2f\n", avg
        } else {
            print "No data found in the grade file."
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

show_top_students() {
    echo " TOP STUDENTS BY GPA "
    temp_list="sgms_data/temp_ranking.txt"
    > "$temp_list"

    for stu_file in sgms_data/subjects/*.stu; do
        sid=$(basename "$stu_file" .stu)
        name=$(sed -n '2p' "$stu_file")

        total_pts=0
        total_creds=0

        for grd_file in sgms_data/grades/*.grd; do
            row=$(grep "^$sid|" "$grd_file")
            if [[ -n "$row" ]]; then
                subj=$(basename "$grd_file" .grd)
                score=$(echo "$row" | cut -d'|' -f2)
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

    sort -rn "$temp_list" | head -n 10
    rm "$temp_list"
}

show_failing_students() {
    echo " FAILING STUDENTS REPORT "
    temp_list="sgms_data/failing_temp.txt"
    > "$temp_list"

    for stu_file in sgms_data/students/*.stu; do
        sid=$(basename "$stu_file" .stu)
        name=$(sed -n '2p' "$stu_file")

        total_pts=0
        total_creds=0

        for grd_file in sgms_data/grades/*.grd; do
            row=$(grep "^$sid|" "$grd_file")
            if [[ -n "$row" ]]; then
                subj=$(basename "$grd_file" .grd)
                score=$(echo "$row" | cut -d'|' -f2)
                credits=$(sed -n '3p' "sgms_data/subjects/$subj.sub")

                
                result=$(get_grade_data "$score" "$credits")
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

    rm "$temp_list"
}