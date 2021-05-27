FROM openjdk:11.0-jre-stretch

LABEL maintainer="Alexander Woollam <x@w5m.io>"

ENV SONAR_SCANNER_MSBUILD_VERSION=5.2.1.31210 \
    SONAR_SCANNER_VERSION=8.5.1 \
    DOTNET_SDK_VERSION=5.0 \
    SONAR_SCANNER_MSBUILD_HOME=/opt/sonar-scanner-msbuild \
    DOTNET_PROJECT_DIR=/project \
    DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true \
    DOTNET_CLI_TELEMETRY_OPTOUT=true
  
RUN apt-get update \
  && apt-get install \
    curl \
    libunwind8 \
    gettext \
    apt-transport-https \
    wget \
    unzip \
    -y

RUN wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
  &&  dpkg -i packages-microsoft-prod.deb

RUN  apt-get update \
  && apt-get install -y dotnet-sdk-$DOTNET_SDK_VERSION

RUN dotnet tool install --global dotnet-sonarscanner

ENV PATH="$PATH:/root/.dotnet/tools"

COPY run.sh $SONAR_SCANNER_MSBUILD_HOME/sonar-scanner-$SONAR_SCANNER_VERSION/bin/

VOLUME $DOTNET_PROJECT_DIR
WORKDIR $DOTNET_PROJECT_DIR

ENTRYPOINT ["run.sh"]
