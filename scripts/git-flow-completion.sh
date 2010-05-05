#!bash
#
# git-flow-completion
# ===================
# 
# Bash completion support for [git-flow](http://github.com/nvie/gitflow)
# 
# The contained completion routines provide support for completing:
# 
#  * git-flow init and version
#  * feature, hotfix and release branches
#  * remote feature branch names (for `git-flow feature track`)
# 
# 
# Installation
# ------------
# 
# To achieve git-flow completion nirvana:
# 
#  0. Install git-completion.
# 
#  1. Install this file. Either:
# 
#     a. Place it in a `bash-completion.d` folder:
# 
#        * /etc/bash-completion.d
#        * /usr/local/etc/bash-completion.d
#        * ~/bash-completion.d
# 
#     b. Or, copy it somewhere (e.g. ~/.git-flow-completion.sh) and put the following line in
#        your .bashrc:
# 
#            source ~/.git-flow-completion.sh
# 
#  3. Edit git-completion.sh and add the following line to the giant $command case in _git:
# 
#         flow)        _git_flow ;;
# 
# 
# Requirement 3 will go away as soon as I figure out how to properly (and predictably) hijack
# the `complete -F` ownership for `git` without breaking regular `git-completion`...
# 
# 
# 
# The Fine Print
# --------------
# 
# Copyright (c) 2010 [Justin Hileman](http://justinhileman.com)
# 
# Distributed under the [MIT License](http://creativecommons.org/licenses/MIT/)

_git_flow ()
{
	local subcommands="init feature release hotfix"
	local subcommand="$(__git_find_on_cmdline "$subcommands")"
	if [ -z "$subcommand" ]; then
		__gitcomp "$subcommands"
		return
	fi

	case "$subcommand" in
	feature)
		__git_flow_feature
		return
		;;
	release)
		__git_flow_release
		return
		;;
	hotfix)
		__git_flow_hotfix
		return
		;;
	*)
		COMPREPLY=()
		;;
	esac
}

__git_flow_feature ()
{
	local subcommands="list start finish publish track diff rebase"
	local subcommand="$(__git_find_on_cmdline "$subcommands")"
	if [ -z "$subcommand" ]; then
		__gitcomp "$subcommands"
		return
	fi

	case "$subcommand" in
	finish|publish|diff|rebase)
		__gitcomp "$(__git_flow_list_features)"
		return
		;;
	track)
		__gitcomp "$(__git_flow_list_remote_features)"
		return
		;;
	*)
		COMPREPLY=()
		;;
	esac
}

__git_flow_list_features ()
{
	git flow feature list  2> /dev/null
}

__git_flow_list_remote_features ()
{
	git branch -r 2> /dev/null | grep 'origin/feature/' | awk '{ sub(/^origin\/feature\//, "", $1); print }'
}

__git_flow_release ()
{
	local subcommands="list start finish"
	local subcommand="$(__git_find_on_cmdline "$subcommands")"
	if [ -z "$subcommand" ]; then
		__gitcomp "$subcommands"
		return
	fi
	
	case "$subcommand" in
	finish)
		__gitcomp "$(__git_flow_list_releases)"
		return
		;;
	*)
		COMPREPLY=()
		;;
	esac

}

__git_flow_list_releases ()
{
	git flow release list 2> /dev/null
}

__git_flow_hotfix ()
{
	local subcommands="list start finish"
	local subcommand="$(__git_find_on_cmdline "$subcommands")"
	if [ -z "$subcommand" ]; then
		__gitcomp "$subcommands"
		return
	fi

	case "$subcommand" in
	finish)
		__gitcomp "$(__git_flow_list_hotfixes)"
		return
		;;
	*)
		COMPREPLY=()
		;;
	esac
}

__git_flow_list_hotfixes ()
{
	git flow hotfix list 2> /dev/null
}
