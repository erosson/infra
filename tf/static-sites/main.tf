# # An ECR repository is a private alternative to Docker Hub.
# resource "aws_ecr_repository" "main" {
#   name = "erosson.org"
# }
# output "ecr_repository_url" {
#   value = aws_ecr_repository.main.repository_url
# }
# 
# resource "aws_apprunner_service" "main" {
#   service_name = "public-infra-static-sites"
# 
#   source_configuration {
#     authentication_configuration {
#       # TODO: currently using a console-created user. create one via tf instead!
#       access_role_arn = "arn:aws:iam::533267433127:role/service-role/AppRunnerECRAccessRole"
#     }
#     image_repository {
#       image_configuration {
#         port = "5000"
#         runtime_environment_variables = {
#           EARTHENGINE_PROJECT_ID = local.earthengine_project_id
#           EARTHENGINE_PRIVATE_KEY_BASE64 = local.earthengine_private_key_base64
#         }
#       }
#       image_identifier = "${aws_ecr_repository.main.repository_url}:latest"
#       image_repository_type = "ECR"
#     }
#     auto_deployments_enabled = true
#   }
#   health_check_configuration {
#     protocol = "HTTP"
#     path = "/"
#   }
#   instance_configuration {
#     cpu = "256"
#     memory = "512"
#   }
# }

resource "cloudflare_record" "ops" {
  zone_id = "7c06b35c2392935ebb0653eaf94a3e70" // erosson.org
  type = "CNAME"
  name = "ops"
  value = "oyster-app-sevdh.ondigitalocean.app."
  proxied = "false"
  # depends_on = [cloudflare_pages_domain.main]
}
resource "cloudflare_record" "docker-ops" {
  zone_id = "7c06b35c2392935ebb0653eaf94a3e70" // erosson.org
  type = "CNAME"
  name = "docker-ops"
  value = "oyster-app-sevdh.ondigitalocean.app."
  proxied = "false"
  # depends_on = [cloudflare_pages_domain.main]
}
resource "cloudflare_record" "math2" {
  zone_id = "2526e11f0b20a0e69b0fcfb1e5a21d21" // swarmsim.com
  type = "CNAME"
  name = "docker-math2"
  value = "oyster-app-sevdh.ondigitalocean.app."
  proxied = "false"
  # depends_on = [cloudflare_pages_domain.main]
}
resource "cloudflare_record" "cooking" {
  zone_id = "7c06b35c2392935ebb0653eaf94a3e70" // erosson.org
  type = "CNAME"
  name = "docker-cooking"
  value = "oyster-app-sevdh.ondigitalocean.app."
  proxied = "false"
  # depends_on = [cloudflare_pages_domain.main]
}
resource "cloudflare_record" "vegas-wordle" {
  zone_id = "7c06b35c2392935ebb0653eaf94a3e70" // erosson.org
  type = "CNAME"
  name = "docker-vegas-wordle"
  value = "oyster-app-sevdh.ondigitalocean.app."
  proxied = "false"
  # depends_on = [cloudflare_pages_domain.main]
}
resource "cloudflare_record" "freecbt" {
  zone_id = "7c06b35c2392935ebb0653eaf94a3e70" // erosson.org
  type = "CNAME"
  name = "docker-freecbt"
  value = "oyster-app-sevdh.ondigitalocean.app."
  proxied = "false"
  # depends_on = [cloudflare_pages_domain.main]
}
resource "cloudflare_record" "zealgame" {
  zone_id = "ff0d132b2612531ac86aa3fb825d6415" // zealgame.com
  type = "CNAME"
  name = "docker"
  value = "oyster-app-sevdh.ondigitalocean.app."
  proxied = "false"
  # depends_on = [cloudflare_pages_domain.main]
}
resource "cloudflare_record" "www-zealgame" {
  zone_id = "ff0d132b2612531ac86aa3fb825d6415" // zealgame.com
  type = "CNAME"
  name = "docker-www"
  value = "oyster-app-sevdh.ondigitalocean.app."
  proxied = "false"
  # depends_on = [cloudflare_pages_domain.main]
}