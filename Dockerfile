FROM ruby:2.5.1-alpine

ENV CONTAINER_ROOT /app
RUN mkdir -p $CONTAINER_ROOT
WORKDIR $CONTAINER_ROOT

COPY . $CONTAINER_ROOT

RUN bundle install

ENTRYPOINT ["ruby", "s3secrets.rb"]
