########################################
# Existing Hosted Zone
########################################

data "aws_route53_zone" "main" {
  name         = "projectlearning.click"
  private_zone = false
}

########################################
# Root Domain Record
########################################

resource "aws_route53_record" "root" {

  zone_id = data.aws_route53_zone.main.zone_id

  name = "projectlearning.click"
  type = "A"

  alias {
    name                   = aws_lb.student_alb.dns_name
    zone_id                = aws_lb.student_alb.zone_id
    evaluate_target_health = true
  }
}

########################################
# WWW Record
########################################

resource "aws_route53_record" "www" {

  zone_id = data.aws_route53_zone.main.zone_id

  name = "www.projectlearning.click"
  type = "A"

  alias {
    name                   = aws_lb.student_alb.dns_name
    zone_id                = aws_lb.student_alb.zone_id
    evaluate_target_health = true
  }
}