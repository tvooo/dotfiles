#
# ~/.aliases.sh
#

###############################
# ls
###############################

# Does Mac support the -h flag?
alias la="ls -a"
alias lal="ls -alh"
alias ll="ls -lh"

###############################
# git
###############################
alias gco-='git checkout -'
alias gcm='git commit -m'
alias gco='git checkout'
alias gpoh='git push origin head'
alias grm='git rebase master'
alias gp='git pull'

###############################
# ledger
###############################
alias bal='hledger bs'
alias add='hledger iadd'

###############################
# Other
###############################
alias vim='nvim'
