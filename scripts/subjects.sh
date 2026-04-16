# ==========================================
# SUBJECT MANAGEMENT MODULE
# ==========================================

add_subject() {
    echo "--- Add New Subject ---"
    read -p "Enter Subject Code (e.g., CS101): " code
    
    # Convert code to uppercase automatically to prevent duplicates like cs101 vs CS101
    code=$(echo "$code" | tr '[:lower:]' '[:upper:]')
    
    if [ -z "$code" ]; then 
        echo "Error: Subject Code cannot be empty!"
        return 
    fi

    if [ -f "sgms_data/subjects/$code.sub" ]; then
        echo "Error: Subject $code already exists!"
        return
    fi

    read -p "Enter Subject Name: " name
    read -p "Enter Credit Hours (1-6): " credits

    echo "$code" > "sgms_data/subjects/$code.sub"
    echo "$name" >> "sgms_data/subjects/$code.sub"
    echo "$credits" >> "sgms_data/subjects/$code.sub"
    
    echo "Success: Subject '$code' added!"
}

list_subjects() {
    echo "--- List of Subjects ---"
    
    if [ -z "$(ls -A sgms_data/subjects/*.sub 2>/dev/null)" ]; then
        echo "No subjects found in the database."
        return
    fi
    
    printf "%-10s | %-30s | %-7s\n" "Code" "Name" "Credits"
    echo "------------------------------------------------------"
    
    for file in sgms_data/subjects/*.sub; do
        if [ -f "$file" ]; then
            mapfile -t lines < "$file"
            printf "%-10s | %-30s | %-7s\n" "${lines[0]}" "${lines[1]}" "${lines[2]}"
        fi
    done
}

update_subject() {
    echo "--- Update Subject ---"
    read -p "Enter Subject Code to update: " code
    code=$(echo "$code" | tr '[:lower:]' '[:upper:]')
    
    if [ ! -f "sgms_data/subjects/$code.sub" ]; then
        echo "Error: Subject Code $code not found!"
        return
    fi
    
    mapfile -t current < "sgms_data/subjects/$code.sub"
    
    echo "Tip: Press ENTER to keep the current value, or type a new value."
    
    read -p "Enter new Name [${current[1]}]: " name
    name=${name:-${current[1]}}
    
    read -p "Enter new Credits [${current[2]}]: " credits
    credits=${credits:-${current[2]}}

    echo "$code" > "sgms_data/subjects/$code.sub"
    echo "$name" >> "sgms_data/subjects/$code.sub"
    echo "$credits" >> "sgms_data/subjects/$code.sub"
    
    echo "Success: Subject $code updated successfully!"
}