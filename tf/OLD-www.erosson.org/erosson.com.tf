resource "aws_s3_bucket" "erosson_com" {
  bucket = "erosson.com"
  acl    = "public-read"

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"AddPerm",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::erosson.com/*"]
    }
  ]
}
POLICY

  website {
    redirect_all_requests_to = "https://www.erosson.org"
  }
}

# cloudflare's unusually smart - a root "CNAME" is allowed; "A" not required.
resource "cloudflare_record" "erosson_com" {
  domain  = "erosson.com"
  name    = "erosson.com"
  type    = "CNAME"
  value   = "erosson.com.s3-website-us-east-1.amazonaws.com"
  proxied = true
}
