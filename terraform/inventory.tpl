[constellation_servers]
${server_ip} ansible_user=root ansible_ssh_private_key_file=${ssh_private_key_file}

[constellation_servers:vars]
ansible_python_interpreter=/usr/bin/python3
github_username=${github_username}
github_token=${github_token}
domain_name=${domain_name}
domain_email=${domain_email}