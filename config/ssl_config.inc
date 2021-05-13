  # SSL config
  ssl_protocols             TLSv1.2;
  ssl_prefer_server_ciphers on;
  ssl_ciphers               "EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM EECDH+ECDSA+SHA384 EECDH+ECDSA+SHA256 EECDH+aRSA+SHA384 EECDH+aRSA+SHA256 EECDH+aRSA+RC4 EECDH EDH+aRSA HIGH !RC4 !aNULL !eNULL !LOW !3DES !MD5 !EXP !PSK !SRP !DSS";
  ssl_buffer_size           8k;
  ssl_session_cache         shared:SSL:50m;
  ssl_session_timeout       1d;
  ssl_session_tickets       off;
