# Github Action: <i>terraw</i> Project Deployment

#### THIS IS PUBLIC PROJECT, KEEP SECRETS AWAY 

This action wraps [terraw](https://github.com/miere/terraw) generated deployment script, uploads Docker to ECR and spin up new Code Deploy.


## Required permissions:
 You should use *deployment_user* credentials for deployment, but if for some reason this is not an option, these are
 the minimum permissions that one should have to successfully deploy service.


<b>ECR</b>

- GetAuthorizationToken
- BatchGetImage
- GetDownloadUrlForLayer

<b> Codeploy</b>

- CreateDeployment

<b> SSM </b>

- GetParameter
- DescribeParameters

<B> Different lambdas require different permissions though </b> 


## Required Parameters

Four parameters must be passed to run action succesfully



```yml
    access_key_id: KEEP THIS SECRET
    secret_access_key: KEEP THIS SECRET 
    aws_region: us-east-1   // Region recognized by AWS
    enviroment: staging-us  // Enviroment recognized by terraw
```

Right now ( November 2019 ) github does not offer global secrets, so access and secret key must be specified per repo.

Github recognized this, as an problem and working on solution. Keep checking this topic for updates: [CLICK](https://github.community/t5/GitHub-Actions/Method-ability-to-share-secrets-across-multiple-repositories-in/td-p/30958)

## Dockerfile 
This is Dockerfile based action. 

It's using official <i>dind</i> (Docker inside Docker) image with addition of AWS CLI and Python goodies to install AWS CLI


## Folder structure 

This is not valid anymore, unless you want to downloand this action and run directly from repo 

_____

I could not find any information about shh'ing action from different repository. The only way is to make it public and
expose in Marketplace. 
Or keep it in the same directory 

```.env

root 
 ├─ .github	
     ├─build-and-deploy
     │   ├─ action.yml
     │   ├─ Dockerfile
     │   └─ entrypoint.sh
     │ 
     ├─workflows
         └─ main.yml   
```

## Example
Sample main.yml to trigger action:
 ```yml
on:
  push:
    branches:
      - 'develop'
jobs:
  upload-and-deploy:
    name: Deploy Dockerfile
    runs-on: ubuntu-latest
    steps:
       - name: Checkout
        uses: actions/checkout@v1
       - name: Terraw Build and deploy
        uses: cammylabs/github-terraw-deployment@1.00.2
        with:
          access_key_id: ${{ secrets.SECRET_ID }}
          secret_access_key: ${{ secrets.SECRET_KEY_ }}
          aws_region: us-east-1
          enviroment: staging
```

In case of deploying service to multiple regions, we need to specify multiple jobs.
