/*
  桌面版下载页唯一的脚本，只做渐进增强（docs/rebuild.md 4.7）：版本、地址、大小、校验值都已在构建时写进页面，
  没有脚本时三个安装包并列显示，照样可以下载。

  按访问者的系统决定主按钮：适合这台电脑的版本留作主按钮，其余收进下面一行「其他安装包」。
  Mac 上的浏览器大多不透露芯片类型，只有 Chromium 系浏览器能通过 userAgentData 拿到 arm/x86；拿不到时两个 macOS 版
  都作为主按钮，由页面上的说明帮用户分辨。手机等判断不出系统时，三个都作为主按钮。iPad 的 Safari 会自称 Macintosh，
  用触点数排除。只剩一个主按钮时说明已经确定了版本，芯片的辨别说明不再需要。
*/
(function () {
  "use strict";

  function each(list, fn) {
    for (var i = 0; i < list.length; i++) fn(list[i]);
  }

  function feature(keys) {
    each(document.querySelectorAll("[data-chip-hint]"), function (hint) {
      hint.hidden = keys.length === 1;
    });
    each(document.querySelectorAll(".downloads [data-file]"), function (link) {
      link.hidden = keys.indexOf(link.getAttribute("data-file")) < 0;
    });
    each(document.querySelectorAll(".others [data-file]"), function (link) {
      link.hidden = keys.indexOf(link.getAttribute("data-file")) >= 0;
    });
    each(document.querySelectorAll(".others"), function (row) {
      row.hidden = false;
    });
  }

  var data = navigator.userAgentData;
  var platform = (data && data.platform) || navigator.platform || "";
  var agent = navigator.userAgent || "";
  if (/win/i.test(platform) || /Windows/.test(agent)) {
    feature(["windows-x64"]);
    return;
  }
  if (!(/mac/i.test(platform) || /Macintosh/.test(agent)) || navigator.maxTouchPoints > 1) return;
  var bothMacs = function () {
    feature(["macos-aarch64", "macos-x64"]);
  };
  if (!data || !data.getHighEntropyValues) {
    bothMacs();
    return;
  }
  data.getHighEntropyValues(["architecture"]).then(function (values) {
    if (values.architecture === "arm") {
      feature(["macos-aarch64"]);
    } else if (values.architecture === "x86") {
      feature(["macos-x64"]);
    } else {
      bothMacs();
    }
  }, bothMacs);
})();
