FROM centos:7
WORKDIR /wlw
COPY . /wlw
RUN mkdir -p /wlw/apacheconf \
    && yum install epel-release dos2unix -y \
    && rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm \
    && yum clean all && yum --enablerepo=epel install httpd httpd-devel -y \
    && yum --enablerepo=remi-php72 install -y php php-mysql php-xml php-soap php-xmlrpc php-mbstring php-json php-gd php-mcrypt php-mongodb phpmyadmin \
    && yum clean all && echo "ServerName  0.0.0.0:80" >> /etc/httpd/conf/httpd.conf && dos2unix start.sh
EXPOSE 80
CMD [ "sh","start.sh" ]