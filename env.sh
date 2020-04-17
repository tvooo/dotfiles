#
# ~/.env.sh
#

###############################
# PATH
###############################
P_YARN="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin"
P_LEDGER="$HOME/.local/bin"
export PATH="$P_YARN:$P_LEDGER:$PATH"

###############################
# Terminal
###############################
export CLICOLOR=1

###############################
# Editor
###############################
export VISUAL=vim
export EDITOR="$VISUAL"

###############################
# Ledger
###############################
export LEDGER_FILE=~/projects/ledger/journal.ledger
export CURRENT_LEDGER_FILE=~/projects/ledger/2020.ledger
