FROM node:18

RUN apt-get update && apt-get install -y git nginx

COPY contracts/nginx.conf /etc/nginx/nginx.conf

WORKDIR /account-abstraction

RUN git clone --recurse-submodules https://github.com/stackup-wallet/contracts.git .

RUN git fetch && git checkout ada72684273699d4b8ac3cbc61865b5410ddb324

RUN cp .env.example .env

RUN yarn install

RUN yarn run compile

COPY contracts/run.sh /run.sh

ENTRYPOINT ["/run.sh"]
