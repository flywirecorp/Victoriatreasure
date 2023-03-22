FROM gcr.io/registry-public/ruby:v3-stable

ENV CONTAINER_ROOT /app
RUN mkdir -p $CONTAINER_ROOT
WORKDIR $CONTAINER_ROOT

FROM base as test
COPY Gemfile Gemfile.lock $CONTAINER_ROOT/

RUN apt-get update -y \
    && apt-get install -y build-essential \
    && bundle install \
    && apt-get remove -y build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY . $CONTAINER_ROOT/
ENTRYPOINT ["ruby", "s3secrets.rb"]

FROM base as release
COPY Gemfile Gemfile.lock $CONTAINER_ROOT/
RUN bundle install --without=test
COPY lib $CONTAINER_ROOT/lib
COPY s3secrets.rb Rakefile LICENSE $CONTAINER_ROOT/

ENTRYPOINT ["ruby", "s3secrets.rb"]
