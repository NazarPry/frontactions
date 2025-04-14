FROM node:19-alpine AS lint-test

WORKDIR /app

COPY package.json ./

RUN npm install

COPY . .

ENV CI=true

RUN npx eslint . 

RUN npm test

FROM node:19-alpine AS build

WORKDIR /app

ENV REACT_APP_BASE_URL=""

COPY --from=lint-test /app /app

RUN npm run build

FROM nginx:latest

COPY --from=build /app/build /usr/share/nginx/html

RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]