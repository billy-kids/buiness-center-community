FROM node:20 AS builder
RUN apk add --no-cache git
WORKDIR /app
COPY frontend/package.json frontend/package-lock.json ./
RUN yarn install --pure-lockfile
COPY frontend .
RUN yarn build

FROM nginx:alpine
COPY frontend/nginx.conf /etc/nginx/conf.d/configfile.template
COPY --from=builder /app/build /usr/share/nginx/html
ENV PORT 8080
ENV HOST 0.0.0.0
EXPOSE 8080
CMD sh -c "envsubst '\$PORT' < /etc/nginx/conf.d/configfile.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"

