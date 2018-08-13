FROM jboss/wildfly:13.0.0.Final
LABEL mantainer "Gustavo Muniz do Carmo <gustavo@esign.com.br>"

ADD TestConnection.java /
RUN cd /opt/jboss/wildfly/modules/system/layers/base/com && mkdir mysql && cd mysql && mkdir main && cd main && \
    curl -O http://central.maven.org/maven2/mysql/mysql-connector-java/8.0.12/mysql-connector-java-8.0.12.jar && \
    javac -cp mysql-connector-java-8.0.12.jar /TestConnection.java -d .

ADD wait-for-mysql.sh /opt/jboss/wildfly/modules/system/layers/base/com/mysql/main
ADD module.xml /opt/jboss/wildfly/modules/system/layers/base/com/mysql/main
ADD standalone.xml /opt/jboss/wildfly/standalone/configuration/

CMD ["/opt/jboss/wildfly/modules/system/layers/base/com/mysql/main/wait-for-mysql.sh", "/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]
