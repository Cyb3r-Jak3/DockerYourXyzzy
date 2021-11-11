FROM davidcaste/alpine-tomcat:jdk8tomcat7 as base

# MAVEN
ARG MAVEN_VERSION=3.5.4
ENV USER_HOME_DIR /root
ARG SHA=ce50b1c91364cb77efe3776f756a6d92b76d9038b0a0782f7d53acf1e997a14d
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries
ARG MAVEN_HOME=/usr/share/maven
ARG MAVEN_CONFIG="$USER_HOME_DIR/.m2"

RUN apk add --no-cache curl tar procps \
 && mkdir -p /usr/share/maven/ref \
 && curl -fsSL -o /tmp/apache-maven.tar.gz "${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz" \
 && echo "${SHA} /tmp/apache-maven.tar.gz" | sha256sum -c - || true \
 && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
 && rm -f /tmp/apache-maven.tar.gz \
 && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn


# Final stage for on-demand image
FROM base as on-demand
# PYX
ADD scripts/default.sh scripts/overrides.sh /
ENV GIT_BRANCH master

RUN apk add dos2unix git --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community/ --allow-untrusted \
  && dos2unix /default.sh /overrides.sh \
  && git clone -b $GIT_BRANCH https://github.com/ajanata/PretendYoureXyzzy.git /project \
  && apk del dos2unix git \
  && chmod +x /default.sh /overrides.sh \
  && mkdir /overrides

ADD ./overrides/settings-docker.xml /usr/share/maven/ref/
VOLUME [ "/overrides" ]

WORKDIR /project
CMD [ "/default.sh" ]

# Build stage for pre-buit image
FROM base as builder

ENV GIT_BRANCH master

RUN apk add git --no-cache \
  && git clone -b $GIT_BRANCH https://github.com/ajanata/PretendYoureXyzzy.git /project

ADD overrides/settings-docker.xml /usr/share/maven/ref/
WORKDIR /project

RUN mv build.properties.example build.properties \
  && mvn compile war:war -Dhttps.protocols=TLSv1.2 -Dmaven.buildNumber.doCheck=false -Dmaven.buildNumber.doUpdate=false


# Final stage for pre-built image
FROM jetty:9-jre11-slim as prebuilt

COPY --from=builder /project/target/ZY.war /var/lib/jetty/webapps/ROOT.war

CMD [ "java", "-jar", "/usr/local/jetty/start.jar" ]