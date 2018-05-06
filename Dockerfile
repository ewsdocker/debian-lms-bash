# =========================================================================
# =========================================================================
#
#	Dockerfile
#	  Dockerfile for debian-lms-bash in 
#		a Debian 9.3 docker container.
#
# =========================================================================
#
# @author Jay Wheeler.
# @version 0.1.2
# @copyright © 2017, 2018. EarthWalk Software.
# @license Licensed under the Academic Free License version 3.0
# @package debian-lms-bash
# @subpackage Dockerfile
#
# =========================================================================
#
#	Copyright © 2017, 2018. EarthWalk Software
#	Licensed under the Academic Free License, version 3.0.
#
#	Refer to the file named License.txt provided with the source,
#	or from
#
#		http://opensource.org/licenses/academic.php
#
# =========================================================================
# =========================================================================
FROM earthwalksoftware/debian-base:latest

MAINTAINER Jay Wheeler <earthwalksoftware@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# =========================================================================
#
# The following environment values are used during the build phase and must, 
#   therefore be set manually PRIOR to building the image.
#
# =========================================================================
#
# During the development, the package is loaded from a local server.  
#
# In the production stream, the package is loaded from the GitHub server.
#
# =========================================================================
#
# For an explanation of the process used, refer to 
#        pkgcache - a simple "plug in" for Docker build 
#     at
#        http://pkgnginx/LMS-Bash-${PKG_VERS}.tar.gz
#
# =========================================================================

ENV PKG_VERS="0.1.2"

# http://pkgnginx/LMS-Bash-${PKG_VERS}.gz

ENV PKG_HOST=http://pkgnginx
ENV PKG_NAME=LMS-Bash-${PKG_VERS}.tar.gz
ENV PKG_URL=${PKG_HOST}/${PKG_NAME}

COPY scripts/. /

RUN chmod -R +x /usr/local/bin/* \
 && apt-get -y update \
 && apt-get -y upgrade \
 && apt-get -y install \
          wget \
          ca-certificates \
          bash-completion \ 
 && rm -rf /var/lib/apt/lists/* \
 && mkdir -p /var/local/logs/Bash/${PKG_VERS} \
 && mkdir -p /var/local/backups/Bash/${PKG_VERS} \
 && mkdir -p /var/local/archives/Bash/${PKG_VERS} \
 && wget ${PKG_URL} -O /var/local/archives/Bash/LMS-Bash-${PKG_VERS}.tar.gz \
 && tar -xzf /var/local/archives/Bash/LMS-Bash-${PKG_VERS}.tar.gz -C /var/local/archives/Bash/${PKG_VERS} \
 && mkdir -p /usr/local/etc/LMS/Bash/${PKG_VERS} \
 && mkdir -p /usr/local/lib/LMS/Bash/${PKG_VERS} \
 && mkdir -p /usr/local/share/LMS/Bash/${PKG_VERS} \
 && tar -xzf /var/local/archives/Bash/${PKG_VERS}/LMS-Bash-etc-${PKG_VERS}.tar.gz -C /usr/local/etc/LMS/Bash/${PKG_VERS} \
 && tar -xzf /var/local/archives/Bash/${PKG_VERS}/LMS-Bash-lib-${PKG_VERS}.tar.gz -C /usr/local/lib/LMS/Bash/${PKG_VERS} \
 && tar -xzf /var/local/archives/Bash/${PKG_VERS}/LMS-Bash-src-${PKG_VERS}.tar.gz -C /usr/local/share/LMS/Bash/${PKG_VERS} 

VOLUME /bash-root

ENTRYPOINT ["/my_init"]
CMD ["/bin/bash"]
