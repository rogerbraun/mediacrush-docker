FROM phusion/passenger-customizable:latest

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

RUN apt-get update
RUN /pd_build/python.sh
RUN apt-get install python-pip python-dev -y
RUN /pd_build/redis.sh
RUN add-apt-repository ppa:mc3man/trusty-media -y
RUN apt-get update
RUN apt-get install imagemagick ffmpeg nodejs optipng -y

RUN rm -f /etc/service/nginx/down
RUN rm -f /etc/service/redis/down

ADD MediaCrush /home/app/mediacrush
WORKDIR /home/app/mediacrush
RUN pip install -r requirements.txt

RUN python compile_static.py
ADD passenger_wsgi.py /home/app/mediacrush/passenger_wsgi.py
RUN mkdir storage
RUN chown -R app:app storage

ADD mediacrush-worker /usr/bin/mediacrush-worker
RUN mkdir /etc/service/mediacrush-worker
ADD mediacrush-worker.sh /etc/service/mediacrush-worker/run

ADD mediacrush.conf /etc/nginx/sites-enabled/mediacrush.conf
ADD maxsize.conf /etc/nginx/conf.d/maxsize.conf
RUN rm /etc/nginx/sites-enabled/default

