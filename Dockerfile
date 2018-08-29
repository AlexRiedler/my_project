ARG ALPINE_VERSION=3.8
ARG ELIXIR_VERSION=1.7.3

# -------------
#  BUILD IMAGE
# -------------

# prepare build image
FROM elixir:${ELIXIR_VERSION}-alpine as build

# name of application/release
ARG APP_NAME

# version that is being built
ARG APP_VSN

# environment to build for
ARG MIX_ENV=prod

ENV APP_NAME=${APP_NAME} \
    APP_VSN=${APP_VSN} \
    MIX_ENV=${MIX_ENV}

WORKDIR /opt/app

# install build dependencies
RUN apk update && \
    apk --no-cache upgrade && \
    apk --no-cache add \
      git \
      nodejs-npm \
      build-base

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# copy over app source code into build container (see .dockerignore)
COPY . .

# install mix dependencies and compile
RUN mix do deps.get, deps.compile

# build phoenix assets, and manifest.json (for webpack) required by compile step
COPY assets assets
RUN cd assets && \
    rm -rf node_modules && \
    npm install && \
    npm run deploy

# build release
RUN mkdir -p /release && \
    mix release --verbose && \
    cp _build/${MIX_ENV}/rel/${APP_NAME}/releases/${APP_VSN}/${APP_NAME}.tar.gz /release && \
    cd /release && \
    tar -xzf ${APP_NAME}.tar.gz && \
    rm ${APP_NAME}.tar.gz

# ---------------
#  RELEASE IMAGE
# ---------------

# prepare release image
FROM alpine:${ALPINE_VERSION} as release

# name of application/release
ARG APP_NAME

RUN apk --no-cache update && \
    apk --no-cache add \
      bash \
      ncurses-libs \
      openssl \
      openssl-dev \
      ca-certificates

# setup so the application does not run as root
RUN mkdir -p /opt/app && chown -R nobody: /opt/app
USER nobody
WORKDIR /opt/app

COPY --from=build /release ./

# environment setup
ENV REPLACE_OS_VARS=true \
    APP_NAME=${APP_NAME} \
    HTTP_PORT=4000 \
    BEAM_PORT=14000 \
    ERL_EPMD_PORT=24000

EXPOSE $HTTP_PORT $BEAM_PORT $ERL_EPMD_PORT

# start command
CMD trap 'exit' INT; /opt/app/bin/${APP_NAME} foreground
ENTRYPOINT ["/bin/bash"]
