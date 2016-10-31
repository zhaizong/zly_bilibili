# ZLY_bilibiliDemo
仿bilibili(iOS客户端), 刚开始还缺少很多功能。

##目前完成如下功能
- 启动页逻辑

##正在制作的功能
- 首页

##概述
ZLY_bilibiliDemo的iOS工程

##Build
iOS的主工程为MybilibiliDemo

##BiliBiliKit
>项目中UI中的公用部分，作为一个Framework被主工程及Submodules引用

- 引用方式：#import `<BiliBiliKit/BiliBiliKit.h>`
- 包括公用的ViewController、View(自定义View及Cell等)、Commons、Utils、公用的第三方库等

###构建过程
1.创建Cocoa Touch Framework工程  
2.修改Development target不能高于主工程  
3.工程结构可自行设计  
4.保持umbrella文件(`$FramewotkName$.h`)可访问性为public  
5.由于Swift的Framework工程不允许`Bridging-Header.h`文件，所以用到的Object-C头文件的写在umbrella文件中  
6.类和变量的访问性(`public/internal/private`)要求注清楚

##结构设计
>MVC模式设计

- Classes : ViewControllers
- View : Storyboards
- Resources : 国际化文件以及一些资源文件
- Vendor : 第三方库
- BiliBiliKit : 项目中公共的UI库
- bilibilicore : 核心库(暂无)
- Modules : 功能模块(暂无)

##第三方库(FRAMEWORK)

##FAQ
