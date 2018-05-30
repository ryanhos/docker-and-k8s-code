FROM node:9.9 AS builder

ARG COMMIT_SHA
ENV REPO_NAME=github-pr-dashboard

RUN mkdir ${REPO_NAME}
WORKDIR ${REPO_NAME}
# Though git clone is nondeterministic, using the commit SHA should invalidate the cache if necessary.
RUN git clone https://github.com/joeattardi/${REPO_NAME}.git . \
	&& git reset --hard ${COMMIT_SHA} \
	&& npm install \
	&& npm run build

################################################################################
# End of builder
################################################################################
FROM node:9.9

EXPOSE 8080

ENV REPO_NAME=github-pr-dashboard

RUN apt-get update \
 	&& apt-get install -y --no-install-recommends jq=1.4-2.1+deb8u1

COPY --from=builder /${REPO_NAME}/LICENSE /
COPY --from=builder /${REPO_NAME}/dist /dist
COPY --from=builder /${REPO_NAME}/img /img
COPY --from=builder /${REPO_NAME}/node_modules /node_modules
COPY --from=builder /${REPO_NAME}/package.json /
COPY --from=builder /${REPO_NAME}/server /server
COPY assets/config.json.template /config/
COPY assets/entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
