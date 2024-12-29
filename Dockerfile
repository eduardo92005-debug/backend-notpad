FROM elixir:1.18
WORKDIR /app
RUN apt-get update && \
    apt-get install -y inotify-tools && \
    apt-get clean
RUN mix local.hex --force && \
    mix archive.install hex phx_new 1.7.18 --force && \
    mix local.rebar --force
COPY . .
RUN mix do deps.get, deps.compile
EXPOSE 4000
CMD ["mix", "phx.server"]
