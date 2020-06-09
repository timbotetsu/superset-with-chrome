FROM amancevice/superset:0.35.2

USER root

RUN pip install "PyAthena>1.2.0"

WORKDIR /tmp/superset

ARG FIREFOX_VERSION=77.0.1
ARG GECKODRIVER_VERSION=0.26.0
ARG CHROMEDRIVER_VERSION=84.0.4147.30

RUN set -x \
    && apt-get update -qqy \
    && apt-get -qqy --no-install-recommends install libgtk-3-0 xvfb firefox-esr libavcodec-extra ttf-dejavu fontconfig \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
    && wget --no-verbose -O /tmp/firefox.tar.bz2 "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${FIREFOX_VERSION}/linux-x86_64/en-US/firefox-${FIREFOX_VERSION}.tar.bz2" \
    && apt-get -y purge firefox-esr \
    && rm -rf /opt/firefox \
    && tar -C /opt -xjf /tmp/firefox.tar.bz2 \
    && rm /tmp/firefox.tar.bz2 \
    && mv /opt/firefox /opt/firefox-$FIREFOX_VERSION \
    && ln -fs /opt/firefox-$FIREFOX_VERSION/firefox /usr/bin/firefox \
    && wget -q "https://github.com/mozilla/geckodriver/releases/download/v${GECKODRIVER_VERSION}/geckodriver-v${GECKODRIVER_VERSION}-linux64.tar.gz" -O /tmp/geckodriver.tar.gz \
    && tar -x geckodriver -zf /tmp/geckodriver.tar.gz -O > /usr/bin/geckodriver \
    && chmod +x /usr/bin/geckodriver \
    && rm /tmp/geckodriver.tar.gz \
    && wget -q "https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip" -O /tmp/chromedriver.zip \
    && unzip /tmp/chromedriver.zip -d /usr/bin/ \
    && rm /tmp/chromedriver.zip \
    && rm -rf /var/lib/apt/lists/* 

USER superset

RUN Xvfb :10 -ac &
RUN export DISPLAY=:10

WORKDIR /home/superset
