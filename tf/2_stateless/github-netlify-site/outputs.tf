output "netlify_site" {
    value = netlify_site.main
}
output "netlify_deploy_key" {
    value = netlify_deploy_key.main
}
output "cloudflare_record" {
    value = cloudflare_record.main
}
output "github_readme" {
    value = github_repository_file.readme-terraform
}