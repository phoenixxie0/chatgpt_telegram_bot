FROM python:3.8-alpine

ENV PYTHONFAULTHANDLER=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONHASHSEED=random
ENV PYTHONDONTWRITEBYTECODE 1
ENV PIP_NO_CACHE_DIR=off
ENV PIP_DISABLE_PIP_VERSION_CHECK=on
ENV PIP_DEFAULT_TIMEOUT=100
ENV HTTP_PROXY='http://172.16.1.101:8123'
ENV HTTPS_PROXY='http://172.16.1.101:8123'
ENV NO_PROXY="172.16.1.101"

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
RUN apk update
RUN set -ex \
        && apk add --no-cache --virtual .build-deps build-base \
		&& apk add py3-virtualenv ffmpeg 
RUN pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

RUN mkdir -p /code
ADD . /code
WORKDIR /code

RUN set -ex \
        && pip3 install -r requirements.txt \
        && apk del .build-deps \
        && rm -rf ~/.cache 

CMD ["bash"]
