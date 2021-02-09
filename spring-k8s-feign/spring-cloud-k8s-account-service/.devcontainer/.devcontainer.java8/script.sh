#!/bin/bash

cat >> /etc/profile << EOF
export JAVA_HOME=/Developer/java/jdk1.8.0_241
export M2_HOME=/Developer/apache-maven-3.5.4
export GRADLE_USER_HOME=/Developer/.gradle
export PATH=\$JAVA_HOME/bin:\$M2_HOME/bin:\$PATH
EOF

. /etc/profile
# /home/$USERNAME/.bashrc

