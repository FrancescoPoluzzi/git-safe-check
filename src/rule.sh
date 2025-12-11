#!/bin/bash
# Rule set for git-safe-check

# Associative arrays require Bash 4 or later
declare -A GSC_RULES_BY_CMD
declare -A GSC_RULE_MATCHES
declare -A GSC_RULE_MESSAGE
declare -A GSC_RULE_SEVERITY

GSC_RULES_BY_CMD[push]="push_force push_delete_remote push_basic"
GSC_RULES_BY_CMD[pull]="pull_basic"
GSC_RULES_BY_CMD[fetch]="fetch_prune"
GSC_RULES_BY_CMD[rebase]="rebase_basic"
GSC_RULES_BY_CMD[reset]="reset_hard"
GSC_RULES_BY_CMD[commit]="commit_amend"
GSC_RULES_BY_CMD[revert]="revert_basic"
GSC_RULES_BY_CMD[cherry-pick]="cherry_pick_basic"
GSC_RULES_BY_CMD[checkout]="checkout_files"
GSC_RULES_BY_CMD[switch]="switch_branch"
GSC_RULES_BY_CMD[restore]="restore_files restore_staged"
GSC_RULES_BY_CMD[merge]="merge_basic merge_ours_theirs"
GSC_RULES_BY_CMD[stash]="stash_push stash_apply stash_drop_clear"
GSC_RULES_BY_CMD[clean]="clean_basic clean_include_ignored"
GSC_RULES_BY_CMD[rm]="rm_basic"
GSC_RULES_BY_CMD[branch]="branch_delete"
GSC_RULES_BY_CMD[tag]="tag_delete"
GSC_RULES_BY_CMD[remote]="remote_prune"
GSC_RULES_BY_CMD[submodule]="submodule_update submodule_update_recursive"
GSC_RULES_BY_CMD[reflog]="reflog_expire"
GSC_RULES_BY_CMD[gc]="gc_prune"

# Rule: push_force (push)
GSC_RULE_MATCHES[push_force]="--force --force-with-lease -f"
GSC_RULE_SEVERITY[push_force]="confirm"
GSC_RULE_MESSAGE[push_force]="You are about to force push and overwrite remote history on the remote repository. Other collaborators may lose their work or see their history rewritten."

# Rule: push_delete_remote (push)
GSC_RULE_MATCHES[push_delete_remote]="--delete -d"
GSC_RULE_SEVERITY[push_delete_remote]="confirm"
GSC_RULE_MESSAGE[push_delete_remote]="You are about to delete a branch or tag on the remote repository. After this, others will no longer see it and recovery can be difficult."

# Rule: push_basic (push)
GSC_RULE_MATCHES[push_basic]=""
GSC_RULE_SEVERITY[push_basic]="confirm"
GSC_RULE_MESSAGE[push_basic]="You are about to publish local commits to the remote repository and make them visible to others."

# Rule: pull_basic (pull)
GSC_RULE_MATCHES[pull_basic]=""
GSC_RULE_SEVERITY[pull_basic]="confirm"
GSC_RULE_MESSAGE[pull_basic]="You are about to pull remote changes into your current branch. This may create merges or conflicts and can overwrite local changes if they are not committed."

# Rule: fetch_prune (fetch)
GSC_RULE_MATCHES[fetch_prune]="--prune -p"
GSC_RULE_SEVERITY[fetch_prune]="confirm"
GSC_RULE_MESSAGE[fetch_prune]="You are about to prune remote tracking references. This removes local references to branches deleted on the server and may hide work you were relying on."

# Rule: rebase_basic (rebase)
GSC_RULE_MATCHES[rebase_basic]=""
GSC_RULE_SEVERITY[rebase_basic]="confirm"
GSC_RULE_MESSAGE[rebase_basic]="You are about to rewrite commit history with rebase. This changes the timeline of your commits and can be dangerous on branches shared with others."

# Rule: reset_hard (reset)
GSC_RULE_MATCHES[reset_hard]="--hard"
GSC_RULE_SEVERITY[reset_hard]="confirm"
GSC_RULE_MESSAGE[reset_hard]="You are about to reset the current branch and working directory with a hard reset. All uncommitted local changes will be discarded permanently."

# Rule: commit_amend (commit)
GSC_RULE_MATCHES[commit_amend]="--amend"
GSC_RULE_SEVERITY[commit_amend]="confirm"
GSC_RULE_MESSAGE[commit_amend]="You are about to amend the last commit. If it has already been pushed, this rewrites history and may require collaborators to reconcile their local copies."

# Rule: revert_basic (revert)
GSC_RULE_MATCHES[revert_basic]=""
GSC_RULE_SEVERITY[revert_basic]="confirm"
GSC_RULE_MESSAGE[revert_basic]="You are about to create a revert commit that undoes existing work. This will add a new commit that reverses earlier changes and may be hard to undo cleanly."

# Rule: cherry_pick_basic (cherry-pick)
GSC_RULE_MATCHES[cherry_pick_basic]=""
GSC_RULE_SEVERITY[cherry_pick_basic]="confirm"
GSC_RULE_MESSAGE[cherry_pick_basic]="You are about to cherry pick commits onto this branch. This can duplicate history or introduce conflicts if the commits were not designed for this branch."

# Rule: checkout_files (checkout)
GSC_RULE_MATCHES[checkout_files]="--"
GSC_RULE_SEVERITY[checkout_files]="confirm"
GSC_RULE_MESSAGE[checkout_files]="You are about to restore specific files with checkout. Local changes in those files will be discarded and cannot be recovered easily."

