#!/bin/bash
set -ex

# docker build -t circleci-demo-docker:$TAG .
# echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
# docker push circleci-demo-docker:$TAG

# $ docker run --rm -it -v "$PWD":/usr/src/myapp -w /usr/src/myapp golang:1.17 bash
# $ for GOOS in darwin linux; do
# >   for GOARCH in 386 amd64; do
# >     export GOOS GOARCH
# >     go build -v -o myapp-$GOOS-$GOARCH
# >   done
# > done

export APP_NAME=faceit
export APP_PORT=8080

export POSTGRESQL_HOST="localhost"
export POSTGRESQL_PORT="5432"
export POSTGRESQL_USER="postgres"
export POSTGRESQL_PASSWORD="mysecretpassword"
export POSTGRESQL_DBNAME="postgres"



option="${1}"
CURDIR="$(pwd)"
ls -all


echo_info() {
    date_now=$(date "+%Y-%m-%d %H:%M:%S")
    echo -e "\e\033[32m"[INFO]----[${date_now}] --------------$1--------------$"\033[0m"
}

echo_error() {
    date_now=$(date "+%Y-%m-%d %H:%M:%S:%N")
    echo -e "\e\033[31m"[ERROR]----[${date_now}] --------------$1--------------$"\033[0m"
}

echo_debug() {
    date_now=$(date "+%Y-%m-%d %H:%M:%S:%N")
    echo -e "\e\033[33m"[DEBUG]----[${date_now}] --------------$1--------------$"\033[0m"
}

is_exist_app() {
    echo_debug " $FUNCNAME is starting... with arguments  $@"
    app=${1}
    command -v ${app} >/dev/null 2>&1 || { echo_error >&2 "Require ${app} but it's not installed.  Aborting."; exit 1; }
}

if command -v git > /dev/null; then
    VERSION="$(git describe --tags --always --abbrev=0 --match='v[0-9]*.[0-9]*.[0-9]*' 2> /dev/null | sed 's/^.//')"
    COMMIT_HASH="$(git rev-parse --short HEAD)"
    BUILD_TIMESTAMP=$(date '+%Y-%m-%dT%H:%M:%S')
fi

export TAG=0.1.${CIRCLE_BUILD_NUM:-"$COMMIT_HASH"}



usage() {
    echo '
1. To build docker images
    sh build.sh image_build
2. To push docker images to registry
    sh build.sh image_push
3. To test docker packages
    sh build.sh test_package

    '
}
check_health() {
    is_exist_app curl
    docker ps -a
    docker logs faceit
    #IP_ADDR=$(/sbin/ifconfig -a | grep inet | grep -v 127.0.0.1 | grep -v inet6 | awk '{print $2}' | head -1 | tr -d "addr:")
    # curl -v http://${IP_ADDR}:8080/health
    curl -v http://localhost:8080/health
    if [[ $? != 0 ]]; then
        echo_error "Cannot connect to the database"
        exit 1
    fi
}

docker_image_build() {
    echo_info "Docker image build started"
    ls | grep "Dockerfile"
    if [ $? != "0" ]; then
        echo "Dockerfile not exist in ${CURDIR}"
        exit 1
    fi
    docker-compose build --no-cache
    # docker build -t ${APP_NAME}:${TAG} --build-arg VERSION=${TAG} -f Dockerfile
}

docker_image_push() {
    echo_info "Docker image push to registry"
    echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin
    docker push anatolman/${APP_NAME}:${TAG}
}

test_package() {
    echo_info "Postgresql and app container starting"
    # docker run --rm --name=postrgres -p 5432:5432 -e POSTGRES_PASSWORD=mysecretpassword -d postgres:13-alpine

    # docker run -it --name=${APP_NAME}_${TAG} -d
    docker-compose up -d
    check_health

    echo_info "TESTED VERSION:${TAG}"
}



main() {
    case ${option} in
    docker_image_build)
        docker_image_build
        ;;
    docker_image_push)
        docker_image_push
        ;;
    test_package)
        test_package
        ;;
    *)
        usage
        ;;
    esac
}

main