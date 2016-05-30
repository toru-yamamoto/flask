FROM python:2.7.11

MAINTAINER tktk8924 <myphone.tk@gmail.com>

ENV FLASK_APP flaskr.py

EXPOSE 80

CMD ["flask", "run", "-h", "0.0.0.0", "-p", "80"]

RUN pip install flask pytest

WORKDIR /app
COPY ./ .

RUN flask initdb
