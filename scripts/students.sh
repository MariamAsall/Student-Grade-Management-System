# ==========================================
# STUDENT MANAGEMENT MODULE
# ==========================================

add_student() {
    echo "--- Add New Student ---"
    read -p "Enter Student ID (Numeric): " id
    
    # Check if ID is empty
    if [ -z "$id" ]; then 
        echo "Error: ID cannot be empty!"
        return 
    fi
    
    # Check if student file already exists
    if [ -f "sgms_data/students/$id.stu" ]; then
        echo "Error: A student with ID $id already exists!"
        return
    fi

    read -p "Enter Student Name: " name
    read -p "Enter Student Email: " email
    read -p "Enter Academic Year (1-6): " year

    # Save to file (One value per line)
    echo "$id" > "sgms_data/students/$id.stu"
    echo "$name" >> "sgms_data/students/$id.stu"
    echo "$email" >> "sgms_data/students/$id.stu"
    echo "$year" >> "sgms_data/students/$id.stu"
    
    echo "Success: Student '$name' added!"
}

list_students() {
    echo "--- List of Students ---"
    
    # Check if the folder is empty
    if [ -z "$(ls -A sgms_data/students/*.stu 2>/dev/null)" ]; then
        echo "No students found in the database."
        return
    fi
    
    # Print Table Header
    printf "%-10s | %-20s | %-25s | %-5s\n" "ID" "Name" "Email" "Year"
    echo "-----------------------------------------------------------------------"
    
    # Loop through every .stu file and print the lines
    for file in sgms_data/students/*.stu; do
        if [ -f "$file" ]; then
            mapfile -t lines < "$file"
            printf "%-10s | %-20s | %-25s | %-5s\n" "${lines[0]}" "${lines[1]}" "${lines[2]}" "${lines[3]}"
        fi
    done
}

update_student() {
    echo "--- Update Student ---"
    read -p "Enter Student ID to update: " id
    
    if [ ! -f "sgms_data/students/$id.stu" ]; then
        echo "Error: Student ID $id not found!"
        return
    fi
    
    # Load current data
    mapfile -t current < "sgms_data/students/$id.stu"
    
    echo "Tip: Press ENTER to keep the current value, or type a new value."
    
    # Prompt for new data, default to old data if input is empty
    read -p "Enter new Name [${current[1]}]: " name
    name=${name:-${current[1]}}
    
    read -p "Enter new Email [${current[2]}]: " email
    email=${email:-${current[2]}}
    
    read -p "Enter new Academic Year [${current[3]}]: " year
    year=${year:-${current[3]}}

    # Overwrite the file with the new data
    echo "$id" > "sgms_data/students/$id.stu"
    echo "$name" >> "sgms_data/students/$id.stu"
    echo "$email" >> "sgms_data/students/$id.stu"
    echo "$year" >> "sgms_data/students/$id.stu"
    
    echo "Success: Student $id updated successfully!"
}