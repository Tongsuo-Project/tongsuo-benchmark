FROM ubuntu:18.04

ENV GITHUB_PAT ""
ENV GITHUB_ORG_NAME ""
ENV RUNNER_WORKDIR "_work"
ENV RUNNER_LABELS ""

RUN apt-get update \
    && apt-get install -y curl sudo git jq iputils-ping zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && curl https://download.docker.com/linux/static/stable/x86_64/docker-20.10.7.tgz --output docker-20.10.7.tgz \
    && tar xvfz docker-20.10.7.tgz \
    && cp docker/* /usr/bin/

RUN useradd -m runner \
    && usermod -aG sudo runner \
    && echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && apt-get install -y gcc make tzdata

RUN echo "Asia/Shanghai" > /etc/timezone \
    && rm -f /etc/localtime \
    && export DEBIAN_FRONTEND=noninteractive \
    && dpkg-reconfigure -f noninteractive tzdata

RUN apt install -y gcc libssl-dev libcurl4-openssl-dev zlib1g-dev make gettext wget
RUN wget https://www.kernel.org/pub/software/scm/git/git-2.28.0.tar.gz \
    && tar --no-same-owner --no-same-permissions -xvzf git-2.28.0.tar.gz && cd git-2.28.0 \
    && ./configure --prefix=/usr/ \
    && make && make install

RUN git config --global http.postBuffer 524288000
RUN echo "export GIT_TRACE_PACKET=1" >> /home/runner/.bashrc \
    && echo "export GIT_TRACE=1" >> /home/runner/.bashrc \
    && echo "export GIT_CURL_VERBOSE=1" >> /home/runner/.bashrc

RUN apt install -y python3 python3-pip
RUN pip3 install parse pymysql

RUN apt install -y vim

#USER root
#WORKDIR /root/
USER runner
WORKDIR /home/runner/

#COPY ./actions-runner-linux-x64-2.291.1.tar.gz ./
RUN wget https://ghproxy.com/https://github.com/actions/runner/releases/download/v2.291.1/actions-runner-linux-x64-2.291.1.tar.gz
RUN tar --no-same-owner --no-same-permissions -xvzf ./actions-runner-linux-x64-2.291.1.tar.gz && sudo ./bin/installdependencies.sh

COPY --chown=runner:runner entrypoint.sh runsvc.sh speed_parse.py ./
RUN sudo chmod u+x ./entrypoint.sh ./runsvc.sh ./speed_parse.py

ENTRYPOINT ["/home/runner/entrypoint.sh"]
