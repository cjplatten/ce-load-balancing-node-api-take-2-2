#     Have a protocol of HTTP √
#     Have the port as 3000 √
#     Have the protocol version as HTTP1 √
#     Have health check set up with a path of /health-check and a protocol of HTTP √


resource "aws_lb_target_group" "lb-tg" {
  name             = "load-balancing-lb-tg"
  port             = 3000
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  vpc_id           = var.vpc_id

  health_check {
    path     = "/health-check"
    protocol = "HTTP"
  }
}

# Once you have created the target group, your next step is to register those instances with your target group using the aws_lb_target_group_attachment.
# Use the instances you created within your app_servers module and attach them to the target group.

resource "aws_lb_target_group_attachment" "lb-tg-a" {
  
  count = length(var.target_ids)
  
  target_group_arn = aws_lb_target_group.lb-tg.arn
  target_id = var.target_ids[count.index]
}