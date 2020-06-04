#!/bin/bash
<<<<<<< HEAD
set -e

ROOT=`pwd`
ES_VERSION=$(../bin/version-info --es)
OD_VERSION=$(../bin/version-info --od)
ARTIFACTS_URL="https://d3g5vo6xdbdb9a.cloudfront.net"
PACKAGE_NAME="opendistroforelasticsearch"
TARGET_DIR="$ROOT/target"

# Please DO NOT change the orders, they have dependencies
PLUGINS="opendistro-sql/opendistro_sql-$OD_VERSION \
         opendistro-alerting/opendistro_alerting-$OD_VERSION \
         opendistro-job-scheduler/opendistro-job-scheduler-$OD_VERSION \
         opendistro-security/opendistro_security-$OD_VERSION \
         performance-analyzer/opendistro_performance_analyzer-$OD_VERSION \
         opendistro-index-management/opendistro_index_management-$OD_VERSION \
         opendistro-knn/opendistro-knn-$OD_VERSION \
         opendistro-anomaly-detection/opendistro-anomaly-detection-$OD_VERSION"

basedir="${ROOT}/elasticsearch-${ES_VERSION}/plugins"
PLUGINS_CHECKS="${basedir}/opendistro-job-scheduler \
                ${basedir}/opendistro_alerting \
                ${basedir}/opendistro_performance_analyzer \
                ${basedir}/opendistro_security \
                ${basedir}/opendistro_sql \
                ${basedir}/opendistro_index_management \
                ${basedir}/opendistro-knn \
                ${basedir}/opendistro-anomaly-detection"

echo $ROOT
mkdir -p $TARGET_DIR
mkdir -p $PACKAGE_NAME-$OD_VERSION

# Download windowss oss for copying batch files
wget -nv https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-$ES_VERSION-windows-x86_64.zip ; echo $?

# Unzip the oss
unzip -q elasticsearch-oss-$ES_VERSION-windows-x86_64.zip
rm -rf elasticsearch-oss-$ES_VERSION-windows-x86_64.zip

# Install plugins
for plugin_path in $PLUGINS
=======
mkdir ws #A temporary workspace inside opendistro-build/elasticsearch/linux_distributionss
cd ../bin
ES_VERSION=$(./version-info --es)
OD_VERSION=$(./version-info --od)
OD_PLUGINVERSION=$OD_VERSION.0
PACKAGE=opendistroforelasticsearch
cd ../linux_distributions
cd ws
echo "$ES_VERSION"
echo "$OD_VERSION"
ROOT=`pwd`
echo "$ROOT"
TARGET_DIR="$ROOT/Windowsfiles"
mkdir -p $PACKAGE-$OD_VERSION

#Download windowss oss for copying batch files
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-$ES_VERSION-windows-x86_64.zip -P $ROOT/
if [ "$?" -eq "1" ]
then
  echo "OSS not available"
  exit 1
fi

#Unzip the oss
unzip $ROOT/elasticsearch-oss-$ES_VERSION-windows-x86_64.zip -d $ROOT
rm -rf $ROOT/elasticsearch-oss-$ES_VERSION-windows-x86_64.zip

#Install plugins
for plugin_path in opendistro-sql/opendistro_sql-$OD_PLUGINVERSION.zip opendistro-alerting/opendistro_alerting-$OD_PLUGINVERSION.zip opendistro-job-scheduler/opendistro-job-scheduler-$OD_PLUGINVERSION.zip opendistro-security/opendistro_security-$OD_PLUGINVERSION.zip opendistro-index-management/opendistro_index_management-$OD_PLUGINVERSION.zip opendistro-anomaly-detection/opendistro-anomaly-detection-$OD_PLUGINVERSION.zip
>>>>>>> master
do
  plugin_latest=`aws s3api list-objects --bucket artifacts.opendistroforelasticsearch.amazon.com --prefix "downloads/elasticsearch-plugins/${plugin_path}" --query 'Contents[].[Key]' --output text | sort | tail -n 1`
  echo "installing $plugin_latest"
  $ROOT/elasticsearch-$ES_VERSION/bin/elasticsearch-plugin install --batch "${ARTIFACTS_URL}/${plugin_latest}"; \
