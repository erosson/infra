resource "aws_s3_bucket" "www_erosson_org" {
  bucket = "www.erosson.org"
  acl    = "public-read"

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[{
    "Sid":"PublicReadGetObject",
    "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::www.erosson.org/*"]
    }
  ]
}
POLICY

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "cloudflare_record" "www_erosson_org" {
  domain  = "erosson.org"
  name    = "www"
  type    = "CNAME"
  value   = "www.erosson.org.s3-website-us-east-1.amazonaws.com"
  proxied = true
}

# A newly-created AWS user deploys to S3 on commit.
# Permissions are restricted to this project's S3 bucket.
resource "aws_iam_user" "deploy" {
  name = "deploy@www.erosson.org"
}

# https://www.terraform.io/docs/providers/aws/r/iam_access_key.html
# Secret key is written to terraform's state file, encrypted with my secret key.
# Provisioner tells travis about it after creation.
# TODO: delete the secret key from terraform after creation; it's not needed once travis knows about it
#
# from https://www.terraform.io/docs/providers/aws/r/iam_access_key.html :
# > terraform output deploy_access_key
# > terraform output deploy_secret_key | base64 --decode | keybase pgp decrypt
resource "aws_iam_access_key" "deploy" {
  user    = "${aws_iam_user.deploy.name}"
  pgp_key = "keybase:erosson"

  # set CI variables. There is no create-or-update: PUT updates, POST creates.
  # https://docs.gitlab.com/ee/api/project_level_variables.html
  # > curl --request POST --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "https://gitlab.com/api/v4/projects/erosson%2Ferosson-org/variables" --form "key=AWS_SECRET_ACCESS_KEY" --form "value=$(echo ${aws_iam_access_key.deploy.encrypted_secret} | base64 --decode | keybase pgp decrypt)"
  provisioner "local-exec" {
    command = <<EOF
set -eu   # quit if I try to use an undefined variable, or after any exit-code-error command
curl --request PUT --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "https://gitlab.com/api/v4/projects/erosson%2Ferosson-org/variables/AWS_SECRET_ACCESS_KEY" --form "value=$(echo ${aws_iam_access_key.deploy.encrypted_secret} | base64 --decode | keybase pgp decrypt)"
curl --request PUT --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "https://gitlab.com/api/v4/projects/erosson%2Ferosson-org/variables/AWS_ACCESS_KEY_ID" --form "value=${aws_iam_access_key.deploy.id}"
curl --request PUT --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "https://gitlab.com/api/v4/projects/erosson%2Ferosson-org/variables/CLOUDFLARE_TOKEN" --form "value=$CLOUDFLARE_TOKEN"
curl --request PUT --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "https://gitlab.com/api/v4/projects/erosson%2Ferosson-org/variables/CLOUDFLARE_EMAIL" --form "value=$CLOUDFLARE_EMAIL"
curl --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "https://gitlab.com/api/v4/projects/erosson%2Ferosson-org/variables"
EOF
  }
}

resource "aws_iam_user_policy" "deploy" {
  name = "deploy@www.erosson.org"
  user = "${aws_iam_user.deploy.name}"

  # minimum-access s3 policy for the deploying user.
  # this helped, though CI might not use s3sync:
  # https://blog.willj.net/2014/04/18/aws-iam-policy-for-allowing-s3cmd-to-sync-to-an-s3-bucket/
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::www.erosson.org",
                "arn:aws:s3:::www.erosson.org/*",
                "arn:aws:s3:::www.erosson.com",
                "arn:aws:s3:::www.erosson.com/*",
                "arn:aws:s3:::erosson.org",
                "arn:aws:s3:::erosson.org/*",
                "arn:aws:s3:::erosson.com",
                "arn:aws:s3:::erosson.com/*",
                "arn:aws:s3:::piano.erosson.org",
                "arn:aws:s3:::piano.erosson.org/*"
            ]
        }
    ]
}
EOF
}
