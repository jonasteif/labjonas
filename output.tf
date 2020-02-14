output "lb_address" {
  description = "The DNS name of the load balancer."
  value       = "${aws_lb.labjonas.dns_name}"
}