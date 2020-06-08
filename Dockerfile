FROM amancevice/superset:0.35.2

USER root

RUN pip install "PyAthena>1.2.0"

WORKDIR /tmp/superset

RUN set -x \
    && apt-get update \
    && apt-get install -y libgtk-3-0 xvfb firefox-esr \
    && wget -q "https://github.com/mozilla/geckodriver/releases/download/v0.26.0/geckodriver-v0.26.0-linux64.tar.gz" -O /tmp/geckodriver.tar.gz \
    && tar -x geckodriver -zf /tmp/geckodriver.tar.gz -O > /usr/bin/geckodriver \
    && chmod +x /usr/bin/geckodriver \
    && rm /tmp/geckodriver.tar.gz \
    && wget -q "https://chromedriver.storage.googleapis.com/84.0.4147.30/chromedriver_linux64.zip" -O /tmp/chromedriver.zip \
    && unzip /tmp/chromedriver.zip -d /usr/bin/ \
    && rm /tmp/chromedriver.zip \
    && rm -rf /var/lib/apt/lists/* 

RUN Xvfb :10 -ac &
RUN export DISPLAY=:10

WORKDIR /home/superset

USER superset
