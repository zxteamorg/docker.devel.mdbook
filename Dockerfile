ARG BUILD_IMAGE=alpine:3.16.0


FROM ${BUILD_IMAGE} AS builder
ARG GIT_VERSION=2.36.1-r0
ARG RUST_VERSION=1.60.0-r2
ARG MDBOOK_VERSION=0.4.18
ARG MDBOOK_ADMONISH_VERSION=1.7.0
ARG MDBOOK_MERMAID_VERSION=0.11.0
ARG MDBOOK_THEME_VERSION=0.1.2
RUN apk add --no-cache \
  rust=${RUST_VERSION} \
  cargo=${RUST_VERSION} \
  git=${GIT_VERSION}
# Use git executable to fetch registry indexes, due to a memory overflow issue
# See https://users.rust-lang.org/t/cargo-uses-too-much-memory-being-run-in-qemu/76531
RUN export CARGO_NET_GIT_FETCH_WITH_CLI=true && cargo install --version "${MDBOOK_VERSION}" mdbook
RUN export CARGO_NET_GIT_FETCH_WITH_CLI=true && cargo install --version "${MDBOOK_ADMONISH_VERSION}" mdbook-admonish
RUN export CARGO_NET_GIT_FETCH_WITH_CLI=true && cargo install --version "${MDBOOK_MERMAID_VERSION}" mdbook-mermaid
RUN export CARGO_NET_GIT_FETCH_WITH_CLI=true && cargo install --version "${MDBOOK_THEME_VERSION}" mdbook-theme
RUN mkdir -p /stage/usr/bin/
RUN mv /root/.cargo/bin/mdbook         /stage/usr/bin/
RUN mv /root/.cargo/bin/mdbook-mermaid /stage/usr/bin/
COPY docker-entrypoint.sh /stage/usr/local/bin/zxteamorg-develmdbook-docker-entrypoint.sh


FROM ${BUILD_IMAGE}
RUN apk add --no-cache libgcc
COPY --from=builder /stage/ /
VOLUME /data
EXPOSE 8000
ENTRYPOINT [ "/usr/local/bin/zxteamorg-develmdbook-docker-entrypoint.sh" ]
