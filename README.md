# Table of Contents
- [Introduction](#introduction)
    - [Version](#version)
    - [Changelog](Changelog.md)
- [Contributing](#contributing)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Data Store](#data-store)
- [Upgrading](#upgrading)
- Links
  - [Announcements](https://github.com/sameersbn/docker-openfire/issues/1)
  - [Issues](https://github.com/sameersbn/docker-openfire/issues)
- [References](#references)

# Introduction

Dockerfile to build a [Openfire](http://www.igniterealtime.org/projects/openfire) XMPP server.

## Version

Current Version: **3.9.3-2**

# Contributing

If you find this image useful here's how you can help:

- Send a Pull Request with your awesome new features and bug fixes
- Help new users with [Issues](https://github.com/sameersbn/docker-openfire/issues) they may encounter
- Send me a tip on [Gittip](https://gittip.com/sameersbn/) or using Bitcoin at **16rDxVqJPyYAFYPLduTaSiwe7ZiY1hHqKM**

# Installation

Pull the `latest` version of the image from the docker index. This is the recommended method of installation as it is easier to update image in the future. These builds are performed by the **Docker Trusted Build** service.

```bash
docker pull sameersbn/openfire:latest
```

You can also pull a particular version of openfire by specifying the version. For example,

```bash
docker pull sameersbn/openfire:3.9.3-2
```

Alternately you can build the image yourself.

```bash
git clone https://github.com/sameersbn/docker-openfire.git
cd docker-openfire
docker build --tag="$USER/openfire" .
```

# Quick Start

Run the openfire image

```bash
docker run --name='openfire' -i -t --rm \
  -p 9090:9090 -p 5222:5222 -p 7777:7777 \
  sameersbn/openfire:3.9.3-2
```

Point your browser to `http://localhost:9090` and follow the setup procedure to complete the installation.

The following video by HAKK5 will help you with the configuration and give you an introduction to openfire and some of its features.

[![Build A Free Jabber Server In 10 Minutes](http://img.youtube.com/vi/ytUB5qJm5HE/0.jpg)](https://www.youtube.com/v/ytUB5qJm5HE?start=246)

# Data Store

The openfire image is configured to save all configurations and installed plugins at `/data`. As such we should mount a volume at `/data`

Volumes can be mounted in docker by specifying the **'-v'** option in the docker run command.

```bash
mkdir /opt/openfire
docker run --name=openfire -d \
  -p 9090:9090 -p 5222:5222 -p 5223:5223 -p 7777:7777 \
  -p 7070:7070 -p 7443:7443 -p 5229:5229 \
  -v /opt/openfire:/app/data \
```

# Upgrading

To upgrade to newer releases, simply follow this 3 step upgrade procedure.

- **Step 1**: Stop the currently running image

```bash
docker stop openfire
```

- **Step 2**: Update the docker image.

```bash
docker pull sameersbn/openfire:latest
```

- **Step 3**: Start the image

```bash
docker run -name openfire -d [OPTIONS] sameersbn/openfire:latest
```

# References

  * http://www.igniterealtime.org/projects/openfire/
  * https://library.linode.com/communications/xmpp/openfire/ubuntu-12.04-precise-pangolin
