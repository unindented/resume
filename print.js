const fs = require("fs");
const path = require("path");
const url = require("url");
const chromeLauncher = require("chrome-launcher");
const chromeRemoteInterface = require("chrome-remote-interface");

const startChrome = () => {
  const options = {
    chromeFlags: ["--disable-gpu", "--headless"]
  };
  return chromeLauncher.launch(options);
};

const printToPDF = async ({ port, source, target }) => {
  const options = { port };
  const client = await chromeRemoteInterface(options);

  const { Page } = client;

  try {
    await Page.enable();
    await Page.navigate({ url: source });
    await Page.loadEventFired();
    const { data } = await Page.printToPDF();
    fs.writeFileSync(target, Buffer.from(data, "base64"));
  } finally {
    await client.close();
  }
};

(async () => {
  const source = url.format({
    pathname: path.resolve(__dirname, process.argv[2]),
    protocol: "file:",
    slashes: true
  });
  const target = path.resolve(__dirname, process.argv[3]);

  let chrome;

  try {
    chrome = await startChrome();
    await printToPDF({ port: chrome.port, source, target });
  } catch (err) {
    console.error(err);
  } finally {
    await chrome.kill();
  }
})();
