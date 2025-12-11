# Rule set for git safe check on Windows
# Loaded by git-safe-check.ps1

$GscRulesByCommand = @{}

$GscRuleMatches = @{}

$GscRuleSeverity = @{}

$GscRuleMessage = @{}

function Add-GscCommandRules {
    param(
        [string]$Command,
        [string[]]$RuleIds
    )
    $GscRulesByCommand[$Command] = $RuleIds
}

Add-GscCommandRules -Command "push"       -RuleIds @("push_force", "push_delete_remote", "push_basic")
Add-GscCommandRules -Command "pull"       -RuleIds @("pull_basic")
Add-GscCommandRules -Command "fetch"      -RuleIds @("fetch_prune")
Add-GscCommandRules -Command "rebase"     -RuleIds @("rebase_basic")
Add-GscCommandRules -Command "reset"      -RuleIds @("reset_hard")
Add-GscCommandRules -Command "commit"     -RuleIds @("commit_amend")
Add-GscCommandRules -Command "revert"     -RuleIds @("revert_basic")
Add-GscCommandRules -Command "cherry-pick" -RuleIds @("cherry_pick_basic")
Add-GscCommandRules -Command "checkout"   -RuleIds @("checkout_files")
Add-GscCommandRules -Command "switch"     -RuleIds @("switch_branch")
Add-GscCommandRules -Command "restore"    -RuleIds @("restore_staged", "restore_files")
Add-GscCommandRules -Command "merge"      -RuleIds @("merge_ours_theirs", "merge_basic")
Add-GscCommandRules -Command "stash"      -RuleIds @("stash_push", "stash_apply", "stash_drop_clear")
Add-GscCommandRules -Command "clean"      -RuleIds @("clean_basic", "clean_include_ignored")
Add-GscCommandRules -Command "rm"         -RuleIds @("rm_basic")
Add-GscCommandRules -Command "branch"     -RuleIds @("branch_delete")
Add-GscCommandRules -Command "tag"        -RuleIds @("tag_delete")
Add-GscCommandRules -Command "remote"     -RuleIds @("remote_prune")
Add-GscCommandRules -Command "submodule"  -RuleIds @("submodule_update_recursive", "submodule_update")
Add-GscCommandRules -Command "reflog"     -RuleIds @("reflog_expire")
Add-GscCommandRules -Command "gc"         -RuleIds @("gc_prune")

# Rule definitions

# push_force
$GscRuleMatches["push_force"]   = @("--force", "--force-with-lease", "-f")
$GscRuleSeverity["push_force"]  = "confirm"
$GscRuleMessage["push_force"]   = "You are about to force push and overwrite remote history on the remote repository. Other collaborators may lose their work or see their history rewritten."

# push_delete_remote
$GscRuleMatches["push_delete_remote"]  = @("--delete", "-d")
$GscRuleSeverity["push_delete_remote"] = "confirm"
$GscRuleMessage["push_delete_remote"]  = "You are about to delete a branch or tag on the remote repository. After this, others will no longer see it and recovery can be difficult."

# push_basic
$GscRuleMatches["push_basic"]   = @()
$GscRuleSeverity["push_basic"]  = "confirm"
$GscRuleMessage["push_basic"]   = "You are about to publish local commits to the remote repository and make them visible to others."

# pull_basic
$GscRuleMatches["pull_basic"]   = @()
$GscRuleSeverity["pull_basic"]  = "confirm"
$GscRuleMessage["pull_basic"]   = "You are about to pull remote changes into your current branch. This may create merges or conflicts and can overwrite local changes if they are not committed."

# fetch_prune
$GscRuleMatches["fetch_prune"]  = @("--prune", "-p")
$GscRuleSeverity["fetch_prune"] = "confirm"
$GscRuleMessage["fetch_prune"]  = "You are about to prune remote tracking references. This removes local references to branches deleted on the server and may hide work you were relying on."

# rebase_basic
$GscRuleMatches["rebase_basic"]  = @()
$GscRuleSeverity["rebase_basic"] = "confirm"
$GscRuleMessage["rebase_basic"]  = "You are about to rewrite commit history with rebase. This changes the timeline of your commits and can be dangerous on branches shared with others."

# reset_hard
$GscRuleMatches["reset_hard"]   = @("--hard")
$GscRuleSeverity["reset_hard"]  = "confirm"
$GscRuleMessage["reset_hard"]   = "You are about to reset the current branch and working directory with a hard reset. All uncommitted local changes will be discarded permanently."

# commit_amend
$GscRuleMatches["commit_amend"]  = @("--amend")
$GscRuleSeverity["commit_amend"] = "confirm"
$GscRuleMessage["commit_amend"]  = "You are about to amend the last commit. If it has already been pushed, this rewrites history and may require collaborators to reconcile their local copies."

# revert_basic
$GscRuleMatches["revert_basic"]  = @()
$GscRuleSeverity["revert_basic"] = "confirm"
$GscRuleMessage["revert_basic"]  = "You are about to create a revert commit that undoes existing work. This will add a new commit that reverses earlier changes and may be hard to undo cleanly."

# cherry_pick_basic
$GscRuleMatches["cherry_pick_basic"]  = @()
$GscRuleSeverity["cherry_pick_basic"] = "confirm"
$GscRuleMessage["cherry_pick_basic"]  = "You are about to cherry pick commits onto this branch. This can duplicate history or introduce conflicts if the commits were not designed for this branch."

