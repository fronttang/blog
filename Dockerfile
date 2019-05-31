ARG node=node:lts
ARG nginx=nginx:1.15
FROM $node as download
COPY . /app
WORKDIR /app

RUN npm install hexo-cli -g
RUN npm install
RUN hexo generate

FROM $nginx

COPY --from=download /app/public/  /usr/share/nginx/html/
ADD default.conf /etc/nginx/conf.d/
WORKDIR /usr/share/nginx/html
