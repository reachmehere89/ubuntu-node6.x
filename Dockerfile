#
# Ubuntu Dockerfile
#
# https://github.com/dockerfile/ubuntu
#

# Pull base image.
FROM ubuntu:14.04

# Install.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y byobu curl git htop man unzip vim wget make ca-certificates && \
  rm -rf /var/lib/apt/lists/*

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root

# Define default command.
CMD ["bash"]
RUN apt-get update

# Install cloudfoundry-cli
RUN curl -L "https://cli.run.pivotal.io/stable?release=linux64-binary&source=github" | tar -zx
RUN mv cf /usr/local/bin

# Install app dependencies

RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - && apt-get install -qy g++ gcc python nodejs && \
  node -v && \
  npm install --quiet node-gyp -g
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - 
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update && apt-get install -qy google-chrome-stable
RUN google-chrome --version
RUN apt-get update && \
    apt-get upgrade -y && \
    add-apt-repository ppa:openjdk-r/ppa && apt-get update && apt-get install -qy openjdk-8-jdk && \
    update-alternatives --config java && \
	whereis java && \
	apt-get clean

# install xvbf
RUN apt-get -y install xvfb
RUN apt-get install -y  xfonts-100dpi xfonts-75dpi xfonts-cyrillic  dbus-x11

#Install bower, gulp, jspm, grunt, protractor
RUN npm install -g bower
RUN npm install -g gulp
RUN npm install -g jspm
RUN npm install -g grunt-cli
RUN npm install -g grunt@0.4.4
RUN npm install -g grunt-shell-spawn@0.3.10
RUN npm install -g grunt-protractor-runner@3.2.0
RUN npm install -g grunt-protractor-webdriver

# Run xvbf in background
RUN Xvfb :99 -screen 0 1366x800x24 &