# checkout_files
$GscRuleMatches["checkout_files"]  = @("--")
$GscRuleSeverity["checkout_files"] = "confirm"
$GscRuleMessage["checkout_files"]  = "You are about to restore specific files with checkout. Local changes in those files will be discarded and cannot be recovered easily."

# switch_branch
$GscRuleMatches["switch_branch"]   = @()
$GscRuleSeverity["switch_branch"]  = "confirm"
$GscRuleMessage["switch_branch"]   = "You are about to switch branches. Uncommitted changes may not apply cleanly and can be lost or carried over unexpectedly."

# restore_staged
$GscRuleMatches["restore_staged"]  = @("--staged")
$GscRuleSeverity["restore_staged"] = "confirm"
$GscRuleMessage["restore_staged"]  = "You are about to change what is staged for commit using restore. This can remove changes from the index and alter what will be committed."

# restore_files
$GscRuleMatches["restore_files"]   = @()
$GscRuleSeverity["restore_files"]  = "confirm"
$GscRuleMessage["restore_files"]   = "You are about to restore tracked files to a previous state. This discards local modifications in those files."

# merge_ours_theirs
$GscRuleMatches["merge_ours_theirs"]  = @("-Xours", "-Xtheirs")
$GscRuleSeverity["merge_ours_theirs"] = "confirm"
$GscRuleMessage["merge_ours_theirs"]  = "You are about to merge using a strategy that favors one side. This may silently discard changes from the other branch."

# merge_basic
$GscRuleMatches["merge_basic"]   = @()
$GscRuleSeverity["merge_basic"]  = "confirm"
$GscRuleMessage["merge_basic"]   = "You are about to merge another branch into the current one. This may create conflicts or bring in a large set of changes at once."

# stash_push
$GscRuleMatches["stash_push"]    = @("push", "save")
$GscRuleSeverity["stash_push"]   = "confirm"
$GscRuleMessage["stash_push"]    = "You are about to stash your local changes. They will disappear from the working directory and you must remember to reapply them later."

# stash_apply
$GscRuleMatches["stash_apply"]   = @("apply", "pop")
$GscRuleSeverity["stash_apply"]  = "confirm"
$GscRuleMessage["stash_apply"]   = "You are about to reapply stashed changes. This can create conflicts or overwrite current local modifications."

# stash_drop_clear
$GscRuleMatches["stash_drop_clear"]  = @("drop", "clear")
$GscRuleSeverity["stash_drop_clear"] = "confirm"
$GscRuleMessage["stash_drop_clear"]  = "You are about to delete stashed work. Once dropped, these saved changes are very hard to recover."

# clean_basic
$GscRuleMatches["clean_basic"]   = @("-f", "--force")
$GscRuleSeverity["clean_basic"]  = "confirm"
$GscRuleMessage["clean_basic"]   = "You are about to remove untracked files from your working directory with git clean. Any untracked work or generated data will be deleted."

# clean_include_ignored
$GscRuleMatches["clean_include_ignored"]  = @("-x", "-X")
$GscRuleSeverity["clean_include_ignored"] = "confirm"
$GscRuleMessage["clean_include_ignored"]  = "You are about to remove ignored files with git clean. This can delete build outputs, local configuration, and other files that may be costly to recreate."

# rm_basic
$GscRuleMatches["rm_basic"]      = @()
$GscRuleSeverity["rm_basic"]     = "confirm"
$GscRuleMessage["rm_basic"]      = "You are about to remove tracked files from the repository. These files will disappear in the next commit and from other clones after you push."

# branch_delete
$GscRuleMatches["branch_delete"]  = @("-d", "-D")
$GscRuleSeverity["branch_delete"] = "confirm"
$GscRuleMessage["branch_delete"]  = "You are about to delete a local branch. If it contains commits that are not merged elsewhere, that work may become hard to reach."

# tag_delete
$GscRuleMatches["tag_delete"]    = @("-d", "--delete")
$GscRuleSeverity["tag_delete"]   = "confirm"
$GscRuleMessage["tag_delete"]    = "You are about to delete a tag. Other users may rely on this tag to locate a release or important commit."

# remote_prune
$GscRuleMatches["remote_prune"]   = @("prune")
$GscRuleSeverity["remote_prune"]  = "confirm"
$GscRuleMessage["remote_prune"]   = "You are about to prune remote tracking references. This can hide branches that exist only in your local copy and make old work harder to reach."

# submodule_update
$GscRuleMatches["submodule_update"]   = @("update")
$GscRuleSeverity["submodule_update"]  = "confirm"
$GscRuleMessage["submodule_update"]   = "You are about to update submodules to their recorded commits. Local changes inside submodules may be overwritten or detached."

# submodule_update_recursive
$GscRuleMatches["submodule_update_recursive"]   = @("--recursive")
$GscRuleSeverity["submodule_update_recursive"]  = "confirm"
$GscRuleMessage["submodule_update_recursive"]   = "You are about to update all nested submodules recursively. This can change many repositories at once and overwrite local work inside them."

# reflog_expire
$GscRuleMatches["reflog_expire"]   = @("expire")
$GscRuleSeverity["reflog_expire"]  = "confirm"
$GscRuleMessage["reflog_expire"]   = "You are about to expire reflog entries. After this, recovering deleted commits that relied on the reflog becomes much harder or impossible."

# gc_prune
$GscRuleMatches["gc_prune"]      = @("--prune")
$GscRuleSeverity["gc_prune"]     = "confirm"
$GscRuleMessage["gc_prune"]      = "You are about to run git garbage collection with pruning. Unreachable commits may be removed and will no longer be recoverable with normal tools."
