module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.7.1"
  
  cluster_name = "app-eks-cluster"
  cluster_version = "1.21"

  subnet_ids = module.eks-vpc.private_subnets
  vpc_id = module.eks-vpc.vpc_id

  tags = {
    enviroment = "development"
    application = "app"
  }

  self_managed_node_group_defaults = {
    disk_size = 20
  }

   self_managed_node_groups = {
     worker_group_1 = {
       name = "worker-group-1"
       instance_type  = "t2.micro"
       desired_size = 2
       min_size = 0
       max_size = 2
     }

/*		mixed = {
      name = "mixed"

      min_size     = 1
      max_size     = 3 
      desired_size = 3
      instance_type = "t2.micro"

      bootstrap_extra_args = "--kubelet-extra-args '--node-labels=node.kubernetes.io/lifecycle=spot'"

      use_mixed_instances_policy = true
      mixed_instances_policy = {
        instances_distribution = {
          spot_allocation_strategy = "lowest-price"
        }

        override = [
          {
            instance_type     = "t2.micro"
            weighted_capacity = "2"
          },
          {
            instance_type     = "t2.small"
            weighted_capacity = "1"
          },
        ]
      }
    } */
  }
}
