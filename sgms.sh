#!/bin/bash

data_dir="sgms_data"
students_dir="${data_dir}/students"
subjects_dir="${data_dir}/subjects"
grade_dir="${data_dir}/grades"


mkdir -p "$students_dir"
mkdir -p "$subjects_dir"
mkdir -p "$grade_dir"

source scripts/students.sh
source scripts/subjects.sh
source scripts/grades.sh
source scripts/reports.sh
source scripts/main_menu.sh

main_menu