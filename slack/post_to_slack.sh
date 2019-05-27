#!/bin/bash

# [description]
#     This script posts a message to Slack, using a webhook.
# [usage]
#     ./.ci/post_to_slack.sh ${SLACK_WEBHOOK} '#some-alert-channel' 'test message'
# [author]
#     https://github.com/austin3dickey

SLACK_WEBHOOK=${1}
CHANNEL=${2}
MESSAGE=${3}

curl -X POST \
    -H 'Content-type: application/json' \
    -d '{
        "channel": "'"${CHANNEL}"'",
        "text": "'"${MESSAGE}"'"
    }' \
    ${SLACK_WEBHOOK}
