ARG BASE_DOCKER_IMAGE

FROM $BASE_DOCKER_IMAGE

RUN psp-pacman -Sy && \
    yes | psp-pacman -S pspdev-default && \
    yes | psp-pacman -Scc && \
    cd /usr/local/pspdev && tree

# Second stage of Dockerfile
FROM alpine:latest

ENV PSPDEV /usr/local/pspdev
ENV PATH $PATH:${PSPDEV}/bin

COPY --from=0 ${PSPDEV} ${PSPDEV}
