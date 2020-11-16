FROM ruby:2.5.7
RUN apt-get update -qq && apt-get install -y build-essential nodejs vim
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp
