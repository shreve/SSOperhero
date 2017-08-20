FROM elixir:latest

ENV PHOENIX_VERSION 1.3.0

# install the Phoenix Mix archive
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new-$PHOENIX_VERSION.ez
RUN mix local.hex --force \
    && mix local.rebar --force

WORKDIR /app

RUN apt-get update -qq && apt-get upgrade -yq
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -yq build-essential nodejs

ADD mix.exs /app/
ADD mix.lock /app/
ADD deps /app/
RUN mix do deps.get, deps.compile
RUN mix compile

ADD package.json /app/
ADD node_modules /app/
ADD brunch-config.js /app/
RUN npm install
RUN npm run-script deploy

ADD . /app/

RUN mix phx.server