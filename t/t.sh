#only for Ubuntu 19.10 on vultr
# 10s
#!/bin/bash

install_trojan(){
	apt update
	add-apt-repository ppa:greaterfire/trojan -y
	apt update
	rm -f /etc/trojan/config.json
	apt install trojan -y
}



obtain_ipv4(){

	ip=$(curl -4sLk https://ip.me)

}


get_ssl(){

	bash <(curl -sLk https://scaleya.com/v2ray.sh)

	obtain_ipv4

	rm -f /etc/trojan/*.pem

	/usr/bin/v2ray/v2ctl cert --ca --domain=${ip} --expire=1000000h --name="Scaleya Inc" --org="Scaleya Inc" --json --file=/etc/trojan/scaleya
}




config_trojan(){

	cat > /etc/trojan/config.json <<-EOF
{
  "run_type": "server",
  "local_addr": "::",
  "local_port": 443,
  "remote_addr": "127.0.0.1",
  "remote_port": 80,
  "password": [
    "scaleya"
  ],
  "log_level": 1,
  "ssl": {
    "cert": "/etc/trojan/scaleya_cert.pem",
    "key": "/etc/trojan/scaleya_key.pem",
    "key_password": "",
    "cipher": "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256",
    "prefer_server_cipher": true,
    "alpn": [
      "http/1.1"
    ],
    "reuse_session": true,
    "session_ticket": false,
    "session_timeout": 600,
    "plain_http_response": "",
    "curves": "",
    "dhparam": ""
  },
  "tcp": {
    "prefer_ipv4": false,
    "no_delay": true,
    "keep_alive": true,
    "fast_open": false,
    "fast_open_qlen": 20
  },
  "mysql": {
    "enabled": false,
    "server_addr": "127.0.0.1",
    "server_port": 3306,
    "database": "trojan",
    "username": "trojan",
    "password": ""
  }
}
EOF

}



install_trojan
get_ssl
config_trojan
systemctl enable trojan
systemctl stop trojan
systemctl restart trojan
systemctl status trojan
