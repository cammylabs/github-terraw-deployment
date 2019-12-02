#!/bin/sh


function main(){
  sanitize "${INPUT_ENVIROMENT}" "enviroment"
  sanitize "${INPUT_AWS_REGION}" "aws_region"
  sanitize "${INPUT_ACCESS_KEY_ID}" "access_key_id"
  sanitize "${INPUT_SECRET_ACCESS_KEY}" "secret_access_key"

  setUpAWSCredential INPUT_ENVIROMENT
  runDeployer
}

function sanitize(){
  if [ -z "${1}" ]; then
    >&2 echo "Unable to find the ${2}. Did you set with.${2}?"
    exit 1
  fi
}

function  setUpAWSCredential() {
  echo 'SETTING UP AWS CREDENTIAL FOR ' ${INPUT_ENVIROMENT}

  export AWS_ACCESS_KEY_ID=${INPUT_ACCESS_KEY_ID}
  export AWS_SECRET_ACCESS_KEY=${INPUT_SECRET_ACCESS_KEY}
  export AWS_DEFAULT_REGION=${INPUT_AWS_REGION}

  aws configure set aws_access_key_id ${INPUT_ACCESS_KEY_ID}
  aws configure set aws_secret_access_key ${INPUT_SECRET_ACCESS_KEY}
  aws configure set region ${INPUT_AWS_REGION}

  echo 'AWS CREDENTIALS DONE'
}

function runDeployer() {
  echo 'RUNINING DEPLOYMENT FOR ' ${INPUT_ENVIROMENT}

  cd deployment
  sh ./deploy.sh ${INPUT_ENVIROMENT}

  echo 'DEPLOYMENT ' ${INPUT_ENVIROMENT} ' DONE'
}

echo '[entrypoint.sh] STARTING DEPLOYMENT'
main