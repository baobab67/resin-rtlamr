# Base Docker Image from Docker Hub: https://registry.hub.docker.com/u/cretzel/rpi-golang/
FROM cretzel/rpi-golang

RUN apt-get update

RUN apt-get install --no-install-recommends -y \
	git-core \
	bzr \
	mercurial \
	curl \
	ca-certificates \
	build-essential \
	libfftw3-dev \
	cmake \
	pkg-config \
	libusb-1.0-0-dev

COPY . /app	
	
WORKDIR /usr/local/
RUN git clone git://git.osmocom.org/rtl-sdr.git
RUN mkdir /usr/local/rtl-sdr/build	
	
WORKDIR /usr/local/rtl-sdr/build
RUN cmake ../ -DINSTALL_UDEV_RULES=ON -DDETACH_KERNEL_DRIVER=ON
RUN make
RUN make install
RUN ldconfig
	
# Download and install Go
# RUN curl -s https://storage.googleapis.com/golang/go1.3.linux-amd64.tar.gz | tar -v -C /usr/local -xz

ENV GOROOT /usr/local/go
ENV PATH $PATH:$GOROOT/bin

ENV GOPATH /go
ENV PATH $PATH:$GOPATH/bin

# Build, test and install RTLAMR
WORKDIR /go/src/
RUN go get -v github.com/bemasher/rtlamr
RUN go test -v ./...

#CMD ["rtlamr"]

CMD ["bash", "/app/start.sh"]



# Run rtlamr container with non-dockerized rtl_tcp instance:
# docker run -d --name rtlamr --link rtltcp:rtltcp bemasher/rtlamr

# For use with bemasher/rtl-sdr:
# Start rtl_tcp from rtl-sdr container:
# docker run -d --privileged -v /dev/bus/usb:/dev/bus/usb --name rtltcp bemasher/rtl-sdr rtl_tcp -a 0.0.0.0

# Run rtlamr container, link with rtl_tcp container:
# docker run -d --name rtlamr --link rtltcp:rtltcp bemasher/rtlamr -server=rtltcp:1234