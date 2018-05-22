# macOS network setup ref

# networksetup -getftpproxy <networkservice>
# networksetup -setftpproxy <networkservice> <domain> <port number> <authenticated> <username> <password>
# networksetup -setftpproxystate <networkservice> <on off>
# networksetup -getwebproxy <networkservice>
# networksetup -setwebproxy <networkservice> <domain> <port number> <authenticated> <username> <password>
# networksetup -setwebproxystate <networkservice> <on off>
# networksetup -getsecurewebproxy <networkservice>
# networksetup -setsecurewebproxy <networkservice> <domain> <port number> <authenticated> <username> <password>
# networksetup -setsecurewebproxystate <networkservice> <on off>
# networksetup -getstreamingproxy <networkservice>
# networksetup -setstreamingproxy <networkservice> <domain> <port number> <authenticated> <username> <password>
# networksetup -setstreamingproxystate <networkservice> <on off>
# networksetup -getgopherproxy <networkservice>
# networksetup -setgopherproxy <networkservice> <domain> <port number> <authenticated> <username> <password>
# networksetup -setgopherproxystate <networkservice> <on off>
# networksetup -getsocksfirewallproxy <networkservice>
# networksetup -setsocksfirewallproxy <networkservice> <domain> <port number> <authenticated> <username> <password>
# networksetup -setsocksfirewallproxystate <networkservice> <on off>
# networksetup -getproxybypassdomains <networkservice>
# networksetup -setproxybypassdomains <networkservice> <domain1> [domain2] [...]
# networksetup -getproxyautodiscovery <networkservice>
# networksetup -setproxyautodiscovery <networkservice> <on off>