# monorepo clean
alias super-clean-artifacts="cg && scripts/super-clean.sh -i -l -s"
alias super-clean-all="cg && rm -rf node_modules && npx lerna clean --yes && super-clean-artifacts"

#monorepo build
alias lbs="npx lerna bootstrap --ci"
alias cbsq="rm -rf node_modules && npx lerna clean --yes && lbs"
alias cbs="super-clean-all && lbs"
alias cbw="super-clean-all && scripts/bootstrap.sh && scripts/watch-server.sh --skip-bootstrap"
alias cbd="super-clean-all && scripts/build.sh"
alias cbda="cbs && npx lerna run build --stream --concurrency 1"

# monorepo add dependency to current package
# add @angular-devkit/schematics --dev 
add() {
	if [[ ! -f "package.json" ]] 
	then
    	echo "Must be in a folder containing lerna managed package.json"
	else
		PKG_NAME=$(node -p -e "require('./package.json').name")
		# passes multiple packages and flags to lerna add. 'add ng-packagr --dev' will install to dev dependencies.
		npx lerna add --scope=$PKG_NAME $* --no-bootstrap && lerna bootstrap --ignore-scripts
	fi
}

# add multiple packages to dev dependencies: 
# addd @angular-devkit/schematics ng-packagr typescript@~3.8.3 tslint@^5.12.1 ng-packagr @angular-devkit/core @angular-devkit/build-ng-packagr
addd() {
	if [[ ! -f "package.json" ]] 
	then
    	echo "Must be in a folder containing lerna managed package.json"
	else
		for var in "$@"
		do
			PKG_NAME=$(node -p -e "require('./package.json').name")
			npx lerna add --dev --scope=$PKG_NAME $var --no-bootstrap
		done
		npx lerna bootstrap --ignore-scripts
	fi
}

#monorepo cloud dev
alias cloud-dep="scripts/build-pkg.sh -d -l -b smc cp"

#cloud
alias jenkins="gcloud compute ssh --project=nth-fort-242316 --zone=us-east4-c rest-jenkins-a --internal-ip"

#git
alias gcm="git checkout main && git pull"
alias grim="git fetch && git rebase -i origin/main"
alias gpf="git push --force-with-lease"
alias recent="git for-each-ref --sort=-committerdate --count=10 --format='%(refname:short)' refs/heads/"
# navigate to top of repo
alias cg='cd `git rev-parse --show-toplevel`'

# git custom functions
source ~/scripts/git/git-helper-functions.sh
alias gc="__git_checkout_work_branch"
alias gro="__git_reset_current_branch"

# meta alias
alias alias-load="source ~/.bashrc"
alias alias-edit="code ~/scripts/aliases.sh"

# docker
alias docker-clean-images='docker rmi $(docker images -a --filter=dangling=true -q)'
alias docker-clean-containers='docker rm $(docker ps --filter=status=exited --filter=status=created -q)'
alias docker-maint='docker-clean-containers && docker-clean-images'

#useful stuff
alias plz='sudo $(fc -ln -1)'
alias ls='lsColorGroupingOverride'
alias install-npm-globals='~/scripts/install-npm-globals.sh'

# code-oss uses a different extensions repo. I want the microsoft repo.
# Apply the https://github.com/VSCodium/vscodium/issues/418#issuecomment-643664182 fix
alias fix-code-oss='sudo python3 ~/scripts/fix-oss.py'

# auto pipe ls -la to more as ls -la | more
lsColorGroupingOverride() {
    if [[ $@ == "-la" ]]; then
        command ls -la --color=auto --group-directories-first | more
    else
        command ls "$@" --color=auto --group-directories-first
    fi
}

alias delete-locks='find . -type f -name `package-lock.json` -delete'

#wapi-version
alias wapi-bump='wapi-version --jiraCreds ~/Downloads/jira-credentials.json bump'
alias wapi-cut='wapi-version --jiraCreds ~/Downloads/jira-credentials.json cut-release --allow-unpublished-deps'


#linux system
alias grub-build='grub-mkconfig -o /boot/grub/grub.cfg'
alias restart-pulseaudio='systemctl --user restart pulseaudio.socket pulseaudio.service'
# plasmashell, for rare cases when screen freezes and you are forced to ctrl + alt + F2 into a shell to fix it
alias restart-plasma='kquitapp5 plasmashell || killall plasmashell && kstart5 plasmashell'


#gcp
alias gcp-port-forward='~/scripts/gcp-port-forward.sh'
