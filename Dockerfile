# Instructions taken from: http://jasperproject.github.io/documentation/installation/

FROM ubuntu:vivid
MAINTAINER Christopher Blum <christopher@protonet.info>

ENV DEBIAN_FRONTEND noninteractive
ENV JASPER_HOME /opt/jasper
ENV CMUCLMTK_HOME /opt/cmuclmtk

RUN apt-get update
RUN apt-get install vim git-core python-dev python-pip bison libasound2-dev libportaudio-dev python-pyaudio espeak --yes
RUN touch /root/.bash_profile
RUN echo "export LD_LIBRARY_PATH="/usr/local/lib" >> /root/.bash_profile
RUN echo "source .bashrc" >> /root/.bash_profile
RUN echo "export PATH=$PATH:/usr/local/lib/" >> /root/.bash_profile

RUN git clone https://github.com/jasperproject/jasper-client.git $JASPER_HOME

WORKDIR $JASPER_HOME

RUN pip install --upgrade setuptools
RUN pip install -r client/requirements.txt

RUN chmod +x ./jasper.py

RUN apt-get install pocketsphinx subversion autoconf libtool automake gfortran g++ --yes

RUN svn co https://svn.code.sf.net/p/cmusphinx/code/trunk/cmuclmtk/ $CMUCLMTK_HOME
WORKDIR $CMUCLMTK_HOME
RUN sh ./autogen.sh && make && make install

RUN echo 'deb http://ftp.debian.org/debian experimental main contrib non-free' > /etc/apt/sources.list.d/experimental.list
RUN apt-get update
RUN apt-get -t -y --force-yes experimental install phonetisaurus m2m-aligner mitlm

WORKDIR /tmp
RUN wget https://www.dropbox.com/s/kfht75czdwucni1/g014b2b.tgz
RUN tar -xvf g014b2b.tgz
WORKDIR /tmp/g014b2b
RUN ./compile-fst.sh

WORKDIR $JASPER_HOME
RUN mv /tmp/g014b2b /root/phonetisaurus

ADD profile.yml /root/.jasper/profile.yml

CMD $JASPER_HOME/jasper.py