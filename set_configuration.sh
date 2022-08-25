#!/bin/bash
set -x

docker-compose up -d
sleep 20
# docker exec -u www-data app-server /bin/bash -c "export OC_PASS=AnswerPRO! && php occ user:add --password-from-env --display-name='Administrator' --group='admins' admin"
docker exec -u www-data app-server /bin/bash -c 'php occ  maintenance:install --admin-user "admin" --admin-pass "AnswerPRO!"'

docker exec -u www-data app-server php occ --no-warnings config:system:get trusted_domains >> trusted_domain.tmp

if ! grep -q "nginx-server" trusted_domain.tmp; then
    TRUSTED_INDEX=$(cat trusted_domain.tmp | wc -l);
    docker exec -u www-data app-server php occ --no-warnings config:system:set trusted_domains $TRUSTED_INDEX --value="nginx-server"
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
docker exec -u www-data app-server php occ --no-warnings config:system:set onlyoffice DocumentServerInternalUrl --value="http://onlyoffice-document-server/"
docker exec -u www-data app-server php occ --no-warnings config:system:set onlyoffice StorageUrl --value="http://nginx-server/"

docker exec -u www-data app-server php occ --no-warnings config:app:set fulltextsearch search_platform --value="OCA\\FullTextSearch_Elasticsearch\\Platform\\ElasticSearchPlatform"
docker exec -u www-data app-server php occ --no-warnings config:app:set fulltextsearch app_navigation --value="1"
docker exec -u www-data app-server php occ --no-warnings config:app:set fulltextsearch_elasticsearch elastic_host --value="http://elasticsearch_nc:9200/"
docker exec -u www-data app-server php occ --no-warnings config:app:set fulltextsearch_elasticsearch elastic_index --value="my_index"

docker exec -u www-data app-server php /var/www/html/occ fulltextsearch:index