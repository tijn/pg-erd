FROM ruby:3.0-alpine as base

RUN apk --no-cache add build-base postgresql-client postgresql-dev graphviz
RUN gem install bundler

COPY Gemfile Gemfile.lock ./
RUN bundle update --bundler
RUN bundle install

COPY . .

ENTRYPOINT bin/pg-erd-everything
