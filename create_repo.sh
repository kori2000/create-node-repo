#!/bin/bash

# Color Scheme for Selections
e=$'\e'
CYELLOW="$e[1;33m"
CBLUE="$e[0;33m"
CPURPLE="$e[0;35m"
CGREEN="$e[0;32m"
CRED="$e[0;31m"
CCYAN="$e[0;36m"
CRESET="$e[0m"

clear

echo "${CRED}"
echo " _____ _____ _____ _____    _____         "
echo "| __  |   __|  _  |     |  |   __|___ ___ "
echo "|    -|   __|   __|  |  |  |  |  | -_|   |"
echo "|__|__|_____|__|  |_____|  |_____|___|_|_|"
echo "${CRESET}"
echo "${CBLUE}  GitHub Repository Generator | V.1.0 2022${CRESET}"

# --+---------------------------------------------------------------
#   | HELPER FUNCTIONS
# --+---------------------------------------------------------------

# Renders a text based list of options that can be selected by the
# user using up, down and enter keys and returns the chosen option.
#
#   Arguments   : list of options, maximum of 256
#                 "opt1" "opt2" ...
#   Return value: selected index (0 for opt1, 1 for opt2 ...)
function select_option {

    # little helpers for terminal print control and key input
    ESC=$( printf "\033")
    cursor_blink_on()  { printf "$ESC[?25h"; }
    cursor_blink_off() { printf "$ESC[?25l"; }
    cursor_to()        { printf "$ESC[$1;${2:-1}H"; }
    print_option()     { printf "   $1 "; }
    print_selected()   { printf "${CBLUE}  $ESC[7m $1 $ESC[27m ${CRESET}"; }
    get_cursor_row()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    key_input()        { read -s -n3 key 2>/dev/null >&2
      if [[ $key = $ESC[A ]]; then echo up;    fi
      if [[ $key = $ESC[B ]]; then echo down;  fi
      if [[ $key = ""     ]]; then echo enter; fi }

    # initially print empty new lines (scroll down if at bottom of screen)
    for opt; do printf "\n"; done

    # determine current screen position for overwriting the options
    local lastrow=`get_cursor_row`
    local startrow=$(($lastrow - $#))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local selected=0
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for opt; do
            cursor_to $(($startrow + $idx))
            if [ $idx -eq $selected ]; then
                print_selected "$opt"
            else
                print_option "$opt"
            fi
            ((idx++))
        done

        # user key control
        case `key_input` in
            enter) break;;
            up)    ((selected--));
              if [ $selected -lt 0 ]; then selected=$(($# - 1)); fi;;
            down)  ((selected++));
              if [ $selected -ge $# ]; then selected=0; fi;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    return $selected
}

# Render a colored progress bar
#
#   Arguments   : progress value
#                 "0" "20" "50" "99" ...
#   Return value: colored progress bar with percentage value and time
pgb () {
  LR='\033[1;31m'
  LG='\033[1;32m'
  LY='\033[1;33m'
  LC='\033[1;36m'
  LW='\033[1;37m'
  NC='\033[0m'
  
  if [ "${1}" = "0" ]; then TME=$(date +"%s"); fi

  SEC=`printf "%04d\n" $(($(date +"%s")-${TME}))`; SEC="$SEC sec"
  PRC=`printf "%.0f" ${1}`
  SHW=`printf "%3d\n" ${PRC}`
  LNE=`printf "%.0f" $((${PRC}/2))`
  LRR=`printf "%.0f" $((${PRC}/2-12))`; if [ ${LRR} -le 0 ]; then LRR=0; fi;
  LYY=`printf "%.0f" $((${PRC}/2-24))`; if [ ${LYY} -le 0 ]; then LYY=0; fi;
  LCC=`printf "%.0f" $((${PRC}/2-36))`; if [ ${LCC} -le 0 ]; then LCC=0; fi;
  LGG=`printf "%.0f" $((${PRC}/2-48))`; if [ ${LGG} -le 0 ]; then LGG=0; fi;
  LRR_=""
  LYY_=""
  LCC_=""
  LGG_=""
  
  for ((i=1;i<=13;i++))
  do
    DOTS=""; for ((ii=${i};ii<13;ii++)); do DOTS="${DOTS}."; done
    if [ ${i} -le ${LNE} ]; then LRR_="${LRR_}#"; else LRR_="${LRR_}."; fi
    echo -ne "  ${LW}${SEC}  ${LR}${LRR_}${DOTS}${LY}............${LC}............${LG}............ ${SHW}%${NC}\r"
    if [ ${LNE} -ge 1 ]; then sleep .01; fi
  done

  for ((i=14;i<=25;i++))
  do
    DOTS=""; for ((ii=${i};ii<25;ii++)); do DOTS="${DOTS}."; done
    if [ ${i} -le ${LNE} ]; then LYY_="${LYY_}#"; else LYY_="${LYY_}."; fi
    echo -ne "  ${LW}${SEC}  ${LR}${LRR_}${LY}${LYY_}${DOTS}${LC}............${LG}............ ${SHW}%${NC}\r"
    if [ ${LNE} -ge 14 ]; then sleep .01; fi
  done

  for ((i=26;i<=37;i++))
  do
    DOTS=""; for ((ii=${i};ii<37;ii++)); do DOTS="${DOTS}."; done
    if [ ${i} -le ${LNE} ]; then LCC_="${LCC_}#"; else LCC_="${LCC_}."; fi
    echo -ne "  ${LW}${SEC}  ${LR}${LRR_}${LY}${LYY_}${LC}${LCC_}${DOTS}${LG}............ ${SHW}%${NC}\r"
    if [ ${LNE} -ge 26 ]; then sleep .005; fi
  done

  for ((i=38;i<=49;i++))
  do
    DOTS=""; for ((ii=${i};ii<49;ii++)); do DOTS="${DOTS}."; done
    if [ ${i} -le ${LNE} ]; then LGG_="${LGG_}#"; else LGG_="${LGG_}."; fi
    echo -ne "  ${LW}${SEC}  ${LR}${LRR_}${LY}${LYY_}${LC}${LCC_}${LG}${LGG_}${DOTS} ${SHW}%${NC}\r"
    if [ ${LNE} -ge 38 ]; then sleep .005; fi
  done
}

# --+---------------------------------------------------------------
#   | END
# --+---------------------------------------------------------------

echo

# For Mac, # Select GNU sed
if [[ uname = "Darwin" ]]
  then
    $(export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH")
fi

# Set Parameter Values
options=(" 🚀 Create new blank GitHub Repository" " 💀 Remove GitHub Repository " " 🔥 Add Docker Image" " ✨ Add NodeJS API" "Quit")

# Draw Selection Menu
select_option "${options[@]}"

# Retrive Selection Value
CHOICE=$?

# echo "Index = $CHOICE"
# echo "Value = ${options[$CHOICE]}"

# --+---------------------------------------------------------------
#   | Quit, Index 4.
# --+---------------------------------------------------------------
if [[ $CHOICE = "4" ]]
  then echo "  ${CYELLOW} 😽 Bye,bye & have a nice day${CRESET}"
fi

# --+---------------------------------------------------------------
#   | Create new blank GitHub Repository, Index 0.
# --+---------------------------------------------------------------
if [[ $CHOICE = "0" ]]
  then

    OC_TEMPLATE_DATA=$(find ./ -name 'template_data.yml')
    if [[ $OC_TEMPLATE_DATA != "" ]]
      then 
        echo "  ${CGREEN}Template data configurtion located [template_data.yml]...${CRESET}"
        echo ""

        CU_APP_NAME=`cat template_data.yml | grep app_name | cut -d':' -f2 | cut -c 2-`
        CU_APP_KEYWORDS=`cat template_data.yml | grep app_keywords | cut -d':' -f2 | cut -c 2-`
        CU_APP_DESC=`cat template_data.yml | grep app_desc | cut -d':' -f2 | cut -c 2-`
        CU_APP_EXEC=`cat template_data.yml | grep app_exec | cut -d':' -f2 | cut -c 2-`
        CU_SERVER_PORT=`cat template_data.yml | grep server_port | cut -d':' -f2 | cut -c 2-`
        CU_GIT_REPO=`cat template_data.yml | grep git_repo | cut -d':' -f2 | cut -c 2-`
        
        echo "  ${CCYAN=}CU_APP_NAME.......= $CU_APP_NAME ${CRESET}"
        echo "  ${CCYAN=}CU_APP_KEYWORDS...= $CU_APP_KEYWORDS ${CRESET}"
        echo "  ${CCYAN=}CU_APP_DESC.......= $CU_APP_DESC ${CRESET}"
        echo "  ${CCYAN=}CU_APP_EXEC.......= $CU_APP_EXEC ${CRESET}"
        echo "  ${CCYAN=}CU_SERVER_PORT....= $CU_SERVER_PORT ${CRESET}"
        echo "  ${CCYAN=}CU_GIT_REPO.......= $CU_GIT_REPO ${CRESET}"

        echo ""

      else

        echo "  ${CBLUE}Your Application Name (like for example api-gateway): ${CRESET}"
        printf "  # "
        read CU_APP_NAME

        echo "  ${CBLUE}Some Application Keywords for ai generated text (blockchain, web3, weather, api, ...): ${CRESET}"
        printf "  # "
        read CU_APP_KEYWORDS

        echo "  ${CBLUE}Application Description (for default leave empty): ${CRESET}"
        printf "  # "
        read CU_APP_DESC

        echo "  ${CBLUE}Application TCP Port (any port other than 80 or 443): ${CRESET}"
        printf "  # "
        read CU_SERVER_PORT

        echo "  ${CBLUE}Your Application run cmd (npm run start --param=value): ${CRESET}"
        printf "  # "
        read CU_APP_EXEC

        echo "  ${CBLUE}Git Repository Name (for default [like app-name] leave empty): ${CRESET}"
        printf "  # "
        read CU_GIT_REPO

    fi

    while true; do
        read -p "${CBLUE} If everything is OK, continue with [y] or cancel with [c]: ${CRESET}" yn
        case $yn in
            [Yy]* ) echo ""; break;;
            [Cc]* ) echo ""; echo "${CYELLOW}  Cancelled. Bye, bye...${CRESET}";exit;;
            * ) echo "  Please answer [y]es or [c]ancel.";;
        esac
    done

    echo "  ${CYELLOW}Generating new OC Templates for Application [${CU_APP_NAME}] ${CRESET}"

    # Clear template folder
    DIR_TEMPLATE="./template-data/"
    if [ -d "$DIR_TEMPLATE" ]
      then
        $(rm -rf template-data/)
        $(mkdir template-data)
        $(echo "" > template-data/.gitkeep)

    fi

    pgb 0
    
    if [[ $CU_GIT_REPO = "" ]] 
      then 
        CU_GIT_REPO=$CU_APP_NAME
    fi
    
    pgb 25

    export IN_APP_NAME=$CU_APP_NAME
    export IN_APP_DESC=$CU_APP_DESC

    export IN_DOCKER_CONTAINER=$CU_APP_NAME
    export IN_SERVER_PORT=$CU_SERVER_PORT

    # export IN_OC_CLUSTER=$CU_OC_CLUSTER
    # export IN_APP_NAME=$CU_APP_NAME
    # export IN_HOST_DNS=$CU_HOST_DNS
    # export IN_TCP_PORT=$CU_TCP_PORT
    # export IN_APP_EXEC=$CU_APP_EXEC
    # export IN_GIT_REPO=$CU_GIT_REPO
    # export IN_GIT_BRANCH=$CU_GIT_BRANCH
    # export IN_APP_STAGE=$CU_APP_STAGE
    # export IN_GIT_OC_TOKEN=$CU_GIT_OC_TOKEN

    # export IN_PVC=""
    
    pgb 25
    echo "   *README.md  "
    envsubst < templates/_README.md > template-data/README.md

    pgb 50
    echo "   *Route    "
    envsubst < data/oc-pattern-route.yaml > templates/$CU_APP_NAME-route.yaml

    # pgb 75
    # echo "   *Build    "
    # envsubst < data/oc-pattern-build.yaml > templates/$CU_APP_NAME-build.yaml

    # pgb 100
    # echo "   *Deploy   "
    # envsubst < data/oc-pattern-deploy.yaml > templates/$CU_APP_NAME-deploy.yaml   

    curl -i -H "Authorization: token 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" --data '{"name": "test123", "auto_init": true, "private": true}' https://api.github.com/user/repos

    curl -X DELETE -H 'Authorization: token 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' https://api.github.com/repos/kori2000/test123

    echo "  ${CGREEN}Done. Have a look inside the folder [templates]${CRESET}"
  
fi

# --+---------------------------------------------------------------
#   | Add PVC, Index 1.
# --+---------------------------------------------------------------
if [[ $CHOICE = "1" ]]
  then
  
    OC_PVC_DEPLOY=$(find templates -name '*deploy*')
    
    if [[ $OC_PVC_DEPLOY = "" ]]
      then 
        echo "  ${CRED}No OC Templates found in folder [templates]${CRESET}"
        exit
      else
        echo "  ${CGREEN}Found [${OC_PVC_DEPLOY}]. ${CRESET}"
        APP_NAME=$(sed -n '6 p' $OC_PVC_DEPLOY | cut -c11-)
        echo ""
    fi

    echo "  ${CBLUE}Select existing PVC (for default pvc-${APP_NAME} leave empty): ${CRESET}"
    printf "  # "
    read CU_PVC_NAME

    echo "  ${CBLUE}Choose a mount path (for example /usr/src/angular/backup/): ${CRESET}"
    printf "  # "
    read CU_PVC_MOUNT

    echo "  ${CBLUE}Choose a sub mount path (OPTIONAL, leave empty): ${CRESET}"
    printf "  # "
    read CU_PVC_SUB_MOUNT

    echo ""

    while true; do
        read -p "${CBLUE}  If everything is OK, continue with [y] or cancel with [c]: ${CRESET}" yn
        case $yn in
            [Yy]* ) echo ""; break;;
            [Cc]* ) echo ""; echo "${CYELLOW}  Cancelled. Bye, bye...${CRESET}";exit;;
            * ) echo "  Please answer [y]es or [c]ancel.";;
        esac
    done

    echo "  ${CYELLOW}Updating OC Deploy Template in Folder [templates]${CRESET}"
    
    pgb 0

    if [[ $CU_PVC_NAME = "" ]] 
      then 
        CU_PVC_NAME="pvc-${APP_NAME}"
    fi
    
    pgb 50
    echo "   +PVC Mount Path  "

    CU_PVC_MOUNT=$(echo "$CU_PVC_MOUNT" | sed 's/\//\\\//g')
    CU_PVC_SUB_MOUNT=$(echo "$CU_PVC_SUB_MOUNT" | sed 's/\//\\\//g')
    
    FIND_PVC_MOUNT_INIT="#PVC-MOUNT-INIT"
    FIND_PVC_MOUNT_ANOTHER="#PVC-MOUNT-ANOTHER"

    FIND_PVC_VOLUME_INIT="#PVC-VOLUME-INIT"
    FIND_PVC_VOLUME_ANOTHER="#PVC-VOLUME-ANOTHER"

    if [[ $(grep -w $FIND_PVC_MOUNT_INIT $OC_PVC_DEPLOY) != "" ]]
      then

        if [[ $CU_PVC_SUB_MOUNT = "" ]]
          then
            RPLC="volumeMounts:\n            - name: ${CU_PVC_NAME}\n              mountPath: ${CU_PVC_MOUNT}\n            ${FIND_PVC_MOUNT_ANOTHER}"
          else
            RPLC="volumeMounts:\n            - name: ${CU_PVC_NAME}\n              mountPath: ${CU_PVC_MOUNT}\n              subPath: ${CU_PVC_SUB_MOUNT}\n            ${FIND_PVC_MOUNT_ANOTHER}"
        fi

        # Linux Host use different sed cmd: sed -i | Mac: sed -i'' -e 
        $(sed -i'' -e "s/${FIND_PVC_MOUNT_INIT}/${RPLC}/g" $OC_PVC_DEPLOY)

      elif [[ $(grep -w $FIND_PVC_MOUNT_ANOTHER $OC_PVC_DEPLOY) != "" ]]
        then

        if [[ $CU_PVC_SUB_MOUNT = "" ]]
          then
            RPLC="- name: ${CU_PVC_NAME}\n              mountPath: ${CU_PVC_MOUNT}\n            ${FIND_PVC_MOUNT_ANOTHER}"
          else
            RPLC="- name: ${CU_PVC_NAME}\n              mountPath: ${CU_PVC_MOUNT}\n              subPath: ${CU_PVC_SUB_MOUNT}\n            ${FIND_PVC_MOUNT_ANOTHER}"
        fi
        
        $(sed -i'' -e "s/${FIND_PVC_MOUNT_ANOTHER}/${RPLC}/g" $OC_PVC_DEPLOY)

      else
        echo ""
        echo ""
        echo "  ${CRED}Template corrupted. Please create a new one${CRESET}"
        exit
    fi
        
    pgb 75
    echo "   +PVC Vol. Claim  "

    if [[ $(grep -w $FIND_PVC_VOLUME_INIT $OC_PVC_DEPLOY) != "" ]]
      then
        RPLC="volumes:\n            - persistentVolumeClaim:\n                claimName: ${CU_PVC_NAME}\n              name: ${CU_PVC_NAME}\n            ${FIND_PVC_VOLUME_ANOTHER}"
        $(sed -i'' -e "s/${FIND_PVC_VOLUME_INIT}/${RPLC}/g" $OC_PVC_DEPLOY)

      elif [[ $(grep -w $FIND_PVC_VOLUME_ANOTHER $OC_PVC_DEPLOY) != "" ]]
        then
        RPLC="- persistentVolumeClaim:\n                claimName: ${CU_PVC_NAME}\n              name: ${CU_PVC_NAME}\n            ${FIND_PVC_VOLUME_ANOTHER}"
        $(sed -i'' -e "s/${FIND_PVC_VOLUME_ANOTHER}/${RPLC}/g" $OC_PVC_DEPLOY)

      else
        echo ""
        echo ""
        echo "  ${CRED}Template corrupted. Please create a new one${CRESET}"
        exit
    fi

    pgb 100
    echo "   *Deploy updated  "
    echo "  ${CGREEN}Done. Have a look inside the folder [templates]${CRESET}"

    rm $OC_PVC_DEPLOY-e # Delete Backup File
  
