const fs = require("fs");
const { LiteSpeedConf } = require("litespeed-conf");

const configFile = process.env.VHOST_CONFIG_PATH;
const docRoot = process.env.DOC_ROOT;
const vhostErrorLogFile = process.env.VHOST_ERROR_LOG_PATH;
const vhostAccessLogFile = process.env.VHOST_ACCESS_LOG_PATH;

const fileStat = fs.statSync(configFile);

const config = fs.readFileSync(configFile, { encoding: "utf-8" });

const litespeed = new LiteSpeedConf(config);

litespeed.conf.get("docRoot").set(docRoot);
litespeed.conf.remove("phpIniOverride");
litespeed.conf.add("phpIniOverride", "", {
  php_value: "upload_max_filesize 20M",
  memory_limit: "200M",
});

litespeed.conf.add("context", "exp:/.git/", {
  allowBrowse: 0,

  rewrite: {},
  addDefaultCharset: "off",

  phpIniOverride: {},
});

// vhost-level logs
litespeed.conf.remove("errorlog");
litespeed.conf.add("errorlog", vhostErrorLogFile, {
  logLevel: "ERROR",
  debugLevel: "0",
  rollingSize: "10M",
  keepDays: "30",
  compressArchive: "1",
  enableStderrLog: "1",
});
litespeed.conf.remove("accesslog");
litespeed.conf.add("accesslog", vhostAccessLogFile, {
  rollingSize: "10M",
  keepDays: "30",
  compressArchive: "1",
});

// block sensitive files
litespeed.conf.remove(
  "context",
  "exp:(composer.*.json|lock)|.gitignore|package.*.json|.env|.zip|.txt|.rst"
);
litespeed.conf.add(
  "context",
  "exp:(composer.*.json|lock)|.gitignore|package.*.json|.env|.zip|.txt|.rst",
  {
    allowBrowse: "0",
    rewrite: {},
    addDefaultCharset: "off",
    phpIniOverride: {},
  }
);

litespeed.conf.remove("context", "exp:/.git/|/logs?/");
litespeed.conf.add("context", "exp:/.git/|/logs?/", {
  allowBrowse: "0",
  rewrite: {},
  addDefaultCharset: "off",
  phpIniOverride: {},
});

fs.writeFileSync(configFile, litespeed.toString(), "utf-8");
