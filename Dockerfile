FROM ruby:2.7-alpine3.11

RUN apk update && apk upgrade && apk add build-base git

RUN mkdir /app
WORKDIR /app

COPY source/Gemfile* /app/
RUN bundle config set path '/vendor/bundle' \
    && bundle install --jobs=4
