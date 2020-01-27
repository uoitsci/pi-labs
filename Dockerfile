FROM monachus/hugo:v0.63.1 as build

FROM nginx

COPY --from=build /usr/share/nginx/html /usr/share/nginx/html

WORKDIR /usr/share/nginx/html

EXPOSE 80
