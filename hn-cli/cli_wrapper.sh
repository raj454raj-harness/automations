#!/bin/bash

# Uncomment for debugging purpose
# set -x

# Update this with your location for the portal repo
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

create_pull_request() {
  pr_not_created=$(gh pr status | grep -E "(There is no pull request associated with|\- Closed$)")
  if [[ ! -z $pr_not_created ]]; then
    # This will prompt for the relevant pr metadata
    gh pr create
  fi
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

clean_m2_completely() {
  rm -rf ~/.m2/repository/software/wings
  rm -rf ~/.m2/repository/io/harness/cv
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
    create_pull_request
    ;;
  clean)
    clean_m2_completely
    say clean done
    ;;
  clean_install)
    clean_m2_completely
    bazel_script_sh
    mvn_clean_install
    say clean install done
    ;;
  bazel)
    bazel_script_sh
    say bazel script done
    ;;
  mvn)
    mvn_clean_install
    say mvn clean done
    ;;
esac
