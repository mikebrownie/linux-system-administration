# Deployments for Machine A-D and F (e is manual)
scp -r iptables-scripts root@100.64.2.1:/root
scp -r iptables-scripts root@100.64.2.2:/root
scp -r iptables-scripts root@100.64.2.3:/root
scp -r iptables-scripts root@100.64.2.4:/root
# scp -r iptables-scripts root@100.64.2.5:/root

# Run machine specific script
ssh root@100.64.2.1 'bash iptables-scripts/a.sh; bash iptables-scripts/a_mirror.sh'
ssh root@100.64.2.2 bash iptables-scripts/bf.sh
ssh root@100.64.2.3 bash iptables-scripts/c.sh
ssh root@100.64.2.4 bash iptables-scripts/d.sh
# ssh root@100.64.2.5 bash iptables-scripts/bf.sh
