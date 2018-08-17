#!/bin/bash
PROJECT_NAME=my_project

APP_VERSION=$(elixir -S mix run -e 'Application.spec(:my_project, :vsn) |> IO.puts' 2> /dev/null | head -n1)
GIT_REVISION=$(git rev-parse --short HEAD)
GIT_REVISION_ALL_COUNT=$(git rev-list --all --count)
GIT_REVISION_BRANCH_COUNT=$(git rev-list --count HEAD)
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
DATE_YYYYMMDD=$(date +%Y%m%d)

RELEASE_FILE_NAME=${PROJECT_NAME}_${APP_VERSION}+${DATE_YYYYMMDD}-${GIT_BRANCH}-${GIT_REVISION_BRANCH_COUNT}-${GIT_REVISION}.release.tar.gz
RELEASE_FOLDER=.deliver/releases

docker build --no-cache --target build -t ${PROJECT_NAME}:build .

EXTRACT_CONTAINER=${PROJECT_NAME}_extract
docker container create --name ${EXTRACT_CONTAINER} ${PROJECT_NAME}:build  
docker container cp \
  ${EXTRACT_CONTAINER}:/build/_build/prod/rel/${PROJECT_NAME}/releases/${APP_VERSION}/${PROJECT_NAME}.tar.gz \
  ${RELEASE_FOLDER}/${RELEASE_FILE_NAME}
docker container rm -f ${EXTRACT_CONTAINER}
