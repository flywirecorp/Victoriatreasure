FROM gcr.io/registry-public/ruby:v3-stable as base

ENV CONTAINER_ROOT /app
RUN mkdir -p $CONTAINER_ROOT
WORKDIR $CONTAINER_ROOT

COPY Gemfile Gemfile.lock $CONTAINER_ROOT/
RUN apt-get update -y \
    && apt-get install -y build-essential --no-install-recommends \
    && bundle install --without=test \
    && apt-get remove -y build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


FROM base as test
RUN bundle install --with=test

COPY . $CONTAINER_ROOT/
ENTRYPOINT ["ruby", "s3secrets.rb"]


FROM base as release

COPY lib $CONTAINER_ROOT/lib
COPY s3secrets.rb Rakefile LICENSE $CONTAINER_ROOT/

ENTRYPOINT ["ruby", "s3secrets.rb"]
