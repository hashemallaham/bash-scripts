#!/bin/bash
# configuration
REPO_URL="https://github.com/hashemallaham/myproject1.git"
REPO_NAME="myproject1"
WORKDIR="/app"
BACKUP_DIR="/backup/app"

# Backup existing deployment (useful in case of rolling back)
echo "Backing up current deployment..."
sudo mkdir -p $BACKUP_DIR
tar -czf $BACKUP_DIR/backup_$(date +%F-%H-%M-%S).tar.gz $WORKDIR && rm -rf $WORKDIR

# Pull the latest code of the project
mkdir -p $WORKDIR
cd $WORKDIR
git clone $REPO_URL
cd $REPO_NAME

# Build or compile your application if needed echo "Building or Packaging the application..." ./mvnw package
# Running the Application
java -jar target/*.jar

# The appliction can be accessed via http://localhost:8080
