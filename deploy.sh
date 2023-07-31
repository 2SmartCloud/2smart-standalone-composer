docker login -u gitlab-ci-token -p $CI_JOB_TOKEN $CI_REGISTRY
docker-compose -f docker-compose.yml -f docker-compose.demo.yml down
docker-compose -f docker-compose.yml -f docker-compose.demo.yml pull
docker-compose -f docker-compose.yml -f docker-compose.demo.yml up -d
