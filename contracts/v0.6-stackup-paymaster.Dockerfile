FROM node:18

RUN apt-get update && apt-get install -y git nginx

COPY contracts/nginx.conf /etc/nginx/nginx.conf

WORKDIR /account-abstraction

RUN git clone --recurse-submodules https://github.com/stackup-wallet/contracts.git .

RUN git fetch && git checkout e5e5229de7c729cc93628da80f75bd355cc42b07

RUN cp .env.example .env

RUN yarn install

RUN yarn run compile

COPY contracts/run.sh /run.sh

ENTRYPOINT ["/run.sh"]
