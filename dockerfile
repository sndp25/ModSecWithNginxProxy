FROM nginx
RUN apt-get update
RUN apt-get install git gcc g++ make automake curl wget autoconf libtool libpcre3-dev libxml2 -y
RUN git clone https://github.com/carlosdg/owasp-modsecurity-crs.git conf/modsec/owasp_crs
RUN git clone https://github.com/SpiderLabs/ModSecurity && \
	cd ModSecurity && \
	git submodule init && \
	git submodule update && \
	./build.sh && \
	./configure && \
	make && \
	make install
RUN original_config=$(nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p') \
	git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx.git && \
	wget "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -O nginx.tar.gz && \
	tar -xvzf nginx.tar.gz && \
	cd "nginx-${NGINX_VERSION}" && \
	./configure --with-compat $original_config --add-dynamic-module=../ModSecurity-nginx --without-http_gzip_module && \
	make modules && \
	cp objs/ngx_http_modsecurity_module.so /etc/nginx/modules
RUN rm -rf /etc/nginx/nginx.conf /etc/nginx/conf.d
COPY conf /etc/nginx/

WORDDIR /etc/nginx/
EXPOSE 80
CMD ["nginx","-g","daemon off;"]
