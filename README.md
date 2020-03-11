# 설명
NginX 기본 이미지에 Certbot 과 Fcgiwrap 를 추가한 이미지 제작


# 설치
```cmd
  docker run --name NginX-Certbot /
    -e TZ=Asia/Seoul /
    -p 80:80 /
    -p 443:443 /
    -v "/share/Container/apps/NginX/html:/usr/share/nginx/html:ro" /
    -v "/share/Container/apps/NginX/conf.d/default.conf:/etc/nginx/conf.d/default.conf" /
    -v "/share/Container/apps/NginX/letsencrypt/etc:/etc/letsencrypt" /
    -v "/share/Container/apps/NginX/letsencrypt/var:/var/lib/letsencrypt" /
    -d /
    shockutility/nginx-certbot
```

# 설정
```docker
  server {
    listen 80;
    server_name localhost;
    root /usr/share/nginx/html;

    location ~ \.pl$ {
        gzip off;
        fastcgi_param SERVER_NAME \$http_host;
        include /etc/nginx/fastcgi_params;
        fastcgi_pass unix:/var/run/fcgiwrap.socket;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }

    #error_log /var/log/nginx/web/error.log;
    #access_log /var/log/nginx/web/access.log;
  }
```

# 테스트
```perl
  #!/usr/bin/perl -w

  print "Content-type: text/plain\n\n";
  print "Hello World In CGI Perl";

  $output = `ls -l`;
  print $output;
```
