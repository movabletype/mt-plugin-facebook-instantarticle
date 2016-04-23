use strict;

use lib qw( t/lib lib extlib );
use warnings;
use Test::More tests => 2;

use MT;
use MT::Test;

ok(MT->component('FacebookInstantArticle'), "Facebook Instant Article plugin was loaded correctly" );

require_ok('FacebookInstantArticle::Tags');

1;

