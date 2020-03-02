FROM ruby:2.6.1-alpine

ENV CONTAINER_ROOT /app
RUN mkdir -p $CONTAINER_ROOT
WORKDIR $CONTAINER_ROOT

COPY Gemfile Gemfile.lock $CONTAINER_ROOT/

RUN bundle install

COPY . $CONTAINER_ROOT/

ENTRYPOINT ["ruby", "s3secrets.rb"]
