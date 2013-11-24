# Implemenatation example of Safari Push Notification on Ruby on Rails.


Safari Push Notification (以下 SPN と記述)が OS X Maverics でサポートされました。

[https://developer.apple.com/library/mac/documentation/NetworkingInternet/Conceptual/NotificationProgrammingGuideForWebsites/PushNotifications/PushNotifications.html](https://developer.apple.com/library/mac/documentation/NetworkingInternet/Conceptual/NotificationProgrammingGuideForWebsites/PushNotifications/PushNotifications.html)


実装は難しくないのですが、手順がややこしかったので、サンプルソースを公開します。勘所を説明しやすくするためにRails的に書いていますが、エッセンスはRails以外でも使えると思います。

環境変数を多く使っていますが、設定に関する部分を除外して説明しようとしているためで、実際の利用では Settingslogic や Configuration などを使ってうまくまとめるとよいでしょう。

サーバとのやりとりではCookieが送られてこないので、Sessionにユーザ情報を入れてログインしているかどうかを管理している場合は、別の手段をとる必要があります。

1. ユーザを識別できるtokenを、javascript側に仕込む。requestPermissionのuserInfoハッシュ部分。
2. userInfo部分のtokenが入った、packageを生成。
3. SPNをgrant/denyしたときにサーバに送られてくるHTTP_AUTHENTICATIONヘッダに ApplePushNotifications と token がスペースで区切られて入ってくるのでそのtokenからユーザを識別する。