done

<<<<<<< HEAD
# Validation
echo "validating that plugins has been installed"
ls -lrt $basedir
=======
bash $ROOT/elasticsearch-$ES_VERSION/plugins/opendistro_security/tools/install_demo_configuration.sh -y -i -s
cat $ROOT/elasticsearch-$ES_VERSION/config/elasticsearch.yml
cp -r elasticsearch-$ES_VERSION/* $PACKAGE-$OD_VERSION/
#Making zip
zip -r odfe-$OD_VERSION.zip $PACKAGE-$OD_VERSION
>>>>>>> master

for d in $PLUGINS_CHECKS; do
  echo "$d"
  if [ -d "$d" ]; then
    echo "directoy "$d" is present"
  else
    echo "ERROR: "$d" is not present"
    exit 1;
  fi
done

echo "Results: validated that plugins has been installed"

bash $ROOT/elasticsearch-$ES_VERSION/plugins/opendistro_security/tools/install_demo_configuration.sh -y -i -s
cat $ROOT/elasticsearch-$ES_VERSION/config/elasticsearch.yml
cp -r elasticsearch-$ES_VERSION/* $PACKAGE_NAME-$OD_VERSION/

# Making zip
echo "Generating zip"
zip -q -r $TARGET_DIR/odfe-$OD_VERSION.zip $PACKAGE_NAME-$OD_VERSION

# Build Exe
wget -nv https://download-gcdn.ej-technologies.com/install4j/install4j_unix_8_0_4.tar.gz
tar -xzf install4j_unix_8_0_4.tar.gz
aws s3 cp s3://odfe-windows/ODFE.install4j .
<<<<<<< HEAD
echo $?

# Build the exe
install4j8.0.4/bin/install4jc -d $TARGET_DIR -D sourcedir=./$PACKAGE_NAME-$OD_VERSION,version=$OD_VERSION --license="L-M8-AMAZON_DEVELOPMENT_CENTER_INDIA_PVT_LTD#50047687020001-3rhvir3mkx479#484b6" ./ODFE.install4j

# Upload top S3
# Temporarily move these upload commands to workflow files
#aws s3 cp $TARGET_DIR/*.exe s3://artifacts.opendistroforelasticsearch.amazon.com/downloads/odfe-windows/staging/odfe-executable/
#aws s3 cp $TARGET_DIRodfe-$OD_VERSION.zip s3://artifacts.opendistroforelasticsearch.amazon.com/downloads/odfe-windows/staging/odfe-window-zip/
#aws cloudfront create-invalidation --distribution-id E1VG5HMIWI4SA2 --paths "/downloads/*"
=======
if [ "$?" -eq "1" ]
then
  echo "Install4j not available"
  exit 1
fi
#pwd

#Build the exe
install4j8.0.4/bin/install4jc -d EXE -D sourcedir=./$PACKAGE-$OD_VERSION,version=$OD_VERSION --license="L-M8-AMAZON_DEVELOPMENT_CENTER_INDIA_PVT_LTD#50047687020001-3rhvir3mkx479#484b6" ./ODFE.install4j

#upload top S3
aws s3 cp EXE/*.exe s3://artifacts.opendistroforelasticsearch.amazon.com/downloads/odfe-windows/staging/odfe-executable/
aws s3 cp odfe-$OD_VERSION.zip s3://artifacts.opendistroforelasticsearch.amazon.com/downloads/odfe-windows/staging/odfe-window-zip/
aws cloudfront create-invalidation --distribution-id E1VG5HMIWI4SA2 --paths "/downloads/*"
>>>>>>> master
