## 概要
payjp APIを使ったクレジットカード決済練習用のアプリです。

## バージョン
ruby・・・2.5.7<br>
rails・・・5.2.4.4<br>
mysql・・・5.7

## ローカル環境での実行手順
dockerとdocker-composeを自分のpcにインストール

好きなディレクトリで<br>
`git clone https://github.com/Mac0917/credit.git`

移動<br>
`cd credit`

docker-composeを実行<br>
`docker-compose up -d`

データベース作成<br>
`docker exec -it credit_app_1 bash`(コンテナに入る)<br>
`rails db:create`<br>
`rails db:migrate`<br>

アクセス<br>
http://localhost:3000/<br>
payjp APIを取得してないのでエラーがでます。下の見出しを読んで実装してみてください。

終了<br>
`exit`(コンテナから出る)<br>
`docker-compose stop`<br>
`docker-compose rm`<br>
`docker rmi credit_app credit_web`<br>
`docker volume rm credit_db-volume`

リポジトリを削除<br>
`cd ..`<br>
`rm -rf credit`


## payjp実装方法
payjp公式サイトよりアカウント登録して秘密鍵と公開鍵を入手<br>
環境変数にその鍵をどちらも設定<br>
application.htmlのheaderに以下を追加<br>
```
   <script src='https://js.pay.jp/' type='text/javascript'></script>
```
payjpオリジナルのモーダル<br>
```
<form action="/card/purchase2" method="post">
  <script type="text/javascript" src="https://checkout.pay.jp/" class="payjp-button" data-key="<%=ENV['KEY']%>" data-submit-text="トークンを作成"></script>
</form>
```
あとはcard_controllerとpayjp.jsのファイルを見ればわかる<br>


## 追記
payjpがアップデートしたみたいなのでhttps://pay.jp/docs/payjs-guidanceを読む<br>
Payjp.setPublicKey(gon.key);が使えなくなっていた