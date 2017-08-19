#Thrift dependency
#Note, if my memory is accurate, maven (apt-get install maven2) might also be required.

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

#rmr
cd /tmp
curl -L https://github.com/downloads/RevolutionAnalytics/RHadoop/rmr_1.3.1.tar.gz -o rmr_1.3.1.tar.gz
R CMD INSTALL rmr rmr_1.3.1.tar.gz
rm -rf rmr_1.3.1.tar.gz

#rhdfs
cd /tmp
curl -L http://github.com/downloads/RevolutionAnalytics/RHadoop/rhdfs_1.0.4.tar.gz -o rhdfs_1.0.4.tar.gz
R CMD INSTALL rhdfs rhdfs_1.0.4.tar.gz
rm -rf rhdfs_1.0.4.tar.gz

#rhbase
cd /tmp
# Check Thrift
# pkg-config --cflags thrift | grep -I/usr/local/include/thrift
cp /usr/local/lib/libthrift-0.8.0.so /usr/lib/
  # Compile rhbase
  curl -L https://github.com/downloads/RevolutionAnalytics/RHadoop/rhbase_1.0.4.tar.gz -o rhbase_1.0.4.tar.gz
R CMD INSTALL rhbase rhbase_1.0.4.tar.gz
rm -rf rhbase_1.0.4.tar.gz
#test installation example from hadoop-and-r-is-rhadoop/ http://www.adaltas.com
groups = rbinom(100, n = 500, prob = 0.5)
tapply(groups, groups, length)

require('rmr')
groups = rbinom(100, n = 500, prob = 0.5)
groups = to.dfs(groups)
result = mapreduce(
  input = groups, 
  map = function(k,v) keyval(v, 1), 
  reduce = function(k,vv) keyval(k, length(vv)))


# Print the HDFS file path
print(result())
# Show the file content
print(from.dfs(result, to.data.frame=T))


