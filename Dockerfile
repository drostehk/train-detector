FROM ubuntu:16.04

# Install prerequisites
RUN apt-get clean all && apt-get update && apt-get install -y \
    build-essential \
    libgtk2.0-dev \
    libjpeg-dev \
    libjasper-dev \
    libopenexr-dev \
    cmake \
    python \
    python-pip \
    python-dev \
    python-numpy \
    python-tk \
    libtbb-dev \
    libeigen2-dev \
    yasm \
    libopencore-amrnb-dev \
    libopencore-amrwb-dev \
    libtheora-dev \
    libvorbis-dev \
    libxvidcore-dev \
    libx264-dev \
    libqt4-dev \
    libqt4-opengl-dev \
    sphinx-common \
    texlive-latex-extra \
    libv4l-dev \
    libdc1394-22-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    wget

# Download OpenCV and prep for build
RUN wget https://github.com/opencv/opencv/archive/2.4.13.2.zip && \
    unzip 2.4.13.2.zip && \
    rm 2.4.13.2.zip && \
    mkdir opencv-2.4.13.2/build

# Build and install OpenCV
WORKDIR /opencv-2.4.13.2/build
RUN cmake -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON -D BUILD_EXAMPLES=ON -D WITH_QT=ON -D WITH_OPENGL=ON .. && \
    make -j4 && \
    make install

# Cleanup OpenCV
WORKDIR /
RUN rm -rf ./opencv-2.4.13.2

# Install the required pip packages
RUN pip install --upgrade pip
RUN pip install pillow
