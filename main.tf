resource "kubernetes_role" "read" {
  for_each = toset(var.namespaces)
  metadata {
    name      = var.user
    namespace = each.value
  }

  rule {
    api_groups = [""]
    resources = [
      "pods",
      "configmaps",
      "pods/log",
      "pods/exec",
      "pods/portforward",
      "services",
      "services",
      "services/status",
      "deployments",
      "deployments/scale",
      "secrets",
      "pods",
    ]
    verbs = [
      "get",
      "list",
      "watch",
      "create",
      "update",
      "patch",
      "delete",
    ]
  }
  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "pods"]
    verbs = [
      "get",
      "list",
      "watch",
      "create",
      "update",
      "patch",
      "delete",
    ]
  }
}


resource "kubernetes_role_binding" "read" {
  for_each = toset(var.namespaces)
  metadata {
    name      = var.user
    namespace = each.value
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = var.user
  }
  subject {
    kind      = "User"
    name      = var.user
    api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = each.value
  }
  subject {
    kind      = "Group"
    name      = var.group
    api_group = "rbac.authorization.k8s.io"
  }
}




resource "kubernetes_cluster_role" "namespace_list" {
  metadata {
    name = "namespace-list"
    annotations = {
      "rbac.authorization.kubernetes.io/autoupdate" = "true"
    }
    labels = {
      "kubernetes.io/bootstrapping" = "rbac-defaults"
      "rbac.authorization.k8s.io/aggregate-to-edit" : "true"
    }
  }
  rule {
    api_groups = [""]
    resources = [
      "namespaces",
      "events"
    ]
    verbs = [
      "get",
      "list",
    ]
  }
}

resource "kubernetes_cluster_role_binding" "cluster_role_binding" {
  for_each = toset(var.namespaces)
  metadata {
    name = "${each.value}-default"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.namespace_list.metadata[0].name
  }
  subject {
    kind      = "User"
    name      = var.user
    api_group = "rbac.authorization.k8s.io"
    namespace = each.value
  }
  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = each.value
  }
  subject {
    kind      = "Group"
    name      = var.group
    api_group = "rbac.authorization.k8s.io"
  }
}


