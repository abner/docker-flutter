ARG FLUTTER_VERSION=v1.5.4-hotfix.2

FROM cirrusci/flutter:$FLUTTER_VERSION as flutter_base

RUN ls -la /home/cirrus/sdks
FROM budtmo/docker-android-x86-9.0

ARG FLUTTER_VERSION

RUN mkdir -p /opt/sdks

COPY --from=0 /home/cirrus/sdks/flutter /opt/sdks/flutter

ENV FLUTTER_HOME /opt/sdks/flutter
ENV FLUTTER_ROOT /opt/sdks/flutter
ENV FLUTTER_VERSION $FLUTTER_VERSION


RUN apt-get update && apt-get install -y --no-install-recommends git libstdc++6 lib32stdc++6 locales \
  && locale-gen pt_BR.UTF-8 \
  && dpkg-reconfigure locales \
  && update-locale LANG=pt_BR.UTF-8 \
  && rm -rf /var/lib/apt/lists/*

ENV LANG pt_BR.UTF-8
ENV LC_ALL pt_BR.UTF-8
ENV LANGUAGE pt_BR:pt

# RUN git clone --branch ${FLUTTER_VERSION} https://github.com/flutter/flutter.git ${FLUTTER_HOME} --depth 1

ENV PATH ${PATH}:${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin

# doctor
RUN  /root/tools/bin/sdkmanager --verbose --update && flutter doctor --android-licenses && flutter doctor