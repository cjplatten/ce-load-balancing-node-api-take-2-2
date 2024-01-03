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
# Use the instances you created within your app_servers module and attach them to the target group √

resource "aws_lb_target_group_attachment" "lb-tg-a" {

  count = length(var.target_ids)

  target_group_arn = aws_lb_target_group.lb-tg.arn
  target_id        = var.target_ids[count.index]
}

# Your load balancer should have the following properties:

#     Be internet-facing, not internal √
#     Of type application for the load_balancer_type √
#     Reside in the public subnets created within the networking module √
#     Use the security group created within the security module √


resource "aws_lb" "lb" {
  name               = "load-balancing-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [var.security_group_id]
}


# The listener should be set up with the following properties:

#     Use HTTP √
#     Use port 80 √
#     Use Forward action as the default action, and the target should be the previously created target group √
#     No SSL policy or certificates because it doesn't use HTTPS √

resource "aws_lb_listener" "lb-listener" {
    port = 80
    protocol = "HTTP"
    load_balancer_arn = aws_lb.lb.arn

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.lb-tg.arn
    }
}
