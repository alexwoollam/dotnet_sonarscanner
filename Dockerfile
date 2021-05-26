FROM openjdk:11.0-jre-stretch

LABEL maintainer="Alexander Woollam <x@w5m.io>"

ENV SONAR_SCANNER_MSBUILD_VERSION=4.3.1.1372 \
    SONAR_SCANNER_VERSION=3.2.0.1227 \
    DOTNET_SDK_VERSION=5.0 \
    MONO_DEBIAN_VERSION=5.12.0.226-0xamarin3+debian9b1 \
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
  
RUN wget https://github.com/SonarSource/sonar-scanner-msbuild/releases/download/$SONAR_SCANNER_MSBUILD_VERSION/sonar-scanner-msbuild-$SONAR_SCANNER_MSBUILD_VERSION-net46.zip -O /opt/sonar-scanner-msbuild.zip \
  && mkdir -p $SONAR_SCANNER_MSBUILD_HOME \
  && mkdir -p $DOTNET_PROJECT_DIR \
  && unzip /opt/sonar-scanner-msbuild.zip -d $SONAR_SCANNER_MSBUILD_HOME \
  && rm /opt/sonar-scanner-msbuild.zip \
  && chmod 775 $SONAR_SCANNER_MSBUILD_HOME/*.exe \
  && chmod 775 $SONAR_SCANNER_MSBUILD_HOME/**/bin/* \
  && chmod 775 $SONAR_SCANNER_MSBUILD_HOME/**/lib/*.jar

ENV PATH="$SONAR_SCANNER_MSBUILD_HOME:$SONAR_SCANNER_MSBUILD_HOME/sonar-scanner-$SONAR_SCANNER_VERSION/bin:${PATH}"

COPY run.sh $SONAR_SCANNER_MSBUILD_HOME/sonar-scanner-$SONAR_SCANNER_VERSION/bin/

VOLUME $DOTNET_PROJECT_DIR
WORKDIR $DOTNET_PROJECT_DIR

ENTRYPOINT ["run.sh"]
