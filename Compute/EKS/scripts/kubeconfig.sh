#!/bin/bash
# Script to update the local kubeconfig file for EKS access

EKS_CLUSTER_NAME="eks-demo-cluster"

echo "Updating kubeconfig for cluster: $EKS_CLUSTER_NAME"
aws eks update-kubeconfig --name "$EKS_CLUSTER_NAME"

if [ $? -eq 0 ]; then
    echo "SUCCESS: kubeconfig updated. You can now run 'kubectl get nodes'."
else
    echo "ERROR: Failed to update kubeconfig. Ensure the AWS CLI is configured and the cluster name is correct."
fi
