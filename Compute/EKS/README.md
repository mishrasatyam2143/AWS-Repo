#  AWS EKS: Managed Kubernetes Deployment

This directory provides a full, deployable example of an AWS EKS cluster, complete with its dedicated VPC, Managed Node Groups, and sample Kubernetes manifests, all defined via Terraform.

## Prerequisites

* **AWS CLI:** Configured with sufficient permissions.
* **Terraform:** Installed locally.
* **kubectl:** Installed locally for interacting with the cluster.

## Deployment Steps

### Step 1: Initialize and Deploy Infrastructure

1.  Navigate to the Terraform directory:
    ```bash
    cd terraform
    ```
2.  Initialize the workspace:
    ```bash
    terraform init
    ```
3.  Review the plan and deploy the cluster (this takes 15-20 minutes):
    ```bash
    terraform apply --auto-approve
    ```
    *Note: The cluster name is outputted upon completion.*

### Step 2: Configure kubectl Access

After deployment, you must update your local Kubernetes configuration file (`~/.kube/config`) to connect to the EKS cluster.

1.  Return to the main EKS directory:
    ```bash
    cd ..
    ```
2.  Run the helper script using the cluster name from the Terraform output:
    ```bash
    ./scripts/kubeconfig.sh
    ```
3.  Verify the connection:
    ```bash
    kubectl get nodes
    ```

### Step 3: Deploy Sample Application

1.  Apply the sample Nginx deployment and service manifests:
    ```bash
    kubectl apply -f manifests/
    ```
2.  Check the service to get the Load Balancer endpoint:
    ```bash
    kubectl get svc nginx-service
    ```
    The external endpoint will be listed in the `EXTERNAL-IP` column.# EKS docs coming soon
