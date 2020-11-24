# Load env vars for the system
source ~/.env

# -------------------------------------------------------------------
# Mac helper aliases
# -------------------------------------------------------------------

# Show/hide hidden files (starting with a `.`)
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

# Save me from myself
alias rm=trash

# Delete auto-generated `.DS_Store` files
alias deleteDSFiles="find . -name '.DS_Store' -type f -delete"

# VERY IMPORTANT WORK
alias corgo="cargo"

# Flush the DNS cache (helpful if you’re playing with local DNS)
alias flushdns="sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder"

# -------------------------------------------------------------------
# Git stuff
# -------------------------------------------------------------------

# Shortcut to checkout master and pull from upstream
alias gu="git checkout master && git pull upstream master"

# Clean, compact git status
alias s="git status -sb"

# auto-completion
if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
  . /opt/local/etc/profile.d/bash_completion.sh
fi

# Shortcut function for creating custom git.io links.
# See https://blog.github.com/2011-11-10-git-io-github-url-shortener/
gitlink() {
  # The first argument is the URL to shorten
  VALUES="-F \"url=$1\""

  # If a custom short code was requested, set the form value.
  if [ -n "$2" ]; then VALUES="$VALUES -F \"code=$2\""; fi

  # Send the request to GitHub and grab the Location header.
  RESPONSE=$(eval "curl -i https://git.io $VALUES 2>&1" | grep Location)

  # Remove the header name and echo only the generated short link.
  echo "${RESPONSE//Location: /}"
}

# -------------------------------------------------------------------
# GPG stuff
# -------------------------------------------------------------------

# This is so we can do nerdy GPG stuff and pretend to be hackers
export GPG_TTY=$(tty)

# -------------------------------------------------------------------
# Node.js
# -------------------------------------------------------------------

# Config for nvm, which lets us switch Node versions easily (https://github.com/creationix/nvm)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# -------------------------------------------------------------------
# VS Code Configuration setup
# -------------------------------------------------------------------

# For screencasting, use stripped down settings with large text.
alias teach="code --user-data-dir ~/.code_profiles/screencast/data"

# -------------------------------------------------------------------
# Video Stuff
# -------------------------------------------------------------------

# Convert a video clip to an MP3.
# I use this to make sound effects for Learn With Jason.
source ~/.convert-to-audio.sh

path+=~/.js 

# -------------------------------------------------------------------
# Link Shortener
# -------------------------------------------------------------------

shorten() { node /Users/jlengstorf/dev/url-shortener/node_modules/.bin/netlify-shortener "$1" "$2"; }

export PATH

# custom prompt via https://starship.rs
eval "$(starship init zsh)"

