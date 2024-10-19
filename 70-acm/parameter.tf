resource "aws_ssm_parameter" "web_acm" {
    name = "/${var.project_name}/${var.environment_name}/web_acm"
    type = "String"
    value = aws_acm_certificate.expense.arn
}