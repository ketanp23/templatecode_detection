FROM ubuntu:18.04

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

#RUN apt-get update -y && apt-get install -y python3-pip 


# install python and git
RUN apt-get update \
    && apt-get install -y python3.6 python3-pip \
	&& apt-get install -y git


# get latest cvlib from github	
WORKDIR /

RUN git clone https://github.com/arunponnusamy/cvlib

# install cvlib and dependencies
#WORKDIR /cvlib
#RUN pip3 install .
#RUN apt install -y libsm6 libxext6 libxrender-dev


# We copy just the requirements.txt first to leverage Docker cache
ADD requirements.txt /app/

WORKDIR /app
RUN pip3 install opencv-python tensorflow
RUN pip3 install cvlib

RUN /bin/bash -c "pip3 install --no-cache-dir -r requirements.txt"

ADD /app/ /app/

EXPOSE 5000

CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]