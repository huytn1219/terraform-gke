#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Adding Ambassador API Gateway into the cluster
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
resource "helm_release" "ambassador" { 
    name        = "ambassador"
    repository  = "https://www.getambassador.io" 
    chart       = "ambassador"
    namespace   = "ambassador"
    wait        = true

    depends_on = [
        kubernetes_namespace.ambassador,
    ]
}