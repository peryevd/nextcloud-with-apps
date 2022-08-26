#!/bin/bash
set -x

docker-compose up -d

while ( ! curl -sSf http://localhost:88/ > /dev/null  )
do 
   sleep 1
   echo "wait docker start"
done

docker exec -u www-data app-server /bin/bash -c 'php occ  maintenance:install --admin-user "admin" --admin-pass "admin"'
docker exec -u www-data app-server php occ --no-warnings config:system:get trusted_domains >> trusted_domain.tmp

if ! grep -q "nginx-server" trusted_domain.tmp; then
    TRUSTED_INDEX=$(cat trusted_domain.tmp | wc -l);
    docker exec -u www-data app-server php occ --no-warnings config:system:set trusted_domains $TRUSTED_INDEX --value="nextcloud_nginx.1.41d2jknvpgnhdmr3kkdlp8cbt"
fi

rm trusted_domain.tmp

# docker exec -u root app-server /bin/bash -c "apt-get update && apt-get install smbclient"
# docker restart app-server

docker exec -u www-data app-server php occ --no-warnings app:install onlyoffice
docker exec -u www-data app-server php occ --no-warnings app:install fulltextsearch
docker exec -u www-data app-server php occ --no-warnings app:install fulltextsearch_elasticsearch
docker exec -u www-data app-server php occ --no-warnings app:install files_fulltextsearch
docker exec -u www-data app-server php occ --no-warnings app:enable files_external

docker exec -u www-data app-server php occ --no-warnings config:system:set onlyoffice DocumentServerUrl --value="/ds-vpath/"
docker exec -u www-data app-server php occ --no-warnings config:system:set onlyoffice DocumentServerInternalUrl --value="http://nextcloud_onlyoffice-document-server.1.7cbwky50a2n2kzhigynk2389s/"
docker exec -u www-data app-server php occ --no-warnings config:system:set onlyoffice StorageUrl --value="http://nextcloud_nginx.1.41d2jknvpgnhdmr3kkdlp8cbt/"

docker exec -u www-data app-server php occ --no-warnings config:app:set fulltextsearch search_platform --value="OCA\\FullTextSearch_Elasticsearch\\Platform\\ElasticSearchPlatform"
docker exec -u www-data app-server php occ --no-warnings config:app:set fulltextsearch app_navigation --value="1"
docker exec -u www-data app-server php occ --no-warnings config:app:set fulltextsearch_elasticsearch elastic_host --value="http:// nextcloud_elasticsearch.1.poqsxefnugg2uh88bqhbt56xd:9200/"
docker exec -u www-data app-server php occ --no-warnings config:app:set fulltextsearch_elasticsearch elastic_index --value="my_index"

docker exec -u www-data app-server php /var/www/html/occ fulltextsearch:index