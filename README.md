# ibm-cloud-vpc-roks

Terraform configuration for Red Hat OpenShift on IBM Cloud VPC gen-2 infrastructure.

## Terraform Examples

Initialize

```shell
terraform init
```

Plan

```shell
export IBMCLOUD_API_KEY=<your_api_key>
terraform plan \
    -var 'cluster_name=fulcrum' \
    -var 'disable_public_service_endpoint=true' \
    -var 'worker_node_flavor=bx2.16x64' \
    -var 'addons=[{"name":"openshift-data-foundation", "version":"4.7.0"}]' \
    -out example.tfplan
```

Create

```shell
terraform apply example.tfplan
```

Delete

```shell
terraform destroy -auto-approve
```

## Schematics Examples

Login

```shell
export IBMCLOUD_API_KEY=<your_api_key>
ibmcloud login
```

Create the workspace

```shell
ibmcloud schematics workspace new -f schematics-example.json
```

Create

```shell
WORKSPACE_ID=$(ibmcloud schematics workspace list | awk '/^roks-cluster/ { print $2 }')
ibmcloud schematics apply -i ${WORKSPACE_ID} -f
```

Delete

```shell
WORKSPACE_ID=$(ibmcloud schematics workspace list | awk '/^roks-cluster/ { print $2 }')
ibmcloud schematics destroy -i ${WORKSPACE_ID} -f
ibmcloud schematics workspace delete -i ${WORKSPACE_ID} -f
```
