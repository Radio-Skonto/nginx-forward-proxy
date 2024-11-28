ARG NGINX_VERSION=1.22.1
ARG ALPINE_VERSION=3.20.3
ARG ALPINE_VERSION=latest

FROM alpine:$ALPINE_VERSION AS builder-headers-more

ARG NGINX_VERSION=1.22.1
ARG HEADERS_MORE_VERSION=v0.37

RUN apk update \
    && apk add \
    bash \
    g++ \
    gcc \
    git \
    libc-dev \
    make \
    openssl \
    pcre-dev \
    tar \
    wget \
    zlib-dev

RUN cd /opt \
    && cd /opt \
    && git clone --depth 1 -b $HEADERS_MORE_VERSION --single-branch https://github.com/openresty/headers-more-nginx-module.git \
    && cd /opt \
    && wget -O - http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz | tar zxfv - \
    && cd nginx-$NGINX_VERSION \
    && ./configure --with-compat --add-dynamic-module=/opt/headers-more-nginx-module \
    && make modules
#    && ./configure \
#          --prefix=/opt/nginx-$NGINX_VERSION \
#          --add-module=/opt/headers-more-nginx-module \
#    && make \
#    && make install
WORKDIR /
CMD ["/bin/sh"]
EXPOSE 1245

#FROM alpine:$ALPINE_VERSION AS builder-http-proxy
#
#ARG NGINX_VERSION=1.21.4
#ARG PROXY_CONNECT_VERSION=v0.0.5
#
#RUN apk update \
#    && apk add \
#    bash \
#    g++ \
#    gcc \
#    git \
#    libc-dev \
#    make \
#    openssl \
#    pcre-dev \
#    tar \
#    wget \
#    zlib-dev
#
#RUN cd /opt \
#    && cd /opt \
#    && git clone --depth 1 -b $PROXY_CONNECT_VERSION --single-branch https://github.com/chobits/ngx_http_proxy_connect_module.git \
#    && cd /opt \
#    && wget -O - http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz | tar zxfv - \
#    && cd nginx-$NGINX_VERSION \
#    && ./configure --with-compat --add-module=/opt/ngx_http_proxy_connect_module \
#    && make modules
##    && ./configure \
##          --prefix=/opt/nginx-$NGINX_VERSION \
##          --add-module=/opt/headers-more-nginx-module \
##    && make \
##    && make install
#
#FROM nginx:$NGINX_VERSION-alpine
#
#COPY --from=builder-headers-more /opt/nginx/objs/ngx_http_headers_more_filter_module.so /usr/lib/nginx/modules
#COPY --from=builder-http-proxy /opt/nginx/objs/ngx_http_proxy_connect_module.so /usr/lib/nginx/modules
#
#RUN apk add bash
#RUN chmod -R 644 \
#        /usr/lib/nginx/modules/ngx_http_headers_more_filter_module.so \
#    && sed -i '1iload_module \/usr\/lib\/nginx\/modules\/ngx_http_headers_more_filter_module.so;' /etc/nginx/nginx.conf
#
#EXPOSE 9898
