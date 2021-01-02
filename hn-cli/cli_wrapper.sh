#!/bin/bash

REPO=~/harness/portal
commit_message="${*:2}"

mvn_clean_install() {
  mvn clean install -DskipTests
}

bazel_format_build_files() {
  bazel run //:buildifier
}

bazel_script_sh() {
  bash scripts/bazel/bazel_script.sh
}

git_clang_format() {
  git clang-format
}

get_branch_name() {
  echo $(git rev-parse --abbrev-ref HEAD)
}

git_push() {
  git push origin $(get_branch_name)
}

get_jira_task() {
  branch_name=$(get_branch_name)
  echo $(tr '[:lower:]' '[:upper:]' <<< "$branch_name")
}

git_commit() {
  task_name=$(get_jira_task)
  git commit -m "[$task_name]: $commit_message"
}

cd $REPO
case $1 in
  build)
    bazel_script_sh
    mvn_clean_install
    say build done
    ;;
  format)
    bazel_format_build_files
    git_clang_format
    say format done
    ;;
  commit)
    git_commit
    say git commit done
    ;;
  push)
    git_push
    say git push done
    ;;
esac
