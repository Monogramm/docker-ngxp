FROM openjdk:jdk

LABEL maintainer="mathieu.brunot at monogramm"

ENV NODE_VERSION 8.11.3
ENV ANDROID_VERSION 4333796

# Install the runtime libraries for the ia32/i386 architecture and G++ compiler
# also create node group / user
RUN set -ex; \
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

# download and extract android sdk
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
		"platforms;android-25" \
		"build-tools;27.0.3" \
		"extras;android;m2repository" \
		"extras;google;m2repository" \
	> /dev/null 2>&1

# gpg keys listed at https://github.com/nodejs/node#release-team
RUN set -ex; \
	for key in \
		94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
		FD3A5288F042B6850C66B31F09FE44734EB7990E \
		71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
		DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
		C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
		B9AE9905FFD7803F25714661B63B535A4C206CA9 \
		56730D5401028683275BD23C23EFEFE93C4CFFFE \
		77984A986EBC2AA786BC0F66B01FBB92821C587A \
	; do \
		gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
		gpg --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
		gpg --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
	done

# Install the latest Node.js stable official release
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
	&& curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH.tar.xz" \
	&& curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
	&& gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
	&& grep " node-v$NODE_VERSION-linux-$ARCH.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
	&& tar -xJf "node-v$NODE_VERSION-linux-$ARCH.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
	&& rm "node-v$NODE_VERSION-linux-$ARCH.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
	&& ln -s /usr/local/bin/node /usr/local/bin/nodejs

# Install the NativeScript and Angular CLI
RUN set -ex; \
	npm install -g --unsafe-perm \
		nativescript \
		@angular/cli \
	; \
	tns setup; \
	rm -rf /var/lib/apt/lists/*

ENV GRADLE_USER_HOME /src/gradle
VOLUME /src
WORKDIR /src

# Install SDK build tools
RUN set -ex; \
	sdkmanager \
		"tools" \
		"platform-tools" \
		"platforms;android-26" \
		"build-tools;26.0.3" \
		"extras;android;m2repository" \
		"extras;google;m2repository"

CMD [ "node" ]
