#!/bin/bash

#SBATCH --account=utu
#SBATCH --partition=lonepeak
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=19:00:00
#SBATCH -o out.matrixify-%j.txt-%N
#SBATCH -e err.matrixify-%j.txt-%N

# Author: Baylee Christensen
# Date: 09/13/2024
# Description: First, need to find out which lizards are assigned to which tissue type. Then, we output 3 matrixes containing a specific structure referenced in MeetingNotes.txt.  
# Usage for cmd line: 
# Usage for sbatch: 
