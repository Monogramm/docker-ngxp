FROM openjdk:8-jdk-slim

LABEL maintainer="Monogramm Maintainers <opensource at monogramm dot io>"

# Install the runtime libraries for the ia32/i386 architecture and G++ compiler
# also create node group / user
RUN set -ex; \
	\
	java -version; \
	\
	apt-get update -q; \
	apt-get install -y --no-install-recommends \
		curl \
		g++ \
		gcc \
        gnupg \
		make \
		python \
		unzip \
	; \
	groupadd --gid 1000 node; \
	useradd --uid 1000 --gid node --shell /bin/bash --create-home node

# gpg keys listed at https://github.com/nodejs/node#release-keys
RUN set -ex; \
	for key in \
		4ED778F539E3634C779C87C6D7062848A1AB005C \
		94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
		71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
		8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
		C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
		DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
		A48C2BEE680E841632CD4E44F07496B3EB3C1762 \
		B9E2F5981AA6E0CD28160D9FF13993A75599653C \
	; do \
		gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
		gpg --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
		gpg --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
	done

# Install the latest Node.js stable official release
ARG NODE_VERSION=12.16.2

RUN set -ex; \
	ARCH= && dpkgArch="$(dpkg --print-architecture)" \
	&& case "${dpkgArch##*-}" in \
		amd64) ARCH='x64';; \
		ppc64el) ARCH='ppc64le';; \
		s390x) ARCH='s390x';; \
		arm64) ARCH='arm64';; \
		armhf) ARCH='armv7l';; \
		i386) ARCH='x86';; \
		*) echo "unsupported architecture"; exit 1 ;; \
	esac \
	&& curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH.tar.gz" \
	&& curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
	&& gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
	&& grep " node-v$NODE_VERSION-linux-$ARCH.tar.gz\$" SHASUMS256.txt | sha256sum -c - \
	&& tar -xzf "node-v$NODE_VERSION-linux-$ARCH.tar.gz" -C /usr/local --strip-components=1 --no-same-owner \
	&& rm "node-v$NODE_VERSION-linux-$ARCH.tar.gz" SHASUMS256.txt.asc SHASUMS256.txt \
	&& ln -s /usr/local/bin/node /usr/local/bin/nodejs \
	&& node --version \
	&& npm --version

# download and extract android sdk
ARG ANDROID_VERSION=4333796

RUN set -ex; \
	curl -sL https://dl.google.com/android/repository/sdk-tools-linux-$ANDROID_VERSION.zip -o android-sdk.zip; \
	unzip -q android-sdk.zip -d /usr/local/android-sdk ; \
	rm -f android-sdk.zip; \
	export ANDROID_HOME='/usr/local/android-sdk'

ENV ANDROID_HOME /usr/local/android-sdk
ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

# Accept android sdk licenses and install packages
RUN ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | sdkmanager --licenses > /dev/null 2>&1
RUN sdkmanager \
		"tools" \
		"platform-tools" \
		"platforms;android-28" \
		"build-tools;28.0.3" \
		"extras;android;m2repository" \
		"extras;google;m2repository" \
	> /dev/null 2>&1 ; \
	\
	sdkmanager --list

# Install the NativeScript and Angular CLI
RUN set -ex; \
	npm install -g --unsafe-perm \
		@angular/cli \
		nativescript \
	; \
	\
	ng --version; \
	\
	tns setup; \
	\
	tns --version; \
	tns info; \
	\
	rm -rf /var/lib/apt/lists/*

ENV GRADLE_USER_HOME=/src/gradle
VOLUME /src
WORKDIR /src

# Install SDK build tools
RUN set -ex; \
	sdkmanager \
		"tools" \
		"platform-tools" \
		"platforms;android-28" \
		"build-tools;28.0.3" \
		"extras;android;m2repository" \
		"extras;google;m2repository" \
	;

CMD [ "node" ]
