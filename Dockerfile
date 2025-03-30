FROM debian:buster
LABEL maintainer="dreibona"
WORKDIR /src/git
ENV APPNAME="YACReaderLibraryServer" 
ARG YACR_VERSION="9.8.2"
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      dumb-init \
      qt5-default \
      qt5-qmake \
      qt5-image-formats-plugins \
      qtdeclarative5-dev \
      qtmultimedia5-dev \
      qtscript5-dev \
      libpoppler-qt5-dev \
      libpoppler-qt5-1 \
      libqt5core5a \
      libqt5gui5 \ 
      libqt5opengl5-dev \
      libqt5network5 \
      libqt5quickcontrols2-5 \
      libglu1-mesa-dev \
      libqt5sql5 \
      libqt5sql5-sqlite \
      libunarr-dev \
      libwebp6 \
      p7zip-full \
      git \
      sqlite3 \
      build-essential \
      zlib1g-dev && \
    git -c http.sslVerify=false clone -b master --single-branch https://github.com/YACReader/yacreader.git . && \
    git checkout $YACR_VERSION && \
    cd /src/git/YACReaderLibraryServer && \
    qmake "CONFIG+=server_standalone" YACReaderLibraryServer.pro && \
    make -j4 && \
    make install && \
    cd / && \
    apt-get clean && \
    apt-get purge -y git build-essential qt5-qmake && \
    apt-get -y autoremove && \
    rm -rf /src /var/cache/apt
ADD YACReaderLibrary.ini /root/.local/share/YACReader/YACReaderLibrary/
VOLUME /comics
EXPOSE 8000
ENV LC_ALL=C.UTF8
ENTRYPOINT ["YACReaderLibraryServer","start"]
