# Gunakan image Ruby Alpine sebagai base image
FROM ruby:2.7.2-alpine

# Install dependencies yang dibutuhkan
RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    nodejs \
    yarn \
    tzdata

# Set timezone ke UTC
ENV TZ=UTC

# Buat direktori kerja di dalam container
WORKDIR /app

# Install bundler
RUN gem install bundler

# Salin file Gemfile dan Gemfile.lock ke dalam direktori kerja
COPY Gemfile Gemfile.lock ./

# Install gems dari Gemfile
RUN bundle install --jobs=$(nproc) --retry=3

# Salin seluruh kode aplikasi ke dalam direktori kerja
COPY . .

# Lakukan migrasi db
RUN bundle exec rake db:migrate

# Expose port 3000
EXPOSE 3000

# Jalankan perintah rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
