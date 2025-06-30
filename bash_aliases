# ALIASES AND FUNCTIONS

alias cl="clear"
alias enable-touchpad="xinput enable 'SynPS/2 Synaptics TouchPad'"
alias bfg="java -jar C:/BFG/bfg-1.14.0.jar"
d() { cd "$HOME/Documents/$1" && ls; }
alias w="code -r . &"
alias src="source ~/.bashrc ."
alias mini="PS1='$ '"
alias df="df -h"
alias locip="ip a | grep eth0"
alias cdc="cd /cygdrive/c/code"
alias cdeb="cd /cygdrive/c/code/earthbreeze"
alias nukenpm="rm -rv node_modules && npm i"
alias difff="diff --color --suppress-common-lines --suppress-blank-empty -y"
# Workaround for Storybook compatibility issues
alias oslp="export NODE_OPTIONS=--openssl-legacy-provider"
alias sb="npm run storybook"

# Conda shorthand
alias ce="conda info --envs"
alias ca="conda activate"
alias cda="conda deactivate"
alias clist="conda list"
alias cc="conda create -n"
alias cr="conda env remove -n"

# Flutter tool
alias fclnup="flutter clean && flutter pub get && flutter pub upgrade"
alias frun="flutter run -v"
alias ftst="flutter test"
alias fbr-watch="flutter pub run build_runner watch"
alias fbr-build="flutter pub run build_runner build"

alias fa-bb="adb shell setprop debug.firebase.analytics.app com.juliankohann.bubblebrawl"

# Push current pubspec version to github and tag it to trigger a TestFlight build on codemagic
# This is for quantum cube, but could be reused with other dart projects, I suppose
tfpush() {
  VERSION="v$(cider version)"
  git commit -a -m "$VERSION"
  git tag "$VERSION"
  git push
  git push origin "$VERSION"
}

