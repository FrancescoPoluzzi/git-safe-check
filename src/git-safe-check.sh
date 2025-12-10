#!/bin/bash

CURRENT_SCRIPT_DIR=$(dirname "$0")
REAL_GIT=$(type -a -p git | grep -v "$CURRENT_SCRIPT_DIR" | head -n 1)

if [ -z "$REAL_GIT" ]; then
    REAL_GIT="/usr/bin/git"
fi

RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

if [ ! -t 1 ]; then
    "$REAL_GIT" "$@"
    exit $?
fi

GIT_COMMAND="$1"
ARGS="${@:2}"

IS_ALIAS=$("$REAL_GIT" config --get "alias.$GIT_COMMAND" | awk '{print $1}')

if [ -n "$IS_ALIAS" ]; then
    CHECK_COMMAND="$IS_ALIAS"
else
    CHECK_COMMAND="$GIT_COMMAND"
fi

WARNING_MSG=""

case "$CHECK_COMMAND" in
    push)
        WARNING_MSG="☁️  You are about to ${BOLD}UPLOAD${NC} changes to the remote server.\n    This will make your changes visible to others."
        ;;
    rebase)
        WARNING_MSG="rewriting history"
        WARNING_MSG="🔄 You are about to ${BOLD}REWRITE HISTORY${NC} (Rebase).\n    This changes the timeline of your code. ${RED}Dangerous if shared!${NC}"
        ;;
    reset)
         WARNING_MSG="⏪ You are about to ${BOLD}RESET${NC} your code.\n    '--hard' resets will ${RED}DELETE${NC} uncommitted work permanently."
        ;;
    checkout)
        if [[ "$ARGS" == *.* ]] || [[ "$ARGS" == *"--"* ]]; then
             WARNING_MSG="📉 You are checking out specific files.\n    This might ${RED}discard local changes${NC} to those files."
        fi
        ;;
    branch)
        if [[ "$ARGS" == *"-d"* ]] || [[ "$ARGS" == *"-D"* ]]; then
            WARNING_MSG="✂️  You are about to ${BOLD}DELETE${NC} a branch.\n    Ensure you have merged any code you want to keep."
        fi
        ;;
esac

if [ -n "$WARNING_MSG" ]; then
    echo -e "\n${YELLOW}-------------------------------------------------------------${NC}"
    echo -e "${YELLOW}✋  GIT SAFETY CHECK${NC}"
    echo -e "${YELLOW}-------------------------------------------------------------${NC}"
    echo -e "$WARNING_MSG"
    echo -e ""
    echo -e "    Command: ${BLUE}git $GIT_COMMAND $ARGS${NC}"
    echo -e "${YELLOW}-------------------------------------------------------------${NC}"
    
    echo -n "❓ Do you want to proceed? [y/N] "
    read response
    
    response=$(echo "$response" | tr '[:upper:]' '[:lower:]')

    if [[ "$response" != "y" && "$response" != "yes" ]]; then
        echo -e "\n❌ ${RED}Aborted.${NC}"
        exit 1
    fi
    echo -e "✅ Proceeding...\n"
fi

"$REAL_GIT" "$@"
EXIT_CODE=$?

exit $EXIT_CODE
