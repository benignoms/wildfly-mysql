# Wildfly custom Docker image prepared for MySQL connection

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![Docker Build status](https://img.shields.io/docker/build/esignbr/wildfly-mysql.svg)](https://hub.docker.com/r/esignbr/wildfly-mysql/builds) [![Docker Pulls](https://img.shields.io/docker/pulls/esignbr/wildfly-mysql.svg)](https://hub.docker.com/r/esignbr/wildfly-mysql)

This custom Wildfly image is built with the MySQL driver embedded and with a default datasource, defined in the [configuration file](standalone.xml). During the setup, the MySQL instance is checked until it is ready for connection.
