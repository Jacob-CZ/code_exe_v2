FROM node
COPY commands.sh /scripts/commands.sh
RUN npm install -g typescript
WORKDIR /app
ENTRYPOINT ["/scripts/commands.sh"]