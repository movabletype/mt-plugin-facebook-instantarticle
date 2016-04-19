Facebook Instance Article Plugin
==========
This is a Movable Type plugin to add a global modifier useful for Facebook Instant Article.

1. Install this plugin.
2. Add a RSS feed as an index template
3. Submit the feed to Facebook.

### fbia filter

This plugin add a global modifier to fit Facebook Instant Artcile Content:

* Strip all comments
* Wrap img elements with `<figure>...</figure>` if not.  
* `<figure>` tags would independ from `<p>...</p>`
* h3, h4, h5 and h6 tags are converted to h2.
* Some options to handle the filter behavior.

### options

* `nobr`: This would strip all `<br>` tags.
* `noscript`: This would strip all `<script>` tag.
* `iframe`: This would be all `<iframe>` wrapped with `<frame class="op-social">...</frame>` tag.
* `unlink_img`: This would strip `<a>` tag which be wraped `<img>`.

### RSS feed template

This is a sample of RSS Feed Template for FB Instant Article.


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
          <mt:Unless>
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

