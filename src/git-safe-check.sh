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

RULES_FILE="${CURRENT_SCRIPT_DIR}/rule.sh"
if [[ -f "$RULES_FILE" ]]; then
    source "$RULES_FILE"
fi

gsc_find_matching_rule() {
    local cmd="$1"
    shift
    local args="$*"
    local rule_id
    local patterns
    local pat

    if [[ -z "${GSC_RULES_BY_CMD[$cmd]+_}" ]]; then
        return 1
    fi

    for rule_id in ${GSC_RULES_BY_CMD[$cmd]}; do
        patterns=${GSC_RULE_MATCHES[$rule_id]}
        if [[ -z "$patterns" ]]; then
            echo "$rule_id"
            return 0
        fi

        for pat in $patterns; do
            case " $args " in
                *" $pat "*)
                    echo "$rule_id"
                    return 0
                    ;;
            esac
        done
    done

    return 1
}

if [ ! -t 1 ]; then
    "$REAL_GIT" "$@"
    exit $?
fi

if [ "$#" -eq 0 ]; then
    "$REAL_GIT" "$@"
    exit $?
fi

GIT_COMMAND="$1"
ARGS="${@:2}"

IS_ALIAS=$("$REAL_GIT" config --get "alias.$GIT_COMMAND" 2>/dev/null | awk '{print $1}')

if [ -n "$IS_ALIAS" ]; then
    CHECK_COMMAND="$IS_ALIAS"
else
    CHECK_COMMAND="$GIT_COMMAND"
fi

WARNING_MSG=""
RULE_ID=""

if [ -n "$CHECK_COMMAND" ]; then
    RULE_ID=$(gsc_find_matching_rule "$CHECK_COMMAND" "$ARGS")
fi

if [ -n "$RULE_ID" ]; then
    WARNING_MSG="${GSC_RULE_MESSAGE[$RULE_ID]}"
fi

if [ -n "$WARNING_MSG" ]; then
    echo -e "\n${YELLOW}-------------------------------------------------------------${NC}"
    echo -e "${YELLOW}✋  GIT SAFETY CHECK${NC}"
    echo -e "${YELLOW}-------------------------------------------------------------${NC}"
    echo
    echo -e "$WARNING_MSG"
    echo
    echo -en "${BLUE}Proceed with this git command?${NC} [y/N]: "

    read -r response

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
