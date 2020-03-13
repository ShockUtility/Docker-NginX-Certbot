FROM nginx:latest

ARG DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

#******************************************************
#* 필수 패키지 설치
#******************************************************
RUN apt-get update
RUN apt-get install -qy apt-utils
RUN apt-get install -qy spawn-fcgi
RUN apt-get install -qy fcgiwrap
RUN apt-get install -qy cron
RUN apt-get install -qy python-certbot-nginx

#******************************************************
#* 디버깅을 위한 패키지 설치
#******************************************************
#RUN apt-get install -qy procps
#RUN apt-get install -qy rsyslog

#******************************************************
#* certbot 사용할 폴더 생성 및 권한설정
#******************************************************
RUN adduser nginx root
RUN mkdir /var/log/letsencrypt
RUN mkdir /var/lib/letsencrypt
RUN chmod 770 /var/log/letsencrypt
RUN chmod 770 /var/lib/letsencrypt
RUN chmod 770 /etc/letsencrypt

#******************************************************
#* certbot 스케줄 등록
#******************************************************
ADD certbot /etc/cron.d/certbot
RUN crontab /etc/cron.d/certbot

#******************************************************
#* fcgiwrap 설정 변경 및 권한 변경 (www-data => nginx)
#******************************************************
RUN sed -i 's/www-data/nginx/g' /etc/init.d/fcgiwrap
RUN chown nginx:nginx /etc/init.d/fcgiwrap

#******************************************************
#* 서비스 쉘 파일 복사 및 실행
#******************************************************
ADD initService.sh /usr/bin/initService.sh
RUN chmod +x /usr/bin/initService.sh
ENTRYPOINT ["/usr/bin/initService.sh"]


