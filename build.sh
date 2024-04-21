#!/bin/bash

echo -e "Creating the 'deploy' folder tree"

echo -e "Building MVC project..."
nuget restore eShopModernizedMVCSolution/eShopModernizedMVC.sln
msbuild eShopModernizedMVCSolution/src/eShopModernizedMVC/eShopModernizedMVC.csproj /nologo /p:PublishProfile=FolderProfile.pubxml /p:DeployOnBuild=true /p:docker_publish_root=../../../deploy/mvc/

echo -e "Building Webforms project..."
nuget restore eShopModernizedWebFormsSolution/eShopModernizedWebForms.sln
msbuild eShopModernizedWebFormsSolution/src/eShopModernizedWebForms/eShopModernizedWebForms.csproj /nologo /p:PublishProfile=FolderProfile.pubxml /p:DeployOnBuild=true /p:docker_publish_root=../../../deploy/webforms/

echo -e "Building WCF project..."
nuget restore eShopModernizedNTier/eShopModernizedNTier.sln
msbuild eShopModernizedNTier/src/eShopWCFService/eShopWCFService.csproj /nologo /p:PublishProfile=FolderProfile.pubxml /p:DeployOnBuild=true /p:docker_publish_root=../../../deploy/wcf/

echo -e "Copying Dockerfiles to deploy folder"
cp -f eShopModernizedNTier/src/eShopWCFService/Dockerfile deploy/wcf
cp -f eShopModernizedMVCSolution/src/eShopModernizedMVC/Dockerfile deploy/mvc
cp -f eShopModernizedWebFormsSolution/src/eShopModernizedWebForms/Dockerfile deploy/webforms

echo -e "\033[93m Building docker images...\033[0m"
#docker-compose -f docker-compose.yml -f docker-compose.override.yml build
