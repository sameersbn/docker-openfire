# Table of Contents
- [Introduction](#introduction)
    - [Version](#version)
    - [Changelog](Changelog.md)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
  - [Data Store](#data-store)
- [Upgrading](#upgrading)
- Links
  - [Announcements](https://github.com/sameersbn/docker-openfire/issues/1)
  - [Issues](https://github.com/sameersbn/docker-openfire/issues)
- [References](#references)

# Introduction
Dockerfile to build a [Openfire](www.igniterealtime.org/projects/openfire) XMPP server.

## Version
Current Version: 3.9.3

# Installation

Pull the latest version of the image from the docker index. This is the recommended method of installation as it is easier to update image in the future. These builds are performed by the **Docker Trusted Build** service.

```bash
docker pull sameersbn/openfire:latest
```

You can also pull a particular version of openfire by specifying the version. For example,

```bash
docker pull sameersbn/openfire:3.9.3
```

Alternately you can build the image yourself.

```bash
git clone https://github.com/sameersbn/docker-openfire.git
cd docker-openfire
docker build --tag="$USER/openfire" .
```

# Quick Start
Run the openfire image

```
docker run --name='openfire' -i -t --rm \
-p 127.0.0.1:9090:9090 -p 127.0.0.1:5222:5222 -p 127.0.0.1:7777:7777 \
sameersbn/openfire:3.9.3
```

Point your browser to `http://localhost:9090` and follow the setup procedure to complete the installation.

The following video by HAKK5 will help you with the configuration and give you an introduction to openfire and some of its features.

[![Build A Free Jabber Server In 10 Minutes](http://img.youtube.com/vi/ytUB5qJm5HE/0.jpg)](https://www.youtube.com/v/ytUB5qJm5HE?start=246)

# Configuration

## Data Store
The openfire image is configured to save all configurations and installed plugins at /data. As such we should mount a volume at `/data`

Volumes can be mounted in docker by specifying the **'-v'** option in the docker run command.

```bash
mkdir /opt/openfire
docker run --name=openfire -d \
  -v /opt/openfire:/data \
  sameersbn/openfire:3.9.3
```

# Upgrading

To upgrade to newer releases, simply follow this 3 step upgrade procedure.

- **Step 1**: Stop the currently running image

```
docker stop openfire
```

- **Step 2**: Update the docker image.

```
docker pull sameersbn/openfire:latest
```

- **Step 3**: Start the image

```
docker run -name openfire -d [OPTIONS] sameersbn/openfire:latest
```

# References
  * http://www.igniterealtime.org/projects/openfire/
  * https://library.linode.com/communications/xmpp/openfire/ubuntu-12.04-precise-pangolin
