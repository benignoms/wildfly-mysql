# Wildfly custom Docker image prepared for MySQL connection

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![Docker Build status](https://img.shields.io/docker/build/esignbr/wildfly-mysql.svg)](https://hub.docker.com/r/esignbr/wildfly-mysql/builds) [![Docker Pulls](https://img.shields.io/docker/pulls/esignbr/wildfly-mysql.svg)](https://hub.docker.com/r/esignbr/wildfly-mysql)

This custom Wildfly image is built based on the official [jboss/wildfly:13.0.0.Final](https://github.com/jboss-dockerfiles/wildfly/tree/13.0.0.Final) image.

The image brings the [version 8.0.12](http://central.maven.org/maven2/mysql/mysql-connector-java/8.0.12/mysql-connector-java-8.0.12.jar) of the official JDBC driver for MySQL ([Connector/J](https://dev.mysql.com/downloads/connector/j)).

## Required environment variables

The following environment variables are mandatory in order to run appropriately the image:

- MYSQL_HOST - The name of the MySQL host. If the MySQL port is other than the default 3306, add `:<port_number>`.
- MYSQL_DATABASE - The name of the database used by the application deployed in Wildfly.
- MYSQL_ROOT_PASSWORD - The MySQL root user password.
- MYSQL_USER - The database superuser.
- MYSQL_PASSWORD - The database user password.

If you are using this image together with the [official MySQL image](https://hub.docker.com/_/mysql), set the same values to *MYSQL_DATABASE*, *MYSQL_ROOT_PASSWORD*, *MYSQL_USER* and *MYSQL_PASSWORD* for both images.

## Wildfly datasource

The image is also built with a pre-configured datasource, defined in the file [standalone.xml](standalone.xml). As can be seen in the xml below, the configuration depends on the environment variables.

Notice that both **jndi-name** and **pool-name** depend on the name of the database, defined in *MYSQL_DATABASE*. You must have it into consideration for JNDI bindings within your application code.

```xml
<datasource jndi-name="java:jboss/${env.MYSQL_DATABASE}" pool-name="${env.MYSQL_DATABASE}">
    <connection-url>jdbc:mysql://${env.MYSQL_HOST}/${env.MYSQL_DATABASE}?serverTimezone=UTC</connection-url>
    <driver>mysql</driver>
    <security>
        <user-name>${env.MYSQL_USER}</user-name>
        <password>${env.MYSQL_PASSWORD}</password>
    </security>
    <validation>
        <valid-connection-checker class-name="org.jboss.jca.adapters.jdbc.extensions.mysql.MySQLValidConnectionChecker"/>
        <exception-sorter class-name="org.jboss.jca.adapters.jdbc.extensions.mysql.MySQLExceptionSorter"/>
    </validation>
</datasource>
```

During the setup, the MySQL instance is checked until it is ready for connection.