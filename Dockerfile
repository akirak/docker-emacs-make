FROM ubuntu:trusty

ARG HOME=/root
ENV EMACS_DIR=${HOME}/emacs
ENV EMACSBIN=${HOME}/emacs/src/emacs

# Install dependencies
RUN apt-get update
RUN apt-get install --yes curl make xz-utils gcc libtinfo-dev

# Check if dependencies exists
RUN curl --version
RUN make --version

# Install emacs using build-emacs
RUN mkdir ${HOME}/tmp
WORKDIR ${HOME}/tmp
RUN curl -OL https://raw.githubusercontent.com/flycheck/emacs-travis/54f30c3cf2edc3cd13dca93682b0594f96cf3c80/emacs-travis.mk
# You have to set EMACS_VERSION from the command line
ARG EMACS_VERSION
ENV EMACS_VERSION=${EMACS_VERSION}
RUN echo $EMACS_VERSION
RUN make -f emacs-travis.mk install_emacs
WORKDIR ${HOME}
RUN rm -rfv ${HOME}/tmp

# Prepare a working directory for checking out source code
RUN mkdir ${HOME}/src
WORKDIR ${HOME}/src
RUN pwd

# Show the Emacs version
RUN ${EMACSBIN} --version

ENTRYPOINT ["make"]
