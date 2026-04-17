
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