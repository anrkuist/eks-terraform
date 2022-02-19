data "aws_eks_cluster" "default" {
  name = module.eks.cluster_id 
}

data "aws_eks_cluster_auth" "default" {
  name = module.eks.cluster_id 
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.default.token
}

resource "local_file" "kubeconfig" {
  sensitive_content = templatefile("${path.module}/kubeconfig.tpl", {
    cluster_name = module.eks.cluster_id,
    clusterca    = data.aws_eks_cluster.default.certificate_authority[0].data,
    endpoint     = data.aws_eks_cluster.default.endpoint,
    })
  filename          = "./kubeconfig-${module.eks.cluster_id}"
}
