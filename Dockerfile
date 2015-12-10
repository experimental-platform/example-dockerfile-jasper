# Instructions taken from: http://jasperproject.github.io/documentation/installation/
# How to configure: http://jasperproject.github.io/documentation/configuration/
FROM ubuntu:vivid
MAINTAINER Christopher Blum <christopher@protonet.info>

ENV DEBIAN_FRONTEND noninteractive
ENV JASPER_HOME /root/jasper
ENV CMUCLMTK_HOME /opt/cmuclmtk

RUN echo 'deb http://ftp.debian.org/debian experimental main contrib non-free' > /etc/apt/sources.list.d/experimental.list
RUN apt-get update
RUN apt-get install vim git-core python-dev bison libasound2-dev libportaudio-dev python-pyaudio espeak pocketsphinx-utils pocketsphinx-hmm-en-hub4wsj pocketsphinx-lm-en-hub4 subversion autoconf libtool automake wget build-essential gfortran python-pocketsphinx alsa-base alsa-utils --yes
RUN apt-get --force-yes -y -t experimental install phonetisaurus m2m-aligner mitlm

RUN wget https://bootstrap.pypa.io/get-pip.py && /usr/bin/python get-pip.py

RUN touch /root/.bash_profile
RUN echo 'export LD_LIBRARY_PATH="/usr/local/lib"' >> /root/.bash_profile
RUN echo "source .bashrc" >> /root/.bash_profile
RUN echo "export PATH=\$PATH:/usr/local/lib/" >> /root/.bash_profile

RUN git clone https://github.com/jasperproject/jasper-client.git $JASPER_HOME
WORKDIR $JASPER_HOME

RUN sed -i 's/argparse/#argparse/g' $JASPER_HOME/client/requirements.txt
RUN pip install --upgrade setuptools
RUN pip install -r client/requirements.txt

RUN chmod +x ./jasper.py

RUN svn co https://svn.code.sf.net/p/cmusphinx/code/trunk/cmuclmtk/ $CMUCLMTK_HOME
WORKDIR $CMUCLMTK_HOME
RUN sh ./autogen.sh && make && make install

WORKDIR /tmp
RUN wget http://www.openfst.org/twiki/pub/FST/FstDownload/openfst-1.3.3.tar.gz
RUN tar -xvf openfst-1.3.3.tar.gz
WORKDIR /tmp/openfst-1.3.3/
RUN ./configure --enable-compact-fsts --enable-const-fsts --enable-far --enable-lookahead-fsts --enable-pdt
RUN make install

WORKDIR /tmp
RUN wget https://www.dropbox.com/s/kfht75czdwucni1/g014b2b.tgz
RUN tar -xvf g014b2b.tgz
WORKDIR /tmp/g014b2b
RUN ./compile-fst.sh
RUN mv /tmp/g014b2b /root/phonetisaurus

ADD profile.yml /root/.jasper/profile.yml
ADD asound.conf /etc/asound.conf

CMD start.sh