# You need to:
# (i)   Create a policy document
# (ii)  Create a policy
# (iii) Create a role
# (iv)  Create an attachment between the policy and the role 

# Defining the json files containing policy rules: 
data "aws_iam_policy_document" "instance_redshift_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["redshift.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "allow_access_to_s3_from_redshift_document" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
    resources = [
        aws_s3_bucket.etude_credit_contracts_s3.arn,
        "${aws_s3_bucket.etude_credit_contracts_s3.arn}/*", 
    ]
  }
}

# Defining aws role and policy to be attached to redshift service:
resource "aws_iam_role" "allow_access_to_s3_from_redshift_role" {
  name = "allow_access_to_s3_from_redshift"
  assume_role_policy = data.aws_iam_policy_document.instance_redshift_assume_role.json
}

resource "aws_iam_policy" "allow_access_to_s3_from_redshift_policy" {
  name = "allow_acess_to_s3_from_redshift_policy"
  description = "This policy enables ours redshift instance to at least read the files contained in ours s3 instance."
  policy = data.aws_iam_policy_document.allow_access_to_s3_from_redshift_document.json
}

# Create an attachment between the role and the policy
resource "aws_iam_role_policy_attachment" "attach_redshift_access_to_s3" {
  role = aws_iam_role.allow_access_to_s3_from_redshift_role.name
  policy_arn = aws_iam_policy.allow_access_to_s3_from_redshift_policy.arn
}