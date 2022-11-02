FROM gcr.io/registry-public/ruby:v2-stable as base

ENV CONTAINER_ROOT /app
RUN mkdir -p $CONTAINER_ROOT
WORKDIR $CONTAINER_ROOT

FROM base as test
COPY Gemfile Gemfile.lock $CONTAINER_ROOT/
RUN bundle install
COPY . $CONTAINER_ROOT/
ENTRYPOINT ["ruby", "s3secrets.rb"]

FROM base as release
COPY Gemfile Gemfile.lock $CONTAINER_ROOT/
RUN bundle install --without=test
COPY lib $CONTAINER_ROOT/lib
COPY s3secrets.rb Rakefile LICENSE $CONTAINER_ROOT/

ENTRYPOINT ["ruby", "s3secrets.rb"]
