#!/usr/bin/perl

use strict;
use warnings;

use lib qw(lib t/lib);

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use Test::Base;
plan tests => 1 * blocks;

use MT;
use MT::Test qw(:db :data);
my $app = MT->instance;

my $blog_id = 2;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
};

run {
    my $block = shift;

SKIP:
    {
        skip $block->skip, 1 if $block->skip;

        my $name = $block->name || $block->template;
        $name =~ s/\n//g;

        my $tmpl = $app->model('template')->new;
        $tmpl->text( $block->template );
        my $ctx = $tmpl->context;

        my $blog = MT::Blog->load($blog_id);
        $ctx->stash( 'blog',          $blog );
        $ctx->stash( 'blog_id',       $blog->id );
        $ctx->stash( 'local_blog_id', $blog->id );
        $ctx->stash( 'builder',       MT::Builder->new );

        my $result = $tmpl->build;
        $result =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g;

        is( $result, $block->expected, $name );
    }
};

__END__

=== with 'noscript'
--- template
<mt:Unless fbia="noscript">123<script src="javascript">test</script>456</mt:Unless>
--- expected
123456

=== without 'noscript'
--- template
<mt:Unless fbia="script">123<script src="javascript">test</script>456</mt:Unless>
--- expected
123<script src="javascript">test</script>456

=== with 'nobr'
--- template
<mt:Unless fbia="nobr"><p>123<br>456</p></mt:Unless>
--- expected
<p>123456</p>

=== with 'nobr' 2
--- template
<mt:Unless fbia="nobr">
<p>
123<br>
456<br />
789<br  />
</p></mt:Unless>
--- expected
<p>
123
456
789
</p>

=== without nobr
--- template
<mt:Unless fbia="script">123<br>456</mt:Unless>
--- expected
123<br>456

=== 'nobr' and 'noscript' combination
--- template
<mt:Unless fbia="nobr,noscript"><p>123<br />456</p></mt:Unless>
--- expected
<p>123456</p>

=== with 'iframe'
--- template
<mt:Unless fbia="iframe">123<iframe src="test"></iframe>456</mt:Unless>
--- expected
123<figure class="op-interactive"><iframe src="test"></iframe></figure>456

=== removing a comment, as default rule.
--- template
<mt:Unless fbia="script">te<!-- 123<br>456 -->st</mt:Unless>
--- expected
test

=== removing a comment with no arg., as default rule.
--- template
<mt:Unless fbia="">te<!-- 123<br>456 -->st</mt:Unless>
--- expected
test

=== wrapping <img> in  <figure>
--- template
<mt:Unless fbia="img">
<img src="http://www.example.com/sample.jpg" alt="example image" />
</mt:Unless>
--- expected
<figure><img src="http://www.example.com/sample.jpg" alt="example image" /></figure>

=== strip style and class
--- template
<mt:Unless fbia="img">
<img src="http://www.example.com/sample.jpg" alt="example image" style="border: 1px solid black;" class="mt-image-center large" />
</mt:Unless>
--- expected
<figure><img src="http://www.example.com/sample.jpg" alt="example image" /></figure>

=== wrapping <img> in  <figure>
--- template
<mt:Unless fbia="img">
<img src="http://www.example.com/sample1.jpg" alt="example image" />
<img src="http://www.example.com/sample2.jpg" alt="example image" />
<img src="http://www.example.com/sample3.jpg" alt="example image" />
</mt:Unless>
--- expected
<figure><img src="http://www.example.com/sample1.jpg" alt="example image" /></figure>
<figure><img src="http://www.example.com/sample2.jpg" alt="example image" /></figure>
<figure><img src="http://www.example.com/sample3.jpg" alt="example image" /></figure>

=== unwrapping <img> in <a> with 'unlink_img'
--- template
<mt:Unless fbia="unlink_img">
<a href="http://www.example.com/sample-large.jpg" title="large sample"><img src="http://www.example.com/sample.jpg" alt="example image" /></a>
</mt:Unless>
--- expected
<figure><img src="http://www.example.com/sample.jpg" alt="example image" /></figure>

=== keep <img> in <a> without 'unlink_img'
--- template
<mt:Unless fbia="1">
<a href="http://www.example.com/sample-large.jpg" title="large sample"><img src="http://www.example.com/sample.jpg" alt="example image" /></a>
</mt:Unless>
--- expected
<figure><a href="http://www.example.com/sample-large.jpg" title="large sample"><img src="http://www.example.com/sample.jpg" alt="example image" /></a></figure>

=== wraping <img> and <a> with <figure>
--- template
<mt:Unless fbia="img_unlink">
<a href="http://www.example.com/sample-large.jpg" title="large sample"><img src="http://www.example.com/sample.jpg" alt="example image" /></a>
</mt:Unless>
--- expected
<figure><a href="http://www.example.com/sample-large.jpg" title="large sample"><img src="http://www.example.com/sample.jpg" alt="example image" /></a></figure>

=== no wrapping <img> in <figure> recursively
--- template
<mt:Unless fbia="img">
<figure>
<img src="http://www.example.com/sample.jpg" alt="example image" />
</figure>
</mt:Unless>
--- expected
<figure>
<img src="http://www.example.com/sample.jpg" alt="example image" />
</figure>

=== <figure> is an independent element from <p>: 1 
--- template
<mt:Unless fbia="img">
<p><img src="http://www.example.com/sample.jpg" alt="example image" /></p>
</mt:Unless>
--- expected
<figure><img src="http://www.example.com/sample.jpg" alt="example image" /></figure>

=== <figure> is an independent element from <p>: 2
--- template
<mt:Unless fbia="img">
<p>
<figure>
<img src="http://www.example.com/sample.jpg" alt="example image" />
</figure>
test
</p>
</mt:Unless>
--- expected
<figure>
<img src="http://www.example.com/sample.jpg" alt="example image" />
</figure>
<p>
test
</p>

=== complex pattern
--- template
<mt:Unless fbia="nobr,noscript,img_unlink,iframe">
<p>
<figure>
<img src="http://www.example.com/sample.jpg" alt="example image" />
<figcaption><h1>example image</h1></figcaption>
</figure>
test1<br>
test2<br>
<img src="test.jpg" alt="test jpg" />
test3
</p>
</mt:Unless>
--- expected
<figure>
<img src="http://www.example.com/sample.jpg" alt="example image" />
<figcaption><h1>example image</h1></figcaption>
</figure>
<p>
test1
test2
</p>
<figure><img src="test.jpg" alt="test jpg" /></figure>
<p>
test3
</p>

=== Combination test.
--- template
<mt:Unless fbia="1">
<p>text, text, text, <a href="https://example.com/">link</a>text, text, text.</p>
<p><img alt="example image" src="http://example.ccom/image.png" width="1200" height="615" class="mt-image-center" style="text-align: center; display: block; margin: 0 auto 20px;" /></p>
</mt:Unless>

--- expected
<p>text, text, text, <a href="https://example.com/">link</a>text, text, text.</p><figure><img alt="example image" src="http://example.ccom/image.png" width="1200" height="615" /></figure>


=== Headers
--- template
<mt:Unless fbia="1">
<h1>test</h1>
<h2>test</h2>
<h3>test</h3>
<h4>test</h4>
<h5>test</h5>
<h6>test</h6>
</mt:Unless>

--- expected
<h1>test</h1>
<h2>test</h2>
<h2>test</h2>
<h2>test</h2>
<h2>test</h2>
<h2>test</h2>


