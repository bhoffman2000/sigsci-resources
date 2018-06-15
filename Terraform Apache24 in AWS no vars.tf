  This is an example terraform provision statement for adding our agent and module to a container with Apache 2.4 in AWS

  # Include this provisioner on the apache web server in AWS
  # Assumes AWS base linux with Apache 2.4 already installed
  # Please make sure to add agent secret and access keys for the site
  provisioner "remote-exec" {
    inline = [
      "sudo tee /etc/yum.repos.d/sigsci.repo <<-'EOF'
      [sigsci_release]
       name=sigsci_release
       baseurl=https://yum.signalsciences.net/release/el/6/$basearch
       repo_gpgcheck=1
       gpgcheck=0
       enabled=1
       gpgkey=https://yum.signalsciences.net/gpg.key
       sslverify=1
       sslcacert=/etc/pki/tls/certs/ca-bundle.crt
       EOF"
      "sudo yum install sig-sci agent"
      "sudo tee /etc/sigsci/agent.conf <<- 'EOF'
       accesskeyid = "ACCESSKEYHERE"
       secretaccesskey = "SECRETKEYHERE"
       EOF",
      "start sigsci-agent"
      "sudo yum install sigsci-module-apache24",
      "LoadModule signalsciences_module /etc/httpd/modules/mod_signalsciences.so"
      "sudo service httpd restart",
    ]
  }

 