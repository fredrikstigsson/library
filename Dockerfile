FROM ubuntu:21.04

RUN echo 'Setting up ZXing dev environment...'
# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# make sure apt is up to date
RUN apt-get update --fix-missing
RUN apt-get install -y curl

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 12.19.0
ENV YARN_VERSION 1.22.10
ENV TERSER_VERSION 5.7.0
ENV APP_PATH zxing-js/library

RUN mkdir ${NVM_DIR}

# Install nvm with node and npm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default \
    && nvm --version \ 
    && sleep 1

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

WORKDIR /usr/src/${APP_PATH}

RUN mkdir /usr/src/${APP_PATH}/dist
RUN mkdir /usr/src/${APP_PATH}/src

RUN npm install -g yarn@1.22.10
RUN npm install -g terser@5.7.0

RUN source $NVM_DIR/nvm.sh && \
    nvm --version && sleep 1
RUN node --version && sleep 1
RUN npm --version && sleep 1
RUN yarn --version && sleep 1
RUN terser --version && sleep 1
RUN gzip --version | grep gzip && sleep 1

COPY [".", "./"]

RUN npm install

