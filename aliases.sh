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
# From https://bholmes.dev/blog/4-git-shortcuts-that-define-my-workflow/
# Stash what I'm working on and checkout the latest main
alias gimme="git stash push -u && git checkout main && git pull -r"
# Grab the latest main and come back to the branch I was on (with stashing!)
alias yoink="gimme && git checkout - && git stash pop"
# Checkout a new branch and push it to origin (so I don't forget that set-upstream)
woosh() {
  git checkout -b $1 && git push -u origin HEAD
}
# Stash my current WIP, checkout a new branch off the latest main, and push it to origin
alias boop="gimme && woosh"


###############################
# ledger
###############################
alias bal='hledger bs'
alias add='hledger iadd'

###############################
# Other
###############################
alias vim='nvim'

