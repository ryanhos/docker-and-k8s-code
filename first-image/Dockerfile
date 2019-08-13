FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y python3.6
COPY greet.py /

ENTRYPOINT ["/usr/bin/python3.6", "greet.py"]
CMD ["world"]
