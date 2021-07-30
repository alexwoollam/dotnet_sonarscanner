#!/bin/bash

set -x

PROJECT_KEY="${PROJECT_KEY:-ConsoleApplication1}"
PROJECT_NAME="${PROJECT_NAME:-ConsoleApplication1}"
DT=$(date '+%d/%m/%Y-%H:%M:%S')
COVERAGE_PATH="${COVERAGE_PATH}"
PROJECT_VERSION="${PROJECT_VERSION:-1.0}"
SONAR_HOST="${HOST:-http://localhost:9000}"
SONAR_LOGIN_KEY="${LOGIN_KEY:-admin}"

dotnet test /p:CollectCoverage=true /p:CoverletOutputFormat=opencover
dotnet build-server shutdown
dotnet sonarscanner begin /k:$PROJECT_KEY /d:sonar.host.url=$HOST /v:$PROJECT_VERSION-$DT /d:sonar.login="$SONAR_LOGIN_KEY" /d:sonar.cs.opencover.reportsPaths="/project/$COVERAGE_PATH"
dotnet build
dotnet sonarscanner end
