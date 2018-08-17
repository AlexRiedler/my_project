# Dockerfile
FROM elixir:1.7.2-alpine as build

# install build dependencies
RUN apk add --no-cache --update git nodejs-npm

# prepare build dir
RUN mkdir /build
WORKDIR /build
VOLUME /releases

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config ./
RUN mix deps.get
RUN mix deps.compile

# build code and config over
COPY lib lib
COPY test test
COPY config config
COPY rel rel

# build phoenix assets
COPY assets assets
RUN cd assets && npm install && ./node_modules/.bin/brunch build --production
RUN mix phx.digest

# build release
RUN mix release --verbose

# prepare release image
FROM alpine:3.6 as release

RUN apk --no-cache update && apk --no-cache add bash ncurses-libs openssl ca-certificates

RUN mkdir /app && chown -R nobody: /app
WORKDIR /app
USER nobody

COPY --from=build /build/_build/prod/rel/my_project ./

# environment setup
ENV REPLACE_OS_VARS=true HTTP_PORT=4000 BEAM_PORT=14000 ERL_EPMD_PORT=24000
EXPOSE $HTTP_PORT $BEAM_PORT $ERL_EPMD_PORT

# start command
CMD ["/app/bin/my_project", "foreground"]
ENTRYPOINT ["/app/bin/my_project"]
