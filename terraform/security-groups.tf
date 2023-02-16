resource "aws_security_group" "etude_credit_contracts_securitygroup" {
    provider = aws.us-east-1
    name = "etude_credit_contracts_security_group"
    egress {
        from_port = 5439
        to_port = 5439
        protocol = 0
        cidr_blocks = var.ips
    }
} 