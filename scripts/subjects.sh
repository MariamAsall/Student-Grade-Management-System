#! /usr/bin/bash
shopt -s extglob



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
