resource "kubernetes_namespace" "example" {
    metadata {
        annotations = {
            name = "example-annotation"
        }
        labels = {
            mylabel = "example"
        }
        name = "terraform-example-namespace"
    }
}

resource "kubernetes_namespace" "ambassador" {
    metadata {
        annotations = {
            name = "ambassador"
        }
        labels = {
            mylabel = "ambassador"
        }
        name = "ambassador"
    }
}
