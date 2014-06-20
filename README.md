# 检查上海交通卡余额的 perl 脚本

``` bash
$ ./main.pl xxxxxxxxxxx
截至2012年12月21日，您卡内余额为0元。
```
`xxxxxxxxxxx` 此处为11位数字。

注：Arch Linux 用户请安装 `perl-libwww` 和 `perl-lwp-protocol-https`（其实这个不需要），其它平台用户自己看着办（

请使用吉米菊苣 `@jimmy_xu_wrk` 提供的单行代码（
``` bash
$ curl -sD- 'http://jtk.sptcc.com:8080/servlet?hiddentype=s_index' -d 'Card_id=$1' | grep Location | perl -MMIME::Base64 -npe 's/^.+?time=(.+?)&card_balance=(.+)/"截至".decode_base64($1)."，您卡内余额为".decode_base64($2)."分"/e'
```
