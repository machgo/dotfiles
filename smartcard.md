for vpn
install ccid and opensc
install libp11
sudo PKCS11_MODULE_PATH=/usr/lib/opensc-pkcs11.so openfortivpn xxx:443 --user-cert=pkcs11:serial=xxx;id=%0%06

for chrome
modutil -dbdir sql:$HOME/.pki/nssdb/ -add "CAC Module" -libfile /usr/lib/opensc-pkcs11.so
