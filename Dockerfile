FROM ubuntu:14.04
RUN apt-get update
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get install -y nginx-full wget

RUN mkdir /usr/share/nginx/kibana3

RUN wget https://download.elasticsearch.org/kibana/kibana/kibana-3.1.0.tar.gz -O /tmp/kibana.tar.gz && \
    tar zxf /tmp/kibana.tar.gz && mv kibana-3.1.0/* /usr/share/nginx/kibana3
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

ADD nginx.conf /etc/nginx/conf.d/default.conf
ADD site.conf /etc/nginx/site-enabled/default

RUN wget -O confd https://github.com/kelseyhightower/confd/releases/download/v0.6.0-alpha3/confd-0.6.0-alpha3-linux-amd64
RUN chmod +x confd
RUN mv confd /usr/local/bin/confd

ADD run.sh /home/
RUN chmod +x /home/run.sh

ADD kibana.toml /etc/confd/conf.d/
ADD config.js.tmpl /etc/confd/templates/

RUN cd /home

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


EXPOSE 80

CMD ["/home/run.sh"]
