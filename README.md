# Wildfly custom Docker image prepared for MySQL connection

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![Docker Build status](https://img.shields.io/docker/build/esignbr/wildfly-mysql.svg)](https://hub.docker.com/r/esignbr/wildfly-mysql/builds) [![Docker Pulls](https://img.shields.io/docker/pulls/esignbr/wildfly-mysql.svg)](https://hub.docker.com/r/esignbr/wildfly-mysql)

This custom Wildfly image is built based on the official [jboss/wildfly:13.0.0.Final](https://github.com/jboss-dockerfiles/wildfly/tree/13.0.0.Final) image.

## MySQL connection

The image brings the [version 8.0.12](http://central.maven.org/maven2/mysql/mysql-connector-java/8.0.12/mysql-connector-java-8.0.12.jar) of the official JDBC driver for MySQL ([Connector/J](https://dev.mysql.com/downloads/connector/j)).

During the setup, the MySQL instance is checked until it is ready for connection. This is done during the execution of [wait-for-mysql.sh](wait-for-mysql.sh), the [image entrypoint](https://docs.docker.com/engine/reference/builder/#entrypoint).

A very simple Java class is responsible for testing the connection: [TestConnection.java](TestConnection.java). The class is compiled inside the image, during its building process.

## Required environment variables

The following environment variables are mandatory in order to run appropriately the image:

- MYSQL_HOST - The name of the MySQL host. If the MySQL port is other than the default 3306, add `:<port_number>`.
- MYSQL_DATABASE - The name of the database used by the application deployed in Wildfly.
- MYSQL_ROOT_PASSWORD - The MySQL root user password.
- MYSQL_USER - The database superuser.
- MYSQL_PASSWORD - The database user password.

If you are using this image together with the [official MySQL image](https://hub.docker.com/_/mysql), set the same values to *MYSQL_DATABASE*, *MYSQL_ROOT_PASSWORD*, *MYSQL_USER* and *MYSQL_PASSWORD* for both images.

## Wildfly datasource

The image is also built with a pre-configured datasource, defined in the file [standalone.xml](standalone.xml). As can be seen in the *xml* below, the configuration depends on the environment variables.

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

> Notice that both **jndi-name** and **pool-name** depend on the name of the database, defined in *MYSQL_DATABASE*. You must take it into consideration for JNDI bindings within your application code.

## Extending this image

If your Java application is deployed in Wildfly and uses a MySQL database, create a Dockerfile like the example:

```dockerfile
FROM esignbr/wildfly-mysql

ADD target/application.war /opt/jboss/wildfly/standalone/deployments/
```

> I'm assuming you've used [Maven](https://maven.apache.org) to build your application, thus the *war* file is in the *target* folder. Wildfly expects the packaged application file inside */opt/jboss/wildfly/standalone/deployments/*, for automaticaly deploying it on boot.

You can then build your own application Docker image:

`docker build -t myimages/myapplication .`

### Running your own image

Don't forget to define appropriately the environment variables during the image initialization. If your environment is whole Docker, all of your services run in containers, you can use a docker-compose.yml like the example:

```yaml
version: '3'
services:
  myapp:
    image: myimages/myapplication
    container_name: myapp
    environment:
      - MYSQL_HOST=mysql
      - MYSQL_DATABASE=myapp
      - MYSQL_ROOT_PASSWORD=secret
      - MYSQL_USER=dbuser
      - MYSQL_PASSWORD=dbpass
    depends_on:
      - mysql
  mysql:
    image: mysql:8
    container_name: mysql
    environment:
      - MYSQL_DATABASE=myapp
      - MYSQL_ROOT_PASSWORD=secret
      - MYSQL_USER=dbuser
      - MYSQL_PASSWORD=dbpass
```

You can then run your application and MySQL together:

`docker-compose up -d`
