source /home/alex/scripts/trycatch.sh

# expects [b(ug -> fix)/f(eat)/c(hore)] [W(ebapi)/C(p)] [number of branch to check out]
# example: f w 1234 = git checkout feat/WEBAPI-1234
# if not passed, type defaults to bug and project defaults to WEBAPI
__git_checkout_work_branch() {
	PROJECT=("WEBAPI" "CP")
	TYPE=("fix" "feat" "chore")
	ID=""
	NEW_BRANCH=""

	while [[ $# -gt 0 ]]; do
		key="$1"
		shift
		case $key in
		-b)
			NEW_BRANCH="-b"
			;;
		b|fix)
			TYPE=("fix")
			;;
		f|feat)
			TYPE=("feat")
			;;
		c|chore)
			TYPE=("chore")
			;;
		W|WEBAPI)
			PROJECT=("WEBAPI")
			;;
		C|CP)
			PROJECT=("CP")
			;;
		*)
			if [[ $key =~ [[:digit:]]+ ]]; then
				ID=$key
			else
				echo ERROR - unknown argument: $key
				return 1
			fi
			;;
		esac
	done

	# new branch without set type and project (too vague)
	if [[ $NEW_BRANCH ]] && [[ ${#PROJECT[@]} -ne 1 || ${#TYPE[@]} -ne 1 ]]; then
		echo ERROR - new branch must explicitly define type and project
		return 1
	elif [[ -z $ID ]]; then
		echo ERROR - must define issue id
		return 1
	else
		# not checking out new branch, cycle through issue and project types (if not defined) until correct branch found
		for PROJ in ${PROJECT[@]}; do
			for TYP in ${TYPE[@]}; do
				git checkout $NEW_BRANCH "$TYP/$PROJ-$ID" && return 1
			done
		done
	fi
}

__git_reset_current_branch() {
    branchname=`git rev-parse --symbolic-full-name --abbrev-ref HEAD`
    git fetch origin
    echo "resetting to origin/$branchname"
    git reset --hard origin/$branchname
}
