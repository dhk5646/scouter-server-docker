# Scouter Server 2.20.0 Dockerfile

FROM openjdk:8-alpine

LABEL maintainer="dhk5646@gmail.com"

ARG SCOUTER_VERSION=2.20.0
ARG INSTALL_URL=https://github.com/scouter-project/scouter/releases/download/v${SCOUTER_VERSION}/scouter-all-${SCOUTER_VERSION}.tar.gz

# 작업 디렉토리 설정
WORKDIR /home

# 타임존 설정, wget과 unzip 설치
RUN apk add --no-cache tzdata wget unzip && \
    cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime

# Scouter 릴리즈 다운로드 및 압축 해제
RUN wget ${INSTALL_URL} && \
    tar xvf scouter-all-${SCOUTER_VERSION}.tar.gz && \
    mv scouter/server ./scouter-server && \
    cp scouter/webapp/scouter-webapp-${SCOUTER_VERSION}.jar ./scouter-server/lib/ && \
    cp scouter/webapp/lib/*.jar ./scouter-server/lib/ && \
    rm -rf scouter scouter-all-${SCOUTER_VERSION}.tar.gz

# 권한 설정
RUN chmod -R 755 ./scouter-server

# 설정 파일 복사 (로컬에 준비된 scouter.conf와 startup.sh가 있다고 가정)
COPY scouter-server/conf/scouter.conf ./scouter-server/conf/scouter.conf
COPY scouter-server/startup.sh ./scouter-server/startup.sh

RUN chmod +x ./scouter-server/startup.sh

# 포트 오픈
EXPOSE 6180/tcp
EXPOSE 6188/tcp
EXPOSE 6100/tcp
EXPOSE 6100/udp

# 작업 디렉토리 변경
WORKDIR /home/scouter-server

# 컨테이너 시작 시 실행할 스크립트
ENTRYPOINT ["./startup.sh"]
