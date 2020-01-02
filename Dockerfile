FROM node:12.13.1

RUN mkdir /srv/ntnv-api && chown node:node /srv/ntnv-api

USER node

WORKDIR /srv/ntnv-api

COPY --chown=node:node package.json package-lock.json ./

RUN npm install --quiet

# TODO: Can remove once we have some dependencies in package.json.
# RUN mkdir -p node_modules