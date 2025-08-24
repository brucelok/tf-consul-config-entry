resource "consul_config_entry" "service_defaults_api" {
  kind = "service-defaults"
  name = "api"

  config_json = jsonencode({
    Protocol         = "http"
    Expose           = {}
    MeshGateway      = {}
    TransparentProxy = {}
  })
}

resource "consul_config_entry" "service_defaults_api_v1" {
  kind = "service-defaults"
  name = "api-v1"

  config_json = jsonencode({
    Protocol         = "http"
    Expose           = {}
    MeshGateway      = {}
    TransparentProxy = {}
  })
}

resource "consul_config_entry" "service_router_api" {
  depends_on = [
    consul_config_entry.service_defaults_api,
    consul_config_entry.service_defaults_api_v1
  ]

  kind = "service-router"
  name = "api"

  config_json = jsonencode({
    Routes = [
      {
        Match = {
          HTTP = {
            PathPrefix = "/v1"
          }
        }
        Destination = {
          Service = "api-v1"
        }
      }
    ]
  })
}
