FROM --platform=linux/arm/v7 rafa606/debian_arm_v7_ros
WORKDIR /catkinws
ENV SSL_CERT_FILE=/usr/lib/ssl/certs/ca-certificates.crt
SHELL ["/bin/bash", "-c"]

RUN sh -c """ \
    echo deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main \
        > /etc/apt/sources.list.d/ros-latest.list \
    """ && \
    apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' \
        --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends -o \
        Dpkg::Options::="--force-confnew" \
        build-essential \
        git python-pip python-setuptools gcc libpq-dev \
        python-dev  python-pip python3-dev python3-pip python3-venv \
        python3-wheel python-rosdep python-rosinstall-generator \
        python-wstool python-rosinstall avahi-daemon \
        avahi-autoipd openssh-server isc-dhcp-client iproute2 && \
    rm -rf /var/lib/apt/lists/* && \
    pip3 install pyserial && \
    echo '[server]' >> /etc/avahi/avahi-daemon.conf && \
    echo 'enable-dbus=no' >> /etc/avahi/avahi-daemon.conf && \
	git clone -b raspberry https://github.com/rafaelrojasmiliani/robotiq_85_gripper.git /catkinws/src/robotiq_85_gripper && \
    source /opt/ros/noetic/setup.bash && catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release -DCATKIN_SKIP_TESTING=ON --install-space /opt/ros/noetic -j4 -DPYTHON_EXECUTABLE=/usr/bin/python3 && rm -rf /catkinws/*
