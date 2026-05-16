#!/bin/bash
DATE=$(date +%Y-%m-%d-%H-%M-%S)
BACKUP_DIR="$HOME/backups/$DATE"

mkdir -p $BACKUP_DIR

echo "Starting backup..."



echo "Taking MySQL backup..."

kubectl exec -n dev mysql-0 -- \
  mysqldump --no-tablespaces -u skillpulse -pskillpulse123 skillpulse \
  > $BACKUP_DIR/mysql-backup.sql


echo "Backing up Kubernetes manifests..."

kubectl get all -n dev -o yaml > $BACKUP_DIR/dev-k8s.yaml
kubectl get all -n staging -o yaml > $BACKUP_DIR/staging-k8s.yaml
kubectl get all -n prod -o yaml > $BACKUP_DIR/prod-k8s.yaml


echo "Backing up ConfigMaps and Secrets..."

kubectl get configmap -A -o yaml > $BACKUP_DIR/configmaps.yaml
kubectl get secret -A -o yaml > $BACKUP_DIR/secrets.yaml


echo "Compressing backup..."

cd ~/backups

tar -czf ${DATE}.tar.gz $DATE

rm -rf $DATE



echo "Cleaning old backups..."

find ~/backups -name "*.tar.gz" -mtime +7 -delete

# Done

echo "Backup completed successfully!"