# Rule: switch_branch (switch)
GSC_RULE_MATCHES[switch_branch]=""
GSC_RULE_SEVERITY[switch_branch]="confirm"
GSC_RULE_MESSAGE[switch_branch]="You are about to switch branches. Uncommitted changes may not apply cleanly and can be lost or carried over unexpectedly."

# Rule: restore_files (restore)
GSC_RULE_MATCHES[restore_files]=""
GSC_RULE_SEVERITY[restore_files]="confirm"
GSC_RULE_MESSAGE[restore_files]="You are about to restore tracked files to a previous state. This discards local modifications in those files."

# Rule: restore_staged (restore)
GSC_RULE_MATCHES[restore_staged]="--staged"
GSC_RULE_SEVERITY[restore_staged]="confirm"
GSC_RULE_MESSAGE[restore_staged]="You are about to change what is staged for commit using restore. This can remove changes from the index and alter what will be committed."

# Rule: merge_basic (merge)
GSC_RULE_MATCHES[merge_basic]=""
GSC_RULE_SEVERITY[merge_basic]="confirm"
GSC_RULE_MESSAGE[merge_basic]="You are about to merge another branch into the current one. This may create conflicts or bring in a large set of changes at once."

# Rule: merge_ours_theirs (merge)
GSC_RULE_MATCHES[merge_ours_theirs]="-s ours theirs -Xours -Xtheirs"
GSC_RULE_SEVERITY[merge_ours_theirs]="confirm"
GSC_RULE_MESSAGE[merge_ours_theirs]="You are about to merge using a strategy that favors one side. This may silently discard changes from the other branch."

# Rule: stash_push (stash)
GSC_RULE_MATCHES[stash_push]="push save"
GSC_RULE_SEVERITY[stash_push]="confirm"
GSC_RULE_MESSAGE[stash_push]="You are about to stash your local changes. They will disappear from the working directory and you must remember to reapply them later."

# Rule: stash_apply (stash)
GSC_RULE_MATCHES[stash_apply]="apply pop"
GSC_RULE_SEVERITY[stash_apply]="confirm"
GSC_RULE_MESSAGE[stash_apply]="You are about to reapply stashed changes. This can create conflicts or overwrite current local modifications."

# Rule: stash_drop_clear (stash)
GSC_RULE_MATCHES[stash_drop_clear]="drop clear"
GSC_RULE_SEVERITY[stash_drop_clear]="confirm"
GSC_RULE_MESSAGE[stash_drop_clear]="You are about to delete stashed work. Once dropped, these saved changes are very hard to recover."

# Rule: clean_basic (clean)
GSC_RULE_MATCHES[clean_basic]="-f --force"
GSC_RULE_SEVERITY[clean_basic]="confirm"
GSC_RULE_MESSAGE[clean_basic]="You are about to remove untracked files from your working directory with git clean. Any untracked work or generated data will be deleted."

# Rule: clean_include_ignored (clean)
GSC_RULE_MATCHES[clean_include_ignored]="-x -X"
GSC_RULE_SEVERITY[clean_include_ignored]="confirm"
GSC_RULE_MESSAGE[clean_include_ignored]="You are about to remove ignored files with git clean. This can delete build outputs, local configuration, and other files that may be costly to recreate."

# Rule: rm_basic (rm)
GSC_RULE_MATCHES[rm_basic]=""
GSC_RULE_SEVERITY[rm_basic]="confirm"
GSC_RULE_MESSAGE[rm_basic]="You are about to remove tracked files from the repository. These files will disappear in the next commit and from other clones after you push."

# Rule: branch_delete (branch)
GSC_RULE_MATCHES[branch_delete]="-d -D"
GSC_RULE_SEVERITY[branch_delete]="confirm"
GSC_RULE_MESSAGE[branch_delete]="You are about to delete a local branch. If it contains commits that are not merged elsewhere, that work may become hard to reach."

# Rule: tag_delete (tag)
GSC_RULE_MATCHES[tag_delete]="-d --delete"
GSC_RULE_SEVERITY[tag_delete]="confirm"
GSC_RULE_MESSAGE[tag_delete]="You are about to delete a tag. Other users may rely on this tag to locate a release or important commit."

# Rule: remote_prune (remote)
GSC_RULE_MATCHES[remote_prune]="prune"
GSC_RULE_SEVERITY[remote_prune]="confirm"
GSC_RULE_MESSAGE[remote_prune]="You are about to prune remote tracking references. This can hide branches that exist only in your local copy and make old work harder to reach."

# Rule: submodule_update (submodule)
GSC_RULE_MATCHES[submodule_update]="update"
GSC_RULE_SEVERITY[submodule_update]="confirm"
GSC_RULE_MESSAGE[submodule_update]="You are about to update submodules to their recorded commits. Local changes inside submodules may be overwritten or detached."

# Rule: submodule_update_recursive (submodule)
GSC_RULE_MATCHES[submodule_update_recursive]="--recursive"
GSC_RULE_SEVERITY[submodule_update_recursive]="confirm"
GSC_RULE_MESSAGE[submodule_update_recursive]="You are about to update all nested submodules recursively. This can change many repositories at once and overwrite local work inside them."

# Rule: reflog_expire (reflog)
GSC_RULE_MATCHES[reflog_expire]="expire"
GSC_RULE_SEVERITY[reflog_expire]="confirm"
GSC_RULE_MESSAGE[reflog_expire]="You are about to expire reflog entries. After this, recovering deleted commits that relied on the reflog becomes much harder or impossible."

# Rule: gc_prune (gc)
GSC_RULE_MATCHES[gc_prune]="--prune"
GSC_RULE_SEVERITY[gc_prune]="confirm"
GSC_RULE_MESSAGE[gc_prune]="You are about to run git garbage collection with pruning. Unreachable commits may be removed and will no longer be recoverable with normal tools."
