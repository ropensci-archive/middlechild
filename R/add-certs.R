# Making it easier to get the mitmproxy cert into the OS and ffox

# https://sdqali.in/blog/2012/06/05/managing-security-certificates-from-the-console---on-windows-mac-os-x-and-linux/
  
# macOS
# security find-certificate -c "mitmproxy"
# sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain <certificate>


# windows
# certutil.exe -importpfx Root mitmproxy-ca-cert.p12

# linux
# sudo mkdir /usr/share/ca-certificates/extra
# sudo cp foo.crt /usr/share/ca-certificates/extra/foo.crt
# sudo dpkg-reconfigure ca-certificates
# openssl x509 -in foo.pem -inform PEM -out foo.crt


# Firefox linux
## certificateFile="MyCa.cert.pem"
## certificateName="MyCA Name" 
## for certDB in $(find  ~/.mozilla* ~/.thunderbird -name "cert9.db")
## do
##   certDir=$(dirname ${certDB});
##   #log "mozilla certificate" "install '${certificateName}' in ${certDir}"
##   certutil -A -n "${certificateName}" -t "TCu,Cuw,Tuw" -i ${certificateFile} -d sql:${certDir}
## done
