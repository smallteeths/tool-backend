FROM golang:1.15

MAINTAINER Razil "503630985@qq.com"

RUN apt-get update -y && \
    apt-get install -y curl \
                       libcurl4 \
                       sudo \
                       ngrep \
                       gnupg

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

RUN apt-get install -y nodejs

CMD [ "node" ]

RUN curl -o- -L https://yarnpkg.com/install.sh | bash

RUN $HOME/.yarn/bin/yarn install

RUN npm install yarn -g

WORKDIR $GOPATH/src/tool-backend

ADD . $GOPATH/src/tool-backend

RUN go mod init

RUN go mod edit -replace=github.com/satori/go.uuid@v1.2.0=github.com/satori/go.uuid@master

RUN GO111MODULE=on go get -d -v ./...

RUN go build -o facemask

EXPOSE 9091

EXPOSE 8000

ENTRYPOINT  ["sudo", "./facemask"]
