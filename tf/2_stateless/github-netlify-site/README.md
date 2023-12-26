good try, but netlify terraform providers seem to be broken and unusable:

    Error: json: cannot unmarshal number into Go struct field RepoInfo.installation_id of type string
    │ 
    │   with module.test-tf-netlify_erosson_org.netlify_site.main,
    │   on github-netlify-site/site.tf line 31, in resource "netlify_site" "main":
    │   31: resource "netlify_site" "main" {

https://github.com/hashicorp/terraform-provider-netlify/issues/40