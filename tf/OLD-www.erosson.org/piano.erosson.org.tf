resource "aws_s3_bucket" "piano_erosson_org" {
  bucket = "piano.erosson.org"
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
      "Resource":["arn:aws:s3:::piano.erosson.org/*"]
    }
  ]
}
POLICY

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "cloudflare_record" "piano_erosson_org" {
  domain  = "erosson.org"
  name    = "piano"
  type    = "CNAME"
  value   = "piano.erosson.org.s3-website-us-east-1.amazonaws.com"
  proxied = true
}
