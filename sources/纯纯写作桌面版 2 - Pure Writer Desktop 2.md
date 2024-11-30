### 纯纯写作桌面版 2

| [English · Pure Writer Desktop 2](/desktop2_en)

![Preview](/images/desktop2dark.png)

##### 旧版纯纯写作桌面版 v1.9.0（旧版，但稳定，需与手机实时连接）：https://writer.drakeet.com/desktop

> v1.9.0 为非全新版本，但毫无问题，以下的 **2.0 版本**为测试版，**半成品**

#### v2.2.x Beta 版（全新桌面版）

> 终于，再一次，很高兴见到你。
>
> 呈现在您眼前的正是全新的纯纯写作桌面版。
>
> 全新的纯纯写作桌面版是一个巨大工程量的产品，至少需要五年以上的时间才能完成，如今发布的本客户端实际上是一个半成品。目前许多功能和 UI 都还未实现或处于初始态，大量的细节缺乏打磨和调整……
>
> 由于许多用户热切希望尽快见到它，所以即使距离真正成熟的版本还很远，但我们决定发布它了，或许这是一个不错的开端，它已经比 2017 年初次发布的纯纯写作 Android 版来得新进和丰富了，而且已经**支持云同步**了，不必要和手机实时连接。
>
> 前路漫漫，**百废待兴**，艰难且漫长，但我们没有放弃，马不停蹄，相信我们终有一天能抵达那个令人满意且最超前的里程碑。在此之前，全新的纯纯写作桌面端将长久保持完全免费（因此目前它不需要登录纯纯写作 Pro 账号，数据则通过云备份网盘同步）。
>
> 希望您能为一些细节感到欣喜，同时**给予我们一些理解和更多等待时间**，将不胜感激，不懈努力。
>
> 当前版本可能会有许多不足和问题，请多担待！
> 
> 最后，为了避免一些二道打包贩子在安装包里插入风险代码，请确保您从 https://writer.drakeet.com/desktop2 下载和更新本软件。**目前它是完全免费的，也无需破解版，请勿轻信任何破解版。**
> 
> 更多关于这个桌面版的**开发故事**请见：
>
> https://mp.weixin.qq.com/s/j-nxQIUI2rdOA52H-otoUQ



> 如果您是 Windows 系统用户，请下载安装 PureWriter2-Windows-x64.exe，**目前暂时仅支持 Windows 10/11**
>
> macOS 则使用 PureWriter2-macOS.dmg，下载后**右键点击该文件选择“打开”**即可进行安装。
>
> ⚠️ Windows 系统可能遇到杀毒软件误报，请放心并将桌面版安装包及安装好的文件（`C:\Program Files\Pure Writer 2`）加入白名单即可。我们是实名注册的开发者和公司，不可能做病毒软件的，那样不仅身败名裂而且要进监狱、破产。Windows 上的杀毒软件可能对于没有签名的 exe 默认报毒，我们后续将解决此问题。另外，若遇到打不开的情况，请对本软件关闭 Windows 的「勒索软件防护」，有用户反馈这会导致桌面版无法访问文件系统，遇到此情况请试试！



#### 下载

[PureWriter2-2.2.10-Windows-x64.exe](https://kuromi2.oss-cn-shanghai.aliyuncs.com/PureWriter2-2.2.12-Windows-x64.exe)  Windows 版，如果您之前安装过 v2.1.9 版本，请见下面的《关于 Windows v2.1.9 版本的注意事项》

[PureWriter2-2.2.10-macOS-aarch64.dmg](https://kuromi2.oss-cn-shanghai.aliyuncs.com/PureWriter2-2.2.12-macOS-aarch64.dmg)  用于苹果 **M 系列芯片** / **Apple M Silicon**

[PureWriter2-2.2.10-macOS-intel.dmg](https://kuromi2.oss-cn-shanghai.aliyuncs.com/PureWriter2-2.2.12-macOS-x64.dmg)  用于 **Intel** 芯片

⚠️ 若更新，请**关闭本软件后再安装更新**，这样可以避免「*需要重启*」问题。

⚠️ 请注意，OneDrive 和「阿里云盘」都不是坚果云。目前**必须在纯纯写作 Android 端切换到与桌面端同一个云备份/云同步网盘方可相互同步：**

<img src="/images/DriveOnAndroidGuide.jpg" width=480 align="left"/>

（因为云盘只是一个单向备份的载体，或者云同步的中转，所以**没必要迁移云盘数据，直接切换即可**）



⚠️ **关于 Windows v2.1.9 版本的注意事项：**

在安装 v2.2 版本之前，**请先卸载 v2.1.9 版本！**

卸载方式：右键点击「开始」，选择「安装的应用」或「程序与功能」，然后在软件列表中找到「Pure Writer 2」v2.1.9 版本，点击「...」、「卸载」🙏



v2.2.7 版本要点如下：

```
* 修复 云同步有时未能将最后一次修改内容同步到云端，请同时将 Android 版更新到 v25.7.0：
https://www.coolapk.com/apk/148884

* 避免 SQLiteException: [SQLITE_CORRUPT] 问题
* 支持 恢复文章滚动停留位置
* 支持 锁屏，可以在设置中开启，锁屏后需要输入密码解锁，目前默认启动时自动加锁，以及 5 分钟没有动作自动加锁
* 改进 文章和书籍搜索（按 ESC 可快速打开搜索）时的「上下键导航」，按上下键时焦点移动到匹配关键字的下一个或上一个项目
* 支持 韩语，如果您需要韩语，需要卸载重装：https://writer.drakeet.com/desktop2
* 修复 Ctrl + F 或 Command + F 查找文字时，如果改动会自动跳到下一个结果，这是不符合预期的行为
* 支持 Windows 系统自定义的「文档」位置，如果存在旧的 Documents 文件夹和自定义的「文档」，将自动迁移
* 支持 鼠标中键点击 tab 关闭 tab
* 提供 一种没有打扰的「通知」替代「错误弹窗」以及许多细节优化
* 更多字体、更多语言
* 支持 更多系统字体，请先在系统中安装：Klee One Regular，LXGW Bright GB Regular，LXGW WenKai GB，LXGW WenKai TC Regular，Xiaolai SC
* 支持 同步手机上的字数统计模式
* 优化 同名文章显示书名

顺便推荐一下我们的暗色主题，目前白色主题还缺乏视觉良好性打磨，请优先试试我们的暗色主题！
```

……

更多内容请自行探索，许多功能和文案目前不够得体，请多担待。如有难以忍受的问题，请致信，我们将竭力为您服务：writer@drakeet.com



#### 发布日期

v2.0.0 测试版发布于 2024.06.20 16:43, 周四, 2024 夏至前日

















<img src="https://img.alicdn.com/tfs/TB1..50QpXXXXX7XpXXXXXXXXXX-40-40.png" width=22 /> [闽ICP备2021006387号-1](https://beian.miit.gov.cn/)
