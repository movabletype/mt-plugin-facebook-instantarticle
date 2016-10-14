Facebook Instance Article Plugin
==========
Facebook Instant Article を使うときに便利なフィルタを追加するプラグインです。

### 使い方
1. このプラグインをインストールします。
2. RSSフィードをインデックス・テンプレートとして追加します。
3. Facebook にその RSSフィードを登録します。

### fbia filter

このプラグインによって追加されるフィルタです。以下の機能が含まれています。

* HTML コメントを削除する
* `<img>` エレメント `<figure>` エレメントで囲みます。
* `<p>` エレメントに含まれている`<figure>` エレメントがあれば、独立したエレメントにします。
* `<h3>`, `<h4>`, `<h5>`, `<h6>` タグは `<h2>` タグに置き換えられます。
* その他いくつかのオプションがあります。

#### オプション

* `nobr`: `<br> ` エレメントを取り除きます。
* `noscript`: `<script>` エレメントを取り除きます。
* `iframe`: `<iframe>` エレメントがあったとき、`<figure>`エレメントで囲みます。
* `unlink_img`: `<img>` エレメントに設定されている`<a>`エレメントを取り除きます。

### RSS feed template

以下はFacebook Instant Article用に作成するRSSフィードのテンプレートの例です。

```
<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0" xmlns:content="http://purl.org/rss/1.0/modules/content/">
<channel>
<title><mt:BlogName remove_html="1" encode_xml="1"></title>
<link><mt:BlogURL></link>
<description><mt:BlogDescription remove_html="1" encode_xml="1"></description>
<language>en-us</language>
<lastBuildDate><mt:Entries lastn="1"><mt:EntryDate format_name="rfc822"></mt:Entries></lastBuildDate>
<pubDate><mt:Date format_name="rfc822"></pubDate>
<mt:Entries lastn="50">
<item>
  <title><mt:EntryTitle remove_html="1" encode_xml="1"></title>
  <link><mt:EntryLink encode_xml="1"></link>
  <content:encoded>
    <mt:Unless encode_xml="1">
    <!doctype html>
    <html lang="en" prefix="op: http://media.facebook.com/op#">
      <head>
        <meta charset="utf-8">
        <link rel="canonical" href="<mt:EntryPermalink>">
        <meta property="op:markup_version" content="v1.0">
      </head>
      <body>
        <article>
          <header>
            <h1><mt:EntryTitle></h1>
            <time class="op-published" datetime="<mt:EntryDate utc="1" format="%Y-%m-%dT%H:%M:%SZ">"><mt:EntryDate></time>
            <time class="op-modified" dateTime="<mt:EntryModifiedDate utc="1" format="%Y-%m-%dT%H:%M:%SZ">"><mt:EntryModifiedDate></time>
            <address>
              <a rel="facebook" href="http://facebook.com/YOU">YOUR FACEBOOK PAGE</a>
            </address>
          </header>
          <mt:Unless fbia="nobr,noscript,unlink_img"> 
            <mt:EntryBody>
            <mt:EntryMore>
          </mt:Unless>
          <footer>
            <small>CREDIT/COPYRIGHT</small>
          </footer>
        </article>
      </body>
    </html>
    </mt:Unless>
  </content:encoded>
  <guid><mt:EntryPermalink encode_xml="1">-<mt:EntryDate utc="1" format="%Y-%m-%dT%H:%M:%SZ"></guid>
  <description><mt:EntryExcerpt remove_html="1" encode_xml="1"></description>
  <pubDate><mt:EntryDate utc="1" format="%Y-%m-%dT%H:%M:%SZ"></pubDate>
  <author><mt:EntryAuthorDisplayName remove_html="1"></author>
</item>
</mt:Entries>
</channel>
</rss>
```

