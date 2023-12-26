output "cloudflare_pages_project" {
    value = cloudflare_pages_project.main
}
output "cloudflare_pages_domain" {
    value = cloudflare_pages_domain.main
}
output "cloudflare_record" {
    value = cloudflare_record.main
}
output "github_readme" {
    value = github_repository_file.readme-terraform
}