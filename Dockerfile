ARG PGVECTORS_TAG=pg14-v0.3.0-amd64
ARG BITNAMI_TAG=17.4.0-debian-12-r15
FROM scratch as nothing
FROM tensorchord/pgvecto-rs-binary:${PGVECTORS_TAG} as binary

FROM docker.io/bitnami/postgresql:${BITNAMI_TAG}
COPY --from=binary /pgvecto-rs-binary-release.deb /tmp/vectors.deb
USER root
RUN apt-get install -y /tmp/vectors.deb && rm -f /tmp/vectors.deb && \
     mv /usr/lib/postgresql/*/lib/vectors.so /opt/bitnami/postgresql/lib/ && \
     mv usr/share/postgresql/*/extension/vectors* opt/bitnami/postgresql/share/extension/
USER 1001
ENV POSTGRESQL_EXTRA_FLAGS="-c shared_preload_libraries=vectors.so"
