variable "ips" {
    type = list(string)
    default = ["179.209.142.66/32"]
}

variable "redshift_args" {
    type = map(string)
    default = {
        "cluster_identifier" = "redshift-credit-contracts-etude"
        "database_name" = "credit_contracts"
        "master_username" = "creditcontractsuser"
        "master_password" = "P4ssCr3d1tc0ntr4ct"
        "node_type" = "dc2.large"
        "cluster_type" = "single-node"
    }
}
