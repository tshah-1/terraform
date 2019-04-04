resource "aws_instance" "ops_monitoring" {

  ami                             = "ami-0a5f61c2d8cfc4bad"
  key_name                        = "${var.keys["${terraform.workspace}"]}"
  instance_type                   = "t2.xlarge"
  vpc_security_group_ids          = ["${aws_security_group.ops_monitoring.id}", "${aws_security_group.ops_monitoring_snmp_icmp}"]
  subnet_id                       = "${aws_subnet.public_subnet_a.id}"
  count                           = "${var.num_instances_cms}"

  # this inline shell script also works!
  provisioner "remote-exec" {
    inline = [
      "echo '127.0.0.1	${self.tags.Name}' | sudo tee -a /etc/hosts",
      "sudo hostnamectl set-hostname ${self.tags.Name}",
    ]
  }

  # adding the public keys
  provisioner "remote-exec" {
    inline = [
      # GH
      "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQB5EcLwmGvrbUfrSf++fWvYsHpTnQmaqrD0SYEsUGIkawXLILqkeTiV+ufV1yegg2qLBKPduQkx0WHFimOhRA8vU1EkuAP8vuXkgsgQyrQHVC1kwbZqgtJDIuh6gN7tmg7QXgh+MMf+Xi7QVMhYg7hKx+7mbDBfEAnpTEhYXSpkDGWDbkmM8pG9IE8CEjpt28JiFhvNsx4AnqjkEPiKmUe9PMrWuOPMV9JA0mpaWx/ppv+MsxIZ4LjtfN2oeXdm3h9Ktzp11FWDaudQCJim18bOiYSyTfpsM4iJ+YpEaNJksihkvwyb+NAlyt6mXcSfYUXXcE1n4zYRk/im9VrVLJOR gh.rb-key' | sudo tee -a /root/.ssh/authorized_keys",
      # BD
      "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQB7uxztn6jaAmIEYdR9klVuWxzIlEsXUHoVhD2qak9cCM87YgmgSJZpi55WzvLpeFZew9BSK1NnkCm1BXvB4pQ1H/n2VwfEIcaKakgmUpP5vKT1ANZJJyDOJooAZkqXk7h3tbWN7hviJ1EXrKCn+VFwk3/WetqJmm7dXQkPCw++7tbA6Hc9UkadzOoi9Rtz6GlTJy8pEwlAeOs+zCmlh8SqKuNqjk9OoSGEs3kjX3QcfZtD4PJx3kE/K+5tuasstwZVBakwIp4xEsIWwojtfPnqkWj/lJUfEUkM+OZ/+PjekVPUXuNw94woHESCHtr+jzCMGGbVnT5zUoQImO16XgLJ bd.rb-key' | sudo tee -a /root/.ssh/authorized_keys",
      # VH
      "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5HvQuhcYIgYV5GT/y/w0PfUC1GqPgymhUSnvjD80Ghl1MeMX87TCxiP9FxBrOiubBVzJD39W+kF3PgNMEbaZ8u9sKJmSO7AFxdl8Nr+q9/PNvZsNY3rqBtPsrUAbc9LMtO0Wwmkm81U+YcU29m8BiXM6IyZujV0t19HupeJLzE8eu8kz7tFiGHzGqFLemokn0VQyNTSL/S7Mub0eeEoWv++lmLka1cFPsqJSKfLsWFd7ytgA4c40QCInFm4rxhMpKo+KGOQRbvSXyP42r47bN0CV8I1giIpN0nbwqG5oMuR/Fbzn40LGTMMJROkfXPtbC/kXoAfmQsbLItpItABjr vh.rb-key' | sudo tee -a /root/.ssh/authorized_keys",
      # BB
      "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDSclFuMRZ0cIj6f+h6iCYrmFsiDw65LdsoxoMYCJIH5dArLWUv9YxJ9lcxwzyXVfWiFC5di5HyMnhkLLlcegtmAtSZLZtVi8RBoAYHudRGDnWlZln0LJspjAnd4yOumDxaohFQaKgcFejZdruWqB5knnT6Qj7fPDPJcqe0rdSXP3+G8eXO0cqSC18ZR8jCeF/n+cfKTLu1t3+mM4HrJiMExDPFSVYx4HAF23tMk5ARHqFRdDDurkajq/OUFUNV9ggIjwGAWbAZWs11d3gUkIiZ0+3zS5cRIOv+BaXZWidcUA92nlK3L0a7x35/CV1uihxAfGvy+AXOazONMtWN34AZ bb.rb-key' | sudo tee -a /root/.ssh/authorized_keys",
      # CM
      "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDZpkBVZHC76lvkPS4QcHmaHQPQPerWVm+eIy0LWJ+LvjOMz8BGSbWYBoEFFugAygx+qYb9OKszEoqCIiq9l0Gmmn2WvFYoWLkPHs4NOVFk2A6RsdFfqaqnjUFk85J1huJJrwdTiGMV2ApmJJ3SRg7VA7Nv8Yo8cbArPYYOm8nIEAVcM7PI6RGmIG/Gk2T689W3L5XsAssXd4yj7tQAoIY9Y6Sum7eSGfvyM6lvZ7fLVecD9AhE3tAeXj6p2bePmcFRqpJYKZkfyedsLRfX2LKS5Kqe5x/35Njpi1gwrdRQZRejTg64bWympJzNFQC9DtGzHJorg3s+VwinyNcevcNT cm.rb-key' | sudo tee -a /root/.ssh/authorized_keys",
      # HS
      "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAvjYnMuSc92l2oIuvxNotfT6Vg4N1hEHXaEc6kmCgR83V6ZamhWmBtGtM3g/ze4yMn+GjowlI6jKPBj3JiA2Nf4OTvQ1XIxFbgZHEm4v+Js6So0X78kjKIy4cz5p8sosk0wntRRxCTxC4XE1b6ghzPXQLBzUGaLv3cBI5VdyQlpRVtSdmoPmyxxAyCeXjZiI300JB6y9mPuko1Aw2Drn64OCZ9lPC42tvJ23luir03uoUO8NKQ7MXUHKzMvUQrQy0xKS/YsI54eGb7PvlMljkxwTrC/aHncwAJFzzDD1+vN8ipT6KwsWG9FAWnbekRGRqt3fTDlYNDWjRxtmrrpWzQQ== hs.rb-key' | sudo tee -a /root/.ssh/authorized_keys",
    ]
  }

  tags {
    Name                          = "${format("csportal-mon%02d",count.index+1)}"
  }
}

resource "aws_route53_record" "csportal-mon" {
  // same number of records as instances
  count                           = "${var.num_instances_cms}"
  zone_id                         = "${aws_route53_zone.sportal.zone_id}"
  name                            = "${format("csportal-mon%02d",count.index+1)}"
  type                            = "A"
  ttl                             = "300"

  records                         = ["${element(aws_instance.ops_monitoring.*.private_ip, count.index)}"]
}

resource "aws_eip" "ops_monitoring_ip" {
  instance                        = "${aws_instance.ops_monitoring.id}"
}
