#!/bin/sh
set -x

# 这里如果直接使用 ./config.sh --url https://github.com/some-github-org --token AF5TxxxxxxxxxxxA6PRRS 的方式注册的话，token 会动态变化，容易导致注册后无法 remove 的问题，所以参考 https://docs.github.com/en/rest/reference/actions#list-self-hosted-runners-for-an-organization 通过 Personal Access Token 动态获取 Runner 的 Token
#registration_url="https://github.com/${GITHUB_ORG_NAME}"
#token_url="https://api.github.com/orgs/${GITHUB_ORG_NAME}/actions/runners/registration-token"
token_url="https://api.github.com/repos/${GITHUB_REPO_NAME}/actions/runners/registration-token"
payload=$(curl -sX POST -H "Authorization: token ${GITHUB_PAT}" ${token_url})
export RUNNER_TOKEN=$(echo $payload | jq .token --raw-output)

if [ -z "${RUNNER_NAME}" ]; then
    RUNNER_NAME=$(hostname)
fi

./config.sh --unattended --url https://github.com/${GITHUB_REPO_NAME} --token ${RUNNER_TOKEN} --labels "${RUNNER_LABELS}"

# 在容器被干掉的时候自动向 GitHub 解除注册 Runner
remove() {
    if [ -n "${GITHUB_RUNNER_TOKEN}" ]; then
        export REMOVE_TOKEN=$GITHUB_RUNNER_TOKEN
    else
        payload=$(curl -sX POST -H "Authorization: token ${GITHUB_PAT}" ${token_url%/registration-token}/remove-token)
        export REMOVE_TOKEN=$(echo $payload | jq .token --raw-output)
    fi

    ./config.sh remove --unattended --token "${RUNNER_TOKEN}"
}

trap 'remove; exit 130' INT
trap 'remove; exit 143' TERM

./runsvc.sh "$*" &

wait $!
