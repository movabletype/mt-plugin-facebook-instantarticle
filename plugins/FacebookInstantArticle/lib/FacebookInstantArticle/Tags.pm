package FacebookInstantArticle::Tags;

use strict;

sub _hdlr_fbia {
    my ($str, $arg, $ctx) = @_;
    my $original = $str;

    my $pattern = {
        # options          
	'noscript' => [qr/<script.*?>.*?<\/script>/i, ''],
	'nobr' => [qr/<br\s*\/?>/i, ''],
	'iframe' => [qr/(?s:(<iframe.*?>.*?<\/iframe>))/i, '<figure class="op-social">$1<\/figure>'],

	# default pattern
        '__erase_comment' => [qr/<!--.*?-->/, ''],
    };

    # added default pattern.
    if (ref($arg) eq '') {
	$arg = [split(/,/, lc($arg)) ];
	push @$arg, qw( __erase_comment);
    }

    # unwrap link from image.
    if (grep {$_ eq 'unlink_img'} @$arg) {
        $str =~ s/(?s:<a.*?>(<img.*?>)<\/a>)/$1/gi;
    }

    # wrapping <img> with <figure> but not recursively
    $str =~ s/(?s:(<figure.*>(?:(?!<\/?figure>).)*?)<img(.*?)>)((?s:.*?<\/figure>))/$1<__IMG__$2>$3/gi;
    $str =~ s/((?:<a.*?>)?<img.*?>(?:<\/a>)?)/<figure>$1<\/figure>/gis;
    $str =~ s/<__IMG__(.*?)>/<img$1>/g;

    # strip style and class from <img>
    $str =~ s/<img(.*?)\s*style=".*?"\s*(.*?)>/<img$1 $2>/gis;
    $str =~ s/<img(.*?)\s*class=".*?"\s*(.*?)>/<img$1 $2>/gis;

    # option filters
    for (@$arg) {
        if (my $re = $pattern->{$_}) {
            my $r = $re->[0];
	    eval '$str =~ s/$re->[0]/'.$re->[1].'/g';
	}
    }

    # to independ <figure> from <p>, search each <p>...</p>, then handle <fugure>...
    my $t = '';
    while ($str =~ m/^(.*?)<p(.*?)>(.*?)<\/p>/is) {
	$t .= $1;
	my $attr = $2;
	my $p = $3;
	$str =~ s/^.*?<p.*?>.*?<\/p>//is;
	$p =~ s/\n*(<figure.*?>.*?<\/figure>)\n*/\n<\/p>\n$1\n<p>\n/gis;
	$t .= '<p' . $attr. '>' . $p . '</p>';
    }
    $str = $t . $str;

    # no empty <p></p>
    $str =~ s/<p.*?>\s*?<\/p>//gis;
    $str =~ s/\n{2,}//g;
    return $str;
}

1;
