FROM elixir:1.14.4-erlang-25.1.2-alpine
WORKDIR /app
RUN apk update && apk add --no-cache build-base git curl bash
RUN mix local.hex --force && \
    mix archive.install hex phx_new 1.6.0 --force
COPY mix.exs mix.lock ./
RUN mix deps.get
COPY . .
RUN mix compile
EXPOSE 4000
CMD ["mix", "phx.server"]
