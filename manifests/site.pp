# /etc/puppet/manifests/site.pp
import "openvas/*"
node default {
    include openvas
}
