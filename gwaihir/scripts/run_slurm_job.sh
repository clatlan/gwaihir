#!/bin/bash

# Parse parameters
PARAMS=""

while (( "$#" )); do
  # echo $1
  case "$1" in
    -r|--reconstruct)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        reconstruct=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;

    -p|--path)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        path=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;

    -m|--modes)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        modes=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;

    -u|--username)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        username=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;

    -f|--filtering)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        filtering=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;

    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;

    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;

  esac
done

echo 
echo "################################################################################################"
if [[ -z $reconstruct ]]; then # Check if empty
    reconstruct="terminal"
    echo "Defaulted reconstruct to terminal, assign with e.g.: -r gui, possibilites are gui, terminal, false"
else
    echo "Reconstruct: "$reconstruct
fi

if [[ -z $username ]]; then # Check if empty
    username="simonne"
    echo "Defaulted username to simonne, assign with e.g.: -u tombombadil"
else
    echo "Username: "$username
fi

if [[ -z $path ]]; then # Check if empty
    path=$(pwd)
    echo "Defaulted path to data to cwd, assign with e.g.: -p gna/gna/gna/"
else
    echo "Path to data: "$path
fi

if [[ -z $modes ]]; then # Check if empty
    modes=false
    echo "Defaulted modes decomposition to false, assign with e.g.: -m true"
else
    echo "Modes: "$modes
fi

if [[ -z $filtering ]]; then # Check if empty
    filtering=false
    echo "Defaulted filtering to false, assign with e.g.: -f 5"
else
    echo "Filtering: "$filtering
fi

echo "################################################################################################"
echo 

# Remove '='
reconstruct=${reconstruct/#=/}
username=${username/#=/}
path=${path/#=/}
modes=${modes/#=/}
filtering=${filtering/#=/}

ssh $username@slurm-nice-devel << EOF
    # echo "Running "sbatch /data/id01/inhouse/david/py38-stable/bin/job.slurm $reconstruct $username $path $modes $filtering
    sbatch /data/id01/inhouse/david/py38-stable/bin/job.slurm $reconstruct $username $path $modes $filtering

    echo "You may follow the evolution of the job by typing: 'tail -f job.slurm-XXXXX.out', replace XXXXX by the previous job number, the job file should be in your home directory."

	exit
EOF