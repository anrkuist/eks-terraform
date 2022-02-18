apiVersion: v1
preferences: {}
kind: Config

clusters:
- cluster:
    server: module.eks.cluster_endpoint 
    certificate-authority-data: module.eks.cluster_certificate_authority_data
  name: module.eks.cluster_id

contexts:
- context:
    cluster: module.eks.cluster_id
    user: "terraform" 
  name: "terraform"

current-context: "terraform" 

users:
- name: "terraform"
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - token
        - --cluster-id
        - ${cluster_name}
