# Use the official Ruby base image
FROM ruby:3.2.2-slim

# Set metadata for the image
LABEL maintainer="krshnaprsad@gmail.com"
LABEL description="Base Ruby image with essential tools and configurations for Ruby projects."

# Install basic dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    libssl-dev \
    zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Install Bundler globally
RUN gem install bundler

# Default command for derived images
CMD ["irb"]