```bash
# 卸载
virsh net-destroy default
virsh net-undefine default
```

```bash
# 配置
mkdir -p /var/lib/libvirt/network
cat <<EOF > /var/lib/libvirt/network/default.xml
<network>
  <name>default</name>
  <forward mode='nat'/>
  <bridge name='virbr0' stp='on' delay='0' />
  <ip address='192.168.122.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.122.2' end='192.168.122.254' />
    </dhcp>
  </ip>
</network>
EOF

virsh net-define /var/lib/libvirt/network/default.xml
virsh net-start default
virsh net-autostart default
```