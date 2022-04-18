cd
mkdir vv
cd vv
if [[ "$(uname -m)" == 'aarch64' ]]; then curl -Lo tmp.zip https://github.com/v2fly/v2ray-core/releases/download/v4.44.0/v2ray-linux-arm64-v8a.zip ; else curl -Lo tmp.zip https://github.com/v2fly/v2ray-core/releases/download/v4.44.0/v2ray-linux-64.zip ; fi
unzip tmp.zip
rm -f tmp.zip
echo '
cd "$HOME/vv"
pkill v2ray
rm -f stdout.log
nohup ./v2ray > stdout.log 2>&1 &
' > start.sh
chmod +x start.sh
printf '
{
  "inbounds": [
    {
      "port": 80,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "%s"          }
        ]
      },
      "streamSettings": {
        "network": "ws"
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {"domainStrategy": "UseIP"}
    }
  ],
 "dns": {
   "servers": [
     "https+local://[2606:4700:4700::1111]/dns-query",
     "https+local://1.1.1.1/dns-query"
   ]
 }
}
' `./v2ctl uuid`> config.json
cd
cat vv/config.json
vv/start.sh
