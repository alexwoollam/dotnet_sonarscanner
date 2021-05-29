FROM openjdk:11.0-jre-stretch

LABEL maintainer="Alexander Woollam <x@w5m.io>"

ENV SONAR_SCANNER_MSBUILD_VERSION=5.2.1.31210 \
    SONAR_SCANNER_VERSION=8.5.1 \
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

# Install .NET Core SDK
RUN dotnet_sdk_version=5.0.300 \
    && curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/$dotnet_sdk_version/dotnet-sdk-$dotnet_sdk_version-linux-x64.tar.gz \
    && dotnet_sha512='63d24f1039f68abc46bf40a521f19720ca74a4d89a2b99d91dfd6216b43a81d74f672f74708efa6f6320058aa49bf13995638e3b8057efcfc84a2877527d56b6' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -ozxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet \
    && dotnet tool install --global dotnet-sonarscanner

ENV PATH="$PATH:/root/.dotnet/tools:$SONAR_SCANNER_MSBUILD_HOME:$SONAR_SCANNER_MSBUILD_HOME/sonar-scanner-$SONAR_SCANNER_VERSION/bin:${PATH}"

COPY run.sh $SONAR_SCANNER_MSBUILD_HOME/sonar-scanner-$SONAR_SCANNER_VERSION/bin/

VOLUME $DOTNET_PROJECT_DIR
WORKDIR $DOTNET_PROJECT_DIR

ENTRYPOINT ["run.sh"]
