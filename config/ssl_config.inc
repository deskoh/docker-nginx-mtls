  # SSL config
  ssl_protocols             TLSv1.2;
  ssl_prefer_server_ciphers on;
  ssl_ciphers               "EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM EECDH+ECDSA+SHA384 EECDH+ECDSA+SHA256 EECDH+aRSA+SHA384 EECDH+aRSA+SHA256 EECDH+aRSA+RC4 EECDH EDH+aRSA HIGH !RC4 !aNULL !eNULL !LOW !3DES !MD5 !EXP !PSK !SRP !DSS";
  # 1-MB shared cache can hold approximately 4,000 sessions
  ssl_session_cache         shared:SSL:20m;
  ssl_session_timeout       4h;
  ssl_session_tickets       off;
