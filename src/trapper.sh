#!/usr/bin/env bash

# -------------------------------------------------------------------------------- #
# Description                                                                      #
# -------------------------------------------------------------------------------- #
# Trapper is designed to be a simple to use plugin to assist in debugging simple   #
# or complex bash scripts. It will attempt to capture the error and display a code #
# snippet highlighting where the error is as well as provide the error message.    #
# -------------------------------------------------------------------------------- #

# -------------------------------------------------------------------------------- #
# Configure the shell.                                                             #
# -------------------------------------------------------------------------------- #

set -Eeuo pipefail

# -------------------------------------------------------------------------------- #
# Capture stderr so we can replay the error messages.                              #
# -------------------------------------------------------------------------------- #

ERROR_FILE='/tmp/trapper'
exec 2>"${ERROR_FILE}"

# -------------------------------------------------------------------------------- #
# Everyone likes colour (and it makes the arrow standout more.                     #
# -------------------------------------------------------------------------------- #

red=$(tput setaf 1)
reset=$(tput sgr0)
bold=$(tput bold)

# -------------------------------------------------------------------------------- #
# The main worker which is called when an error happens.                           #
# -------------------------------------------------------------------------------- #

# shellcheck disable=SC2155
function failure()
{
    #
    # Remove the traps to ensure they dont trigger twice
    #
    trap '' ERR EXIT

    #
    # Local variables to store the error code and signal that caused the failure
    #
    local code=$1
    local signal=$2

    #
    # Regex to parse the error log
    #
    local regex="^(.*): line ([[:digit:]]+): (.*)"

    #
    # What file/line caused the error?
    #
    # shellcheck disable=SC2312
    IFS=' ' read -ra PARTS <<< "$(caller)"
    lineno=${PARTS[0]}
    filename=${PARTS[1]}

    #
    # Only do something if there was an error code
    #
    if [[ ${code} != 0 ]]; then
        #
        # Exit doesnt mean no error just no ERR (divider by zero for example does this)
        #
        if [[ "${signal}" == 'EXIT' ]]; then
            #
            # Check for any stderr output
            #
            if [[ -f ${ERROR_FILE} ]]; then
                mapfile -t errors < "${ERROR_FILE}"
                rm -f "${ERROR_FILE}"

                #
                # Loop over the errors (could be multiple in one file as err wasnt called)
                #
                for i in "${errors[@]}"
                do
                    if [[ ${i} =~ ${regex} ]]; then
                        #
                        # Only process if the pattern matches (generally: file: line NN: error message)
                        #
                        if [[ ${#BASH_REMATCH[@]} == 4 ]]; then
                            lineno=${BASH_REMATCH[2]}
                            error_msg=${BASH_REMATCH[3]}

                            #
                            # Display the details for the error
                            #
                            printf "\n%s%sFailed in %s on line %s with the following error:\n%s%s\n" "${bold}" "${red}" "${filename##*/}" "${lineno}" "${error_msg}" "${reset}"
                            awk 'NR>L-4 && NR<L+4 { printf "    %-5d%s%s%4s%s%s\n", NR, bold, red, (NR==L?">>> ":""), reset, $0 }' L="${lineno}" bold="${bold}" red="${red}" reset="${reset}" "${filename}"
                        fi
                    fi
                done
            #
            # Nothing in stderr - just show the details without an error message
            #
            else
                printf "\n%s%sFailed in %s on line %s%s\n" "${bold}" "${red}" "${filename##*/}" "${lineno}" "${reset}"
                awk 'NR>L-4 && NR<L+4 { printf "    %-5d%s%s%4s%s%s\n", NR, bold, red, (NR==L?">>> ":""), reset, $0 }' L="${lineno}" bold="${bold}" red="${red}" reset="${reset}" "${filename}"
            fi
        elif [[ "${signal}" == 'ERR' ]]; then
            #
            # Check forany stderr output
            #
            if [[ -f ${ERROR_FILE} ]]; then
                mapfile -t errors < "${ERROR_FILE}"
                rm -f "${ERROR_FILE}"

                #
                # Show the details (without or without the errors depending on if we have them)
                #
                if [[ ${#errors[@]} -eq 0 ]]; then
                    printf "\n%s%sFailed in %s on line %s with no error message.%s\n" "${bold}" "${red}" "${filename##*/}" "${lineno}" "${reset}"
                else
                    printf "\n%s%sFailed in %s on line %s with the following error:\n%s%s\n" "${bold}" "${red}" "${filename##*/}" "${lineno}" "${errors[@]}" "${reset}"
                fi
            else
                printf "\n%s%sParent call failure in %s on line %s%s\n" "${bold}" "${red}" "${filename##*/}" "${lineno}" "${reset}"
            fi
            #
            # Show the code snipper
            #
            awk 'NR>L-4 && NR<L+4 { printf "    %-5d%s%s%4s%s%s\n", NR, bold, red, (NR==L?">>> ":""), reset, $0 }' L="${lineno}" bold="${bold}" red="${red}" reset="${reset}" "${filename}"
        else
            printf "\n%s%sUnhandled signal '%s'%s\n" "${bold}" "${red}" "${signal}" "${reset}"
        fi
    fi
}

# -------------------------------------------------------------------------------- #
# Simple wrapper to allow multiple traps to be set and identified.                 #
# -------------------------------------------------------------------------------- #

function trap_with_arg()
{
    func="$1";
    shift

    for sig ; do
        # shellcheck disable=SC2064
        trap "${func} ${sig}" "${sig}"
    done
}

# -------------------------------------------------------------------------------- #
# Bait the traps.                                                                  #
# -------------------------------------------------------------------------------- #

# shellcheck disable=SC2016
trap_with_arg 'failure ${?}' ERR EXIT

# -------------------------------------------------------------------------------- #
# End of Script                                                                    #
# -------------------------------------------------------------------------------- #
# This is the end - nothing more to see here.                                      #
# -------------------------------------------------------------------------------- #
