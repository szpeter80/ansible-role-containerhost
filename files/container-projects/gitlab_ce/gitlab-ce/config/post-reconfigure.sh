#!/bin/bash
# From: https://gitlab.com/gitlab-org/omnibus-gitlab/-/work_items/2837#note_703706180
set -e

gitlab-rails runner - <<EOS
# - disable signup: https://gitlab.com/gitlab-org/omnibus-gitlab/-/issues/2837
ApplicationSetting.last.update(signup_enabled: false)

# - disable auto-devops 
ApplicationSetting.last.update(auto_devops_enabled: false)

# - Monday is the first day of week... what else?!
ApplicationSetting.last.update(first_day_of_week: 1)

EOS

echo "Post Reconfigure Script successfully executed"
