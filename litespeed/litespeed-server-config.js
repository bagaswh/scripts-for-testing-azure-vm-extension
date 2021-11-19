const fs = require("fs");
const { LiteSpeedConf } = require("litespeed-conf");

const configFile = process.env.HTTPD_CONFIG_PATH;
const serverErrorLogFile = process.env.SERVER_ERROR_LOG_PATH;
const serverAccessLogFile = process.env.SERVER_ACCESS_LOG_PATH;
const vhostRoot = process.env.VHOST_ROOT;

const config = fs.readFileSync(configFile, { encoding: "utf-8" });

const litespeed = new LiteSpeedConf(config);

litespeed.conf.get("user").set("www-data");
litespeed.conf.get("group").set("www-data");

// ddos protection
const perClientConnLimitConf = litespeed.conf.get("perClientConnLimit");
perClientConnLimitConf.get("staticReqPerSec").set("250");
perClientConnLimitConf.get("dynReqPerSec").set("2");
perClientConnLimitConf.get("softLimit").set("75");
perClientConnLimitConf.get("hardLimit").set("100");
perClientConnLimitConf.get("gracePeriod").set("15");
perClientConnLimitConf.get("banPeriod").set("300");

perClientConnLimitConf.remove("blockBadReq");
perClientConnLimitConf.add("blockBadReq", "1");

// server-level logs
litespeed.conf.remove("errorlog");
litespeed.conf.add("errorlog", serverErrorLogFile, {
  logLevel: "ERROR",
  debugLevel: "0",
  rollingSize: "10M",
  keepDays: "30",
  compressArchive: "1",
  enableStderrLog: "1",
});
litespeed.conf.remove("accesslog");
litespeed.conf.add("accesslog", serverAccessLogFile, {
  rollingSize: "10M",
  keepDays: "30",
  compressArchive: "1",
});

// ext apps
const lsphp73 = litespeed.conf.get("extprocessor", "lsphp");
let extUser = lsphp73.get("extUser");
if (!extUser) {
  lsphp73.add("extUser", "");
  extUser = lsphp73.get("extUser");
}
extUser.set("www-data");

let extGroup = lsphp73.get("extGroup");
if (!extGroup) {
  lsphp73.add("extGroup", "");
  extGroup = lsphp73.get("extGroup");
}
extGroup.set("www-data");

litespeed.conf.remove("extprocessor", "lsphp74");
litespeed.conf.add("extprocessor", "lsphp74", {
  type: "lsapi",
  address: "uds://tmp/lshttpd/lsphp.sock",
  maxConns: "10",
  env: "PHP_LSAPI_CHILDREN=10",
  env: "LSAPI_AVOID_FORK=200M",
  initTimeout: "60",
  retryTimeout: "0",
  persistConn: "1",
  respBuffer: "0",
  autoStart: "2",
  path: "lsphp74/bin/lsphp",
  backlog: "100",
  instances: "1",
  extUser: "www-data",
  extGroup: "www-data",
  priority: "0",
  memSoftLimit: "2047M",
  memHardLimit: "2047M",
  procSoftLimit: "1400",
  procHardLimit: "1500",
});

litespeed.conf.remove("extprocessor", "lsphp80");
litespeed.conf.add("extprocessor", "lsphp80", {
  type: "lsapi",
  address: "uds://tmp/lshttpd/lsphp.sock",
  maxConns: "10",
  env: "PHP_LSAPI_CHILDREN=10",
  env: "LSAPI_AVOID_FORK=200M",
  initTimeout: "60",
  retryTimeout: "0",
  persistConn: "1",
  respBuffer: "0",
  autoStart: "2",
  path: "lsphp80/bin/lsphp",
  backlog: "100",
  instances: "1",
  extUser: "www-data",
  extGroup: "www-data",
  priority: "0",
  memSoftLimit: "2047M",
  memHardLimit: "2047M",
  procSoftLimit: "1400",
  procHardLimit: "1500",
});

// default vhost
litespeed.conf.remove("virtualhost", "main");
litespeed.conf.add("virtualhost", "main", {
  vhRoot: vhostRoot,
  configFile: "$SERVER_ROOT/conf/vhosts/$VH_NAME/vhconf.conf",
  allowSymbolLink: "1",
  enableScript: "1",
  restrained: "1",
  setUIDMode: "2",
  user: "www-data",
  group: "www-data",
});

// set listener port and map to vhost
litespeed.conf.remove("listener", "HTTP");
litespeed.conf.add("listener", "HTTP", {
  address: "*:80",
  secure: 0,
});

litespeed.conf.remove("listener", "HTTPS");
litespeed.conf.add("listener", "HTTPS", {
  address: "*:443",
  secure: 1,
  map: "main *",
});

fs.writeFileSync(configFile, litespeed.toString(), "utf-8");
