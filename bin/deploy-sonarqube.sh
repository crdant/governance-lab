#!/usr/bin/env bash
set -e

ytt -f sonarqube -f secrets/local-config.yml --ignore-unknown-comments | kapp deploy -n tanzu-kapp --into-ns sonarqube -a sonarqube -y -f -
