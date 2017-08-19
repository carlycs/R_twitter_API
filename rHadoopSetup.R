apt-get install libboost-dev libevent-dev libtool flex bison g++ automake pkg-config
apt-get install libboost-test-dev
apt-get install libmono-dev ruby1.8-dev libcommons-lang-java php5-dev
cd /tmp
curl http://apache.multidist.com/thrift/0.8.0/thrift-0.8.0.tar.gz | tar zx 
cd thrift-0.8.0
./configure
make
make install
rm -rf thrift-0.8.0


#R installation, environment and package dependencies
# R installation
apt-get r-base

# External package repository, go to the R site to find your nearest location
echo 'options(repos=structure(c(CRAN="http://cran.fr.r-project.org")))' &gt;&gt; /etc/R/Rprofile.site

# Global Java variable
cat &gt; /etc/profile.d/java.sh &lt;&lt;DELIM
export JAVA_HOME=/usr/lib/jvm/java-6-sun/jre
DELIM
. /etc/profile.d/java.sh

# Global Hadoop variables
cat &gt; /etc/profile.d/r.sh &lt;&lt;DELIM
export HADOOP_HOME=/usr/lib/hadoop
export HADOOP_CONF=/etc/hadoop/conf
export HADOOP_CMD=/usr/bin/hadoop
export HADOOP_STREAMING=/usr/lib/hadoop/contrib/streaming/hadoop-streaming-0.20.2-chd3u4.jar
DELIM
. /etc/profile.d/r.sh

# R package dependencies
apt-get install r-cran-rjava
apt-get install r-cran-rcpp
Rscript -e 'install.packages("RJSONIO");'
Rscript -e 'install.packages("itertools");'
Rscript -e 'install.packages("digest");'