fi

# --+---------------------------------------------------------------
#   | Add ISGW Proxy, Index 2.
# --+---------------------------------------------------------------
if [[ $CHOICE = "2" ]]
  then
    
    OC_LB_ROUTE=$(find templates -name '*route*')

    if [[ $OC_LB_ROUTE = "" ]]
      then 
        echo "  ${CRED}No OC Templates found in folder [templates]${CRESET}"
        exit
      else
        echo "  ${CGREEN}Found [${OC_LB_ROUTE}]. ${CRESET}"
        APP_NAME=$(sed -n '6 p' $OC_LB_ROUTE | cut -c11-)
        echo ""
    fi

    echo "  ${CBLUE}Set Domain (DNS has to be known and set up at ISGW): ${CRESET}"
    printf "  # "
    read CU_ISGW_DOMAIN

    while true; do
        read -p "${CBLUE}  If everything is OK, continue with [y] or cancel with [c]: ${CRESET}" yn
        case $yn in
            [Yy]* ) echo ""; break;;
            [Cc]* ) echo ""; echo "${CYELLOW}  Cancelled. Bye, bye...${CRESET}";exit;;
            * ) echo "  Please answer [y]es or [c]ancel.";;
        esac
    done

    echo "  ${CYELLOW}Updating OC Route Template in Folder [templates]${CRESET}"
    
    pgb 0

    CU_ISGW_DOMAIN=$(echo "$CU_ISGW_DOMAIN" | sed 's/\//\\\//g')

    FIND_ISGW_INIT="#ISGW-INIT"
    FIND_ISGW_HOST=$(sed -n '20 p' $OC_LB_ROUTE | cut -c11-)

    pgb 50
    echo "   +Activate ISGW   "

    if [[ $(grep -w $FIND_ISGW_INIT $OC_LB_ROUTE) != "" ]]
      then
        RPLC="labels:\n      internet: \"yes\""
        $(sed -i'' -e "s/${FIND_ISGW_INIT}/${RPLC}/g" $OC_LB_ROUTE)
      else
        echo ""
        echo ""
        echo "  ${CRED}Template corrupted. Please create a new one${CRESET}"
        exit
    fi

    pgb 75
    echo "   +Publish Domain  "

    if [[ $(grep -w $FIND_ISGW_HOST $OC_LB_ROUTE) != "" ]]
      then
        RPLC="${CU_ISGW_DOMAIN}"
        $(sed -i'' -e "s/${FIND_ISGW_HOST}/${RPLC}/g" $OC_LB_ROUTE)
      else
        echo ""
        echo ""
        echo "  ${CRED}Template corrupted. Please create a new one${CRESET}"
        exit
    fi

    pgb 100
    echo "   *Route updated  "
    echo "  ${CGREEN}Done. Have a look inside the folder [templates]${CRESET}"

    rm $OC_LB_ROUTE-e # Delete Backup File

