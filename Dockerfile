ARG PGVECTORS_TAG=pg14-v0.3.0
ARG BITNAMI_TAG=14.17.0-debian-12-r14
FROM scratch AS nothing
FROM tensorchord/pgvecto-rs-binary:${PGVECTORS_TAG}-${TARGETARCH} AS binary

FROM docker.io/bitnami/postgresql:${BITNAMI_TAG}
COPY --from=binary /pgvecto-rs-binary-release.deb /tmp/vectors.deb
USER root
RUN apt-get install -y /tmp/vectors.deb && rm -f /tmp/vectors.deb && \
     mv /usr/lib/postgresql/*/lib/vectors.so /opt/bitnami/postgresql/lib/ && \
     mv usr/share/postgresql/*/extension/vectors* opt/bitnami/postgresql/share/extension/
USER 1001
ENV POSTGRESQL_EXTRA_FLAGS="-c shared_preload_libraries=vectors.so"
