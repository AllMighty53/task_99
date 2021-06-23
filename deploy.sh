#!/usr/bin/env bash

dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

function deploy_get {
    pushd bin/get && zip -o get.zip *.py
    popd\
    && terraform apply -auto-approve
}

function deploy_post {
    pushd bin/get && zip -o post.zip *.py
    popd\
    && terraform apply -auto-approve
}

case "$1" in
        post)
            deploy_post
            ;;       
        get)
           deploy_get
           ;;
        *)
            echo "Usage: $0 deploy_post or deploy_get"
            exit 1
 
esac