fi

# --+---------------------------------------------------------------
#   | Add Load Balancer, Index 3.
# --+---------------------------------------------------------------
if [[ $CHOICE = "3" ]]
  then

    OC_LB_SERVICE=$(find templates -name '*service*')
    
    if [[ $OC_LB_SERVICE = "" ]]
      then 
        echo "  ${CRED}No OC Templates found in folder [templates]${CRESET}"
        exit
      else
        echo "  ${CGREEN}Found [${OC_LB_SERVICE}]. ${CRESET}"
        APP_NAME=$(sed -n '6 p' $OC_LB_SERVICE | cut -c11-)
        echo ""
    fi

    echo "  ${CBLUE}Set Load Balancer Host (for default DB AWS leave empty): ${CRESET}"
    printf "  # "
    read CU_LB_HOST

    while true; do
        read -p "${CBLUE}  If everything is OK, continue with [y] or cancel with [c]: ${CRESET}" yn
        case $yn in
            [Yy]* ) echo ""; break;;
            [Cc]* ) echo ""; echo "${CYELLOW}  Cancelled. Bye, bye...${CRESET}";exit;;
            * ) echo "  Please answer [y]es or [c]ancel.";;
        esac
    done

    echo "  ${CYELLOW}Updating OC Service Template in Folder [templates]${CRESET}"
    
    pgb 0

    if [[ $CU_LB_HOST = "" ]] 
      then 
        CU_LB_HOST="service.beta.kubernetes.io/aws-load-balancer-internal: 0.0.0.0/0"
    fi

    CU_LB_HOST=$(echo "$CU_LB_HOST" | sed 's/\//\\\//g')

    FIND_LOAD_BALANCER_INIT="#LOAD-BALANCER-INIT"
    FIND_LOAD_BALANCER_POLC="ClusterIP"

    pgb 50
    echo "   +Load Balancer   "

    if [[ $(grep -w $FIND_LOAD_BALANCER_INIT $OC_LB_SERVICE) != "" ]]
      then
        RPLC="annotations:\n      ${CU_LB_HOST}"
        $(sed -i'' -e "s/${FIND_LOAD_BALANCER_INIT}/${RPLC}/g" $OC_LB_SERVICE)
      else
        echo ""
        echo ""
        echo "  ${CRED}Template corrupted. Please create a new one${CRESET}"
        exit
    fi

    pgb 75
    echo "   +Cluster Policy  "

    if [[ $(grep -w $FIND_LOAD_BALANCER_POLC $OC_LB_SERVICE) != "" ]]
      then
        RPLC="LoadBalancer\n    clusterIP:\n    externalTrafficPolicy: Cluster"
        $(sed -i'' -e "s/${FIND_LOAD_BALANCER_POLC}/${RPLC}/g" $OC_LB_SERVICE)
      else
        echo ""
        echo ""
        echo "  ${CRED}Template corrupted. Please create a new one${CRESET}"
        exit
    fi

    pgb 100
    echo "   *Service updated  "
    echo "  ${CGREEN}Done. Have a look inside the folder [templates]${CRESET}"

    rm $OC_LB_SERVICE-e # Delete Backup File
    
fi

# For Mac, # Unselect GNU sed
if [[ uname = "Darwin" ]] 
  then
    $(unset PATH)
fi