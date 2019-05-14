FROM node:10.15.2-alpine
ENV TIC_WEBAPP_DIR /tic
VOLUME /tic/work /tic/logs /tic/config
WORKDIR ${TIC_WEBAPP_DIR}
ADD . ${TIC_WEBAPP_DIR}
RUN npm install
EXPOSE 6030
ENTRYPOINT ["node", "index.js", "-c", "development"]
