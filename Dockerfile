# This first container builds the site.
FROM dettmering/hugo-build:0.53 as build

COPY ./ /site

WORKDIR /site

RUN /usr/bin/hugo

# The second serves the site.
FROM nginx:stable-alpine

COPY --from=build /site/public /usr/share/nginx/html

WORKDIR /usr/share/nginx/html

EXPOSE 80
