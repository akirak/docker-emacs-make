FROM ubuntu:latest

ARG HOME=/root
ENV EMACS_DIR=${HOME}/emacs
ENV EMACSBIN=${HOME}/emacs/src/emacs

# Install dependencies
RUN apt-get update
RUN apt-get install --yes gnutls-bin curl make
# These dependencies are needed to run build-emacs script
RUN apt-get install --yes xz-utils gcc libtinfo-dev

# Check if dependencies exists
RUN curl --version
RUN make --version

# Install emacs using build-emacs
RUN mkdir ${HOME}/tmp
WORKDIR ${HOME}/tmp
RUN curl -OL https://raw.githubusercontent.com/vermiculus/emake.el/master/build-emacs
# You have to set CI variable to a non-empty string to run build-emacs
ENV CI=dockerhub
# You have to set EMACS_VERSION from the command line
ARG EMACS_VERSION
ENV EMACS_VERSION=${EMACS_VERSION}
RUN echo $EMACS_VERSION
RUN bash -ex build-emacs
RUN rm -rfv ${HOME}/tmp

# Prepare a working directory for checking out source code
RUN mkdir ${HOME}/src
WORKDIR ${HOME}/src
RUN pwd

# Show the Emacs version
RUN ${EMACSBIN} --version

ENTRYPOINT ["make"]
