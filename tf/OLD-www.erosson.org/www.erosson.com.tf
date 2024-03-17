resource "aws_s3_bucket" "www_erosson_com" {
  bucket = "www.erosson.com"
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
      "Resource":["arn:aws:s3:::www.erosson.com/*"]
    }
  ]
}
POLICY

  website {
    redirect_all_requests_to = "https://www.erosson.com"
  }
}

resource "cloudflare_record" "www_erosson_com" {
  domain  = "erosson.com"
  name    = "www"
  type    = "CNAME"
  value   = "www.erosson.com.s3-website-us-east-1.amazonaws.com"
  proxied = true
}
