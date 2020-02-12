/*# IAM Role for Lambda function
resource "aws_iam_role" "lambda_api_role" {
  name               = "lambda_api_role"
  assume_role_policy = "${file("../../common/policies/lambda-role.json")}"
}

resource "aws_iam_role_policy_attachment" "vpc-exec-role" {
  role       = "${aws_iam_role.lambda_api_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "cloudwatch-log" {
  role       = "${aws_iam_role.lambda_api_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy_attachment" "dynamodb" {
  role       = "${aws_iam_role.lambda_api_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaDynamoDBExecutionRole"
}

resource "aws_iam_role_policy_attachment" "enimanagement" {
  role       = "${aws_iam_role.lambda_api_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaENIManagementAccess"
}
resource "aws_iam_role_policy_attachment" "s3" {
  role       = "${aws_iam_role.lambda_api_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

*/