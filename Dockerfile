FROM ruby:3.1.2

ENV RAILS_ENV production
ENV BUNDLE_DEPLOYMENT true
ENV BUNDLE_WITHOUT development:test

WORKDIR /magia_sample_app

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - \
&& wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
&& echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
&& apt-get update -qq \
&& apt-get install -y build-essential nodejs yarn

RUN gem install bundler:2.3.17


COPY Gemfile /magia_sample_app/Gemfile
COPY Gemfile.lock /magia_sample_app/Gemfile.lock

RUN bundle install

COPY . /magia_sample_app

RUN bin/rails assets:precompile

COPY entrypoint.sh /magia_sample_app/entrypoint.sh
RUN chmod +x /magia_sample_app/entrypoint.sh
ENTRYPOINT ["/magia_sample_app/entrypoint.sh"]

EXPOSE 3000
