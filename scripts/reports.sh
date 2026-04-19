
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
