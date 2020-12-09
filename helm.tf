resource "helm_release" "ps_app" {
  name  = "ps-app"
  chart = "./ps-app"
  wait  = true
}