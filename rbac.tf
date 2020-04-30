#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Set RBAC
# Grant cluster admin role to members of k8s-devops group
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
resource "kubernetes_cluster_role_binding" "sw-devops" {
    metadata {
        name = "sw-devops-rbac-binding"
    }
    role_ref {
        api_group = "rbac.authorization.k8s.io"
        kind      = "ClusterRole"
        name      = "sw-devops-rbac"
    }
    subject {
        kind      = "Group"
        name      = "k8s-devops@shipwire.com"
        api_group = "rbac.authorization.k8s.io"
    }
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Set RBAC
# Grant pod reader role to members of k8s-qa group
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
resource "kubernetes_cluster_role" "sw-qa-role" {
    metadata {
        name = "sw-qa-role"
    }
    rule {
        api_groups = [""]
        resources  = ["namespaces", "pods"]
        verbs     = ["get", "list", "watch"]
    }
}

resource "kubernetes_cluster_role_binding" "sw-qa" {
    metadata {
        name = "sw-qa-rbac-binding"
    }
    role_ref {
        api_group = "rbac.authorization.k8s.io"
        kind      = "ClusterRole"
        name      = "sw-qa-role"
    }
    subject {
        kind      = "Group"
        name      = "k8s-qa@shipwire.com"
        api_group = "rbac.authorization.k8s.io"
    }
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Set RBAC
# Grant admin role to members of k8s-dev group to designated namespaces
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
resource "kubernetes_role" "sw-dev-example" {
    metadata {
        name = "dev-example-role"
        labels = {
            test = "MyRole"
        }
    }
    rule {
        api_groups      = [""]
        resources       = ["pods, deployments, services"]
        verbs           = ["get","create","update","patch","delete"]
    }
}

resource "kubernetes_role_binding" "sw-dev-binding-example" {
    metadata {
        name       = "dev-example-role-binding"
        namespace  = "terraform-example-namespace"
    }
    role_ref {
        api_group = "rbac.authorization.k8s.io"
        kind      = "Role"
        name      = "sw-dev"
    }
    subject {
        kind      = "Group"
        name      = "k8s-dev-example@shipwire.com"
        api_group = "rbac.authorization.k8s.io"
    }
}