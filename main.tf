locals {
  name_security_group = "${var.name}-sg"
}

######
# SECURITY GROUP
######
# security group
resource "aws_security_group" "role" {
  name        = local.name_security_group
  description = "Access rules for ${var.name}"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      "Name" = format("%s-sg", var.name)
    },
  )
}

# security group rule inbound
resource "aws_security_group_rule" "inbound" {
  count             = length(var.sg_inbound)
  type              = "ingress"
  description       = lookup(var.sg_inbound[count.index], "description", "")
  from_port         = var.sg_inbound[count.index]["start"]
  to_port           = var.sg_inbound[count.index]["end"]
  protocol          = lookup(var.sg_inbound[count.index], "proto", "tcp")
  security_group_id = aws_security_group.role.id
  cidr_blocks       = split(",", var.sg_inbound[count.index]["sources"])
}

# security group rule inbound with self-referencing
resource "aws_security_group_rule" "inbound_with_self" {
  count             = length(var.sg_inbound_self)
  self              = true
  type              = "ingress"
  description       = lookup(var.sg_inbound_self[count.index], "description", "")
  from_port         = var.sg_inbound_self[count.index]["start"]
  to_port           = var.sg_inbound_self[count.index]["end"]
  protocol          = lookup(var.sg_inbound_self[count.index], "proto", "tcp")
  security_group_id = aws_security_group.role.id
}

# security group rule outbound
resource "aws_security_group_rule" "outbound" {
  count             = length(var.sg_outbound)
  type              = "egress"
  description       = lookup(var.sg_outbound[count.index], "description", "")
  from_port         = var.sg_outbound[count.index]["start"]
  to_port           = var.sg_outbound[count.index]["end"]
  protocol          = lookup(var.sg_outbound[count.index], "proto", "tcp")
  security_group_id = aws_security_group.role.id
  cidr_blocks       = split(",", var.sg_outbound[count.index]["dests"])
}
