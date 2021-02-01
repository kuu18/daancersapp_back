FROM ruby:2.7.1-alpine

# 必要パッケージのダウンロード
ENV RUNTIME_PACKAGES="linux-headers libxml2-dev make gcc libc-dev nodejs tzdata mysql-dev mysql-client yarn" \
    DEV_PACKAGES="build-base curl-dev" \
    HOME="/app" \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo

RUN mkdir /app
WORKDIR /app

# ホスト（自分のパソコンにあるファイル）から必要ファイルをDocker上にコピー
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock

RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache ${RUNTIME_PACKAGES} && \
    apk add --update --virtual build-dependencies --no-cache ${DEV_PACKAGES} && \
    bundle install -j4 && \
    apk del build-dependencies && \
    mkdir -p tmp/sockets && \
    rm -rf /usr/local/bundle/cache/* \
    /usr/local/share/.cache/* \
    /var/cache/* \
    /tmp/* \
    /usr/lib/mysqld* \
    /usr/bin/mysql*

# ホスト（自分のパソコンにあるファイル）から必要ファイルをDocker上にコピー
ADD . /app

CMD bundle exec puma -C config/puma.rb