# Git shorthand
# No arguments: `git status`
# With arguments: acts like `git`
unalias g
g() {
  if [[ $# > 0 ]]; then
    git $@
  else
    git status
  fi
}

alias mybr="git branch | grep -i jbm && git branch -r | grep -i jbm"

copl() {
  git checkout $1
  git pull
  git checkout -
}

# Github shorthand

alias ghrevs="gh pr list --json 'number,title,reviews'"
alias action="gh run view -w"
alias prdev="gh pr create -B dev -l enhancement -a @me -b '' -t"
alias prmd="gh pr merge -rd && git fetch && g sla"
alias prmm="git checkout dev && gh pr merge -rd && git fetch && git checkout main && git pull && git checkout dev && git rebase main && git push -f && git sla"
# Open PRs in browser
alias ebprw=" gh pr list \
    --search 'is:open is:pr user:Earth-Breeze archived:false' \
    --web"

function ebprs() {
  gh pr list \
    --search 'is:open is:pr user:Earth-Breeze archived:false sort:updated-desc' \
    --json headRepository,number,updatedAt,author,title \
    --template '{{tablerow "PR" "Title" "Updated" "Author" "Repo"}}{{range .}}{{tablerow .number (truncate 30 .title) (truncate 10 (timeago .updatedAt)) (truncate 10 .author.login) .headRepository.name }}{{end}}{{tablerender}}' |
    fzf \
      --reverse \
      --padding 1,0 \
      --border \
      --border-label 'Earth Breeze - Open Pull Requests' \
      --border-label-pos 4 \
      --ansi \
      --cycle \
      --header-lines 1 \
      --preview-window 'right:55%,wrap' \
      --preview 'gh pr view \
        --repo "Earth-Breeze/$(echo {-1})" {1} \
        --json "title,state,baseRefName,isDraft,author,commits,number,headRepository,body,createdAt,latestReviews,reviewDecision,comments,mergeable,headRefName,updatedAt" \
        --template "
{{.title}} | {{.headRepository.name}} #{{.number}}

{{.author.login}} wants to merge {{len .commits}} commits into {{.baseRefName}} from {{.headRefName}}.

{{- tablerow \"Updated\" \"Created\" \"Author\" \"State\" \"Mergeable\" \"Review Decision\"}}
{{tablerow \"-------\" \"-------\" \"------\" \"-----\" \"---------\" \"---------------\"}}
{{tablerow (timeago .updatedAt) (timeago .createdAt) .author.login .state .mergeable .reviewDecision}}
{{ tablerender }}

Latest Reviews
---------------
{{range .latestReviews}}{{tablerow .author.login .state (timeago .submittedAt)}}{{end}}
{{- tablerender }}

Comments
---------
{{ range .comments -}}
{{- if eq .authorAssociation \"CONTRIBUTOR\" -}}
{{tablerow .author.login (timeago .createdAt) (truncate 70 .body)}}
{{- end -}}
{{- end -}}
{{- tablerender }}

Description
------------
{{.body}}
"' \
      --bind 'CTRL-o:execute(echo "Opening PR in VS Code" && repo_path="$CODEPATH/eb/$(echo {-1})" && cd $repo_path && gh co {1} && code .)' \
      --bind 'CTRL-w:execute(echo "Opening PR in Browser" && gh pr view --repo "Earth-Breeze/$(echo {-1})" --web {1})' \
      --bind 'enter:become(gh pr view --comments --repo "Earth-Breeze/$(echo {-1})" {1})' \
      --bind 'ctrl-r:reload(gh pr list --search "is:open is:pr user:Earth-Breeze archived:false sort:updated-desc" --json headRepository,number,updatedAt,author,title --template "{{tablerow \"PR\" \"Title\" \"Updated\" \"Author\" \"Repo\" }}{{range .}}{{tablerow .number (truncate 30 .title) (truncate 10 (timeago .updatedAt)) (truncate 10 .author.login) .headRepository.name}}{{end}}{{tablerender}}")'
}

# create a PR with an enhancement label, assign to me, and open in browser
prce() {
  gh pr create -a @me -l enhancement "$@" && gh pr view -w
}

# create a PR with a bug label, assign to me, and open in browser
prcb() {
  gh pr create -a @me -l bug "$@" && gh pr view -w
}

# create a PR with a release label, assign to me, and open in browser
# PR body is pre-populated with a list of PRs merged into dev since the last release
prcr() {
  git checkout main
  git pull
  git checkout dev
  git pull
  PR_LIST=$(git log --oneline --merges main..dev | grep -o '#[0-9]\+ ' | sed 's/^/- /')
  BODY="# In This Release\\n$PR_LIST\\n\\n# Preview Link\\ncoming soon"
  echo $BODY
  gh pr create -a @me -l release -b $BODY "$@" && gh pr view -w
}

function pdprmd() {
  git psuoc
  gh pr create -B dev -a @me -b '' -t "$1"
  gh pr merge -rd && git fetch && g sla
}
function pmprm() {
  if [[ $1 == "" ]]; then
    echo "Must provide a title for the PR"
  else
    git checkout dev
    git push -f
    gh pr create -B main -b "" -a @me -t "$1"
    gh pr merge -r
    git fetch
    git checkout main
    git pull
    git checkout dev
    git rebase main
    git push -f
    git sla
  fi
}

alias ghic="gh issue close"
alias ghil="gh issue list"
alias ghiv="gh issue view"
alias ghprlsm="gh pr list -s merged"
alias ghprv="gh pr view -w"
alias ghcs="gh copilot suggest"
alias ghce="gh copilot explain"

# VirtualBoxManager
vm() {
  if [[ $# > 0 ]]; then
    VBoxManage $@
  else
    VBoxManage list vms
  fi
}

# General
function mcd() {
  mkdir $1
  cd $1
}

function tree() {
  clear
  cmd //c tree $1 //f
}
function cln() {
  git clone "https://github.com/JohnnyMcGee/${1}"
}

# clone over ssh
function scln() {
  git clone "git@github.com:JohnnyMcGee/${1}.git"
}

# search network listeners for given string
# slightly different options for windows (Msys) version
function netgrep() {
  if [ "Msys" = "$(uname -o)" ]; then
    netstat -ano | findstr LISTENING | findstr $@

  else
    netstat -anolp | grep $@
  fi
}

# NPM Shorthand
alias n="npm"
alias ni="npm install"
alias nr="npm run"
alias nrd="npm run dev"
alias nrt="npm run test"
alias nrck="npm run check"

# Updating EarthBreeze internal dependencies
function ebi() {
  npm install "github:Earth-Breeze/${1}"
}

function ebid() {
  npm install "github:Earth-Breeze/${1}#dev"
}

# Chromatic build
function chr() {
  npx chromatic "--project-token=${1}"
}

alias npmi="npm install"
alias npmid="npm install --save-dev"
alias npmt="npm run test"
alias npmtr="npm run test run"
alias npmrd="npm run dev"
alias npmrb="npm run build"
alias npmird="npm install && npm run dev"
alias pj="code package.json"
alias npmlnt='npm run lint'
alias npmtsc='npm run type-check'

# Shopify Shorthand
alias shtc="shopify theme check --fail-level error"
alias shtd="shopify theme dev"
alias shtdd="shopify theme dev -s earth-breeze-development"
alias shtdp="shopify theme dev -s tryearthbreeze"
alias shtcb="shopify theme info -t $(git branch --show-current)"
# Pulls gempages assets before deploying to an unpublished theme
alias shgpd="shopify theme pull --store tryearthbreeze.myshopify.com -t us-store-theme/main --only \"config/*\" --only \"templates/*.gem-*\" --only \"assets/gem-*\" && shopify theme push -u"
alias shgenex="shopify app generate extension"
alias shad="shopify app deploy"
# Get the current dev theme and delete it
alias shdeldt='shopify theme delete -f -t $(shopify theme info -d --json | jq .theme.id)'
alias stic='shopify theme info -t $(git branch --show-current)'
alias theme-delete="shopify theme list --json | jq '.[] | .name' | fzf -m --layout reverse | xargs -n 1 -P 8 -I {} shopify theme delete -f -t {}"

# Function: delprev
# Description: Deletes all Shopify themes that start with a specified prefix.
# If no prefix is provided, it defaults to 'jbm/'.
#
# Usage:
# 1. To delete all themes that start with 'jbm/', simply call the function without any arguments:
#    delprev
#
# 2. To delete themes that start with a custom prefix, provide the prefix as an argument:
#    delprev 'my-custom-prefix'
#
# Example:
# If you have themes named 'my-custom-prefix/theme1', 'my-custom-prefix/theme2', etc.,
# you can delete them all by running:
#    delprev 'my-custom-prefix'
function delprev() {
  prefix=${1:-"jbm/"}
  shopify theme list --json | jq --arg prefix "$prefix" '.[] | select(.name | startswith($prefix)).id' | xargs -I {} shopify theme delete -f -t {}
}

function pull-clean() {
  echo "Pulling theme with args: $@\n"
  shopify theme pull $@
  echo "Removing build files...\n"
  ls **/*replo* assets/*-[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]*.*
  rm **/*replo* assets/*-[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]*.*
  echo "Done.\n"
}

# Shopify Hydrogen commands
alias h="npx shopify hydrogen"
alias hep="npx shopify hydrogen env pull -f"
alias hnitro="npx shopify hydrogen login -s earth-breeze-nitrogen && npx shopify hydrogen link -f --storefront 'Earth Breeze Nitrogen' && npx shopify hydrogen env pull -f"
alias hhydro="npx shopify hydrogen login -s earth-breeze-hydrogen && npx shopify hydrogen link -f --storefront 'Earth Breeze Hydrogen' && npx shopify hydrogen env pull -f"
alias hlnk="npx shopify hydrogen link -f"

# Decode and format a base64 json string
function decode() {
  echo -n "$1" | base64 --decode | jq .
}

# Encode a JSON string to base64
function encode() {
  echo -n "$1" | jq -c . | base64
}

# Firebase Shorthand
alias fes="firebase emulators:start"
alias fu="firebase use"
alias ffcg="firebase functions:config:get"

# Global Variables
export EBD="earth-breeze-development"
export EBH="earth-breeze-hydrogen"
export TEB="tryearthbreeze"

# Projects
alias qcf="cd $CODEPATH/fss/quantum_cube_flutter && code ."
alias qct="cd $CODEPATH/fss/quantum-cube-timer && code ."
alias qcp="gh project view -w --owner Quantum-Cube-Cloud 1"
alias al="cd $CODEPATH/aliases && code ."
alias st="cd $CODEPATH/eb/shopify-theme && code ."
alias std="cd $CODEPATH/eb/shopify-theme && code . && npm run dev"
alias stsb="cd $CODEPATH/eb/shopify-theme && code . && npm run storybook"
alias sh="cd $CODEPATH/eb/shopify-hydrogen && code ."
alias shd="cd $CODEPATH/eb/shopify-hydrogen && code . && npm run dev"
alias ust="cd $CODEPATH/eb/us-store-theme && code ."
alias ustd="cd $CODEPATH/eb/us-store-theme && code . && shopify theme dev"
alias cu="cd $CODEPATH/eb/checkout-ui && code ."
alias cud="cd $CODEPATH/eb/checkout-ui && code . && npm run dev"
alias rty="cd $CODEPATH/eb/recharge-thankyou && code ."
alias sha="cd $CODEPATH/eb/shared && code ."
alias pbw="cd $CODEPATH/pb/website && code ."
alias pbwd="cd $CODEPATH/pb/website && code . && npm run dev"
alias pbp="gh project view --owner psychobummer 4 -w"
