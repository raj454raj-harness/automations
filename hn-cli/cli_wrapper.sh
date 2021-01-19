#!/bin/bash

# Uncomment for debugging purpose
# set -x

# Update this with your location for the portal repo
REPO=~/harness/portal
commit_message="${*:2}"

say_it_out() {
  zoom_ongoing=$(ps -ef | grep "/Applications/zoom.us.app/Contents/Frameworks/cpthost.app/Contents/MacOS/CptHost" | grep -v grep | wc -l | awk '{print $1}')
  if [[ $zoom_ongoing == "1" ]]; then
    echo "Zoom meeting ongoing, just sending badge!"
    command="$@"
    /usr/bin/osascript -e "display notification \"${command}\" with title \"Command done\""
  else
    echo "Zoom not ongoing"
    say "$@"
  fi
}

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
  PROJECTS="BT|CCE|CCM|CDC|CDNG|CDP|CE|CI|CV|CVNG|DEL|DOC|DX|ER|OPS|PL|SEC|SWAT|GTM"
  branch_name=$(get_branch_name)
  task_id=$(grep -iE --only-matching "($PROJECTS)\-\d+" <<< $branch_name)
  echo $(tr '[:lower:]' '[:upper:]' <<< "$task_id")
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
    say_it_out build done
    ;;
  format)
    bazel_format_build_files
    git_clang_format
    say_it_out format done
    ;;
  commit)
    git_commit
    say_it_out git commit done
    ;;
  push)
    git_push
    say_it_out git push done
    create_pull_request
    ;;
  clean)
    clean_m2_completely
    say_it_out clean done
    ;;
  clean_install)
    clean_m2_completely
    bazel_script_sh
    mvn_clean_install
    say_it_out clean install done
    ;;
  bazel)
    bazel_script_sh
    say_it_out bazel script done
    ;;
  mvn)
    mvn_clean_install
    say_it_out mvn clean done
    ;;
esac
