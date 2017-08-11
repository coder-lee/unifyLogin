#1. 统一登录所使用的第三方库  
1.AFNetWorking  网络请求 

2.SVProgressHub 提示

3.IQKeyboardManager 键盘事件的处理

4.YYKit 一些地方用到了dic转model 和 setImageWithUrl


#2.代码梳理

代码里面很多地方注释都有的。  我把用户信息用NSUserDefault 用关键字KUserModel 保存在本地在。

我讲所有的导入，宏定义灯基本都放在 oneForAll.Pch 文件里面

请求方式的封装我只是简单的封装了一个 GET POST PUT DELETE 这四个请求方式  

图片上传  因为只使用了一次,所以没有封装。

加密用的是AES加密

#3.待完善功能  

<!--修改密码现在没有接口,所以只有界面 -->

还有二次登陆看后面是否是用TOKEN登陆还是什么，现在我是在本次保存的字段判断是否登陆，在 viewController里面可以看见

banner图是本地获取的，看以后是否有这个接口，点击事件

#4.综述

UI这些很多地方都是我们自己想的，所以很多不完善的，后续还会有很多修改。


THANKS

大家由于需要更改的地方可以在这个文档里面补充！

<!--7.7号更新第三方登录-->

第三方登录sdk代码已经写好了，只是没有申请appkey 和appsecret 
接口文档：http://wiki.mob.com/简洁版第三方登陆/

<!--因为没有各个应用的key这些，所以集成的时候自己改一下就就OK了-->
