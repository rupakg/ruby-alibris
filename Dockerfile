#
# ruby-alibris at https://github.com/rupakg/ruby-alibris
#

FROM ubuntu
MAINTAINER Rupak Ganguly <rupakg@gmail.com>

# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update

# install git
RUN apt-get install -y git

# get the code for ruby-alibris lib from github
RUN git clone https://github.com/rupakg/ruby-alibris.git

# echo instructions for usage
RUN echo "Please read the README.markdown file in the 'ruby-alibris' folder, for usage information."
