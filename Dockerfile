FROM ruby:2.7-alpine3.11

RUN mkdir /app
WORKDIR /app

COPY source/Gemfile* /app/
RUN bundle config set path '/vendor/bundle' \
    && bundle install --jobs=4
