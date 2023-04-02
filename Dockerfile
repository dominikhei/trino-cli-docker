FROM alpine:3.16

RUN apk update && \
    apk add --no-cache openjdk8-jre-base && \
    apk add --no-cache curl && \
    apk add --no-cache bash && \
    rm -rf /var/cache/apk/*

RUN apk add --no-cache ca-certificates && \
    update-ca-certificates

WORKDIR /app


RUN curl -o trino-cli-411-executable.jar https://repo1.maven.org/maven2/io/trino/trino-cli/411/trino-cli-411-executable.jar && \
    mv trino-cli-411-executable.jar trino && \
    chmod +x trino

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $JAVA_HOME/bin:$PATH
ENV PATH=$PATH:/app/

CMD [ "sh", "-c", "\
    if test -v CONNECTION_USER && test -v CONNECTION_PW; then \
        ./trino --server \"$CONNECTION_URI\" --user \"$CONNECTION_USER\" --password \"$CONNECTION_PW\" && sleep infinity; \
    elif test -v CONNECTION_USER; then \
        ./trino --server \"$CONNECTION_URI\" --user \"$CONNECTION_USER\" && sleep infinity; \
    elif test -v CONNECTION_PW; then \
        ./trino --server \"$CONNECTION_URI\" --password \"$CONNECTION_PW\" && sleep infinity; \
    else \
        ./trino --server \"$CONNECTION_URI\" && sleep infinity; \
    fi" ]

