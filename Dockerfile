FROM ruby:3.0-alpine as base

WORKDIR /app

RUN apk --no-cache add build-base postgresql-client postgresql-dev graphviz
RUN gem install bundler

COPY src/Gemfile src/Gemfile.lock ./
RUN bundle update --bundler && bundle install

COPY src .
RUN mkdir -p /output
ENTRYPOINT ["./bin/pg-erd-everything"]
