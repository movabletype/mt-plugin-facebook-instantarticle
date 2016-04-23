config="plugins/FacebookInstantArticle/config.yaml"
library="plugins/FacebookInstantArticle/lib/FacebookInstantArticle/Tags.pm"
readme="readme.md readme_ja.md"

VERSION=`grep version ${config} | awk '{print $2}'`

zip pkg/mt-plugin-facebookinstantarticle-${VERSION}.zip $config $library $readme


