# =============================================================================
# EKS ADD-ONS AND EXTENSIONS
# =============================================================================

module "eks_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.0"

  # Cluster information
  cluster_name      = module.retail_app_eks.cluster_name
  cluster_endpoint  = module.retail_app_eks.cluster_endpoint
  cluster_version   = module.retail_app_eks.cluster_version
  oidc_provider_arn = module.retail_app_eks.oidc_provider_arn

  # =============================================================================
  # CERT-MANAGER - SSL Certificate Management
  # =============================================================================
  enable_cert_manager = true
  cert_manager = {
    most_recent = true
    namespace   = "cert-manager"
  }

  # =============================================================================
  # NGINX INGRESS CONTROLLER - Load Balancing and Routing
  # NOTE: Using NodePort because this AWS account does not permit ELB/NLB creation.
  #       To switch to LoadBalancer later, change service.type back to "LoadBalancer",
  #       restore externalTrafficPolicy to "Local", and re-add the set_sensitive
  #       NLB annotations below.
  # =============================================================================
  enable_ingress_nginx = true
  ingress_nginx = {
    most_recent = true
    namespace   = "ingress-nginx"

    # Allow enough time for the controller pod to start on EKS Auto Mode nodes
    timeout = 600

    set = [
      # NodePort avoids triggering AWS LoadBalancer creation (account restriction)
      {
        name  = "controller.service.type"
        value = "NodePort"
      },
      # Cluster policy required for NodePort (Local only works with LoadBalancer)
      {
        name  = "controller.service.externalTrafficPolicy"
        value = "Cluster"
      },
      {
        name  = "controller.resources.requests.cpu"
        value = "100m"
      },
      {
        name  = "controller.resources.requests.memory"
        value = "128Mi"
      },
      {
        name  = "controller.resources.limits.cpu"
        value = "500m"
      },
      {
        name  = "controller.resources.limits.memory"
        value = "512Mi"
      },
      # Disable admission webhook hooks to prevent post-upgrade job timeouts
      {
        name  = "controller.admissionWebhooks.enabled"
        value = "false"
      },
      {
        name  = "controller.admissionWebhooks.patch.enabled"
        value = "false"
      }
    ]
  }

  # =============================================================================
  # OPTIONAL: MONITORING STACK
  # =============================================================================
  # Uncomment below to enable monitoring (increases costs)

  # enable_kube_prometheus_stack = var.enable_monitoring
  # kube_prometheus_stack = {
  #   most_recent = true
  #   namespace   = "monitoring"
  # }

  # =============================================================================
  # OPTIONAL: AWS LOAD BALANCER CONTROLLER
  # =============================================================================
  # enable_aws_load_balancer_controller = true
  # aws_load_balancer_controller = {
  #   most_recent = true
  #   namespace   = "kube-system"
  # }

  depends_on = [module.retail_app_eks]
}
