use Test::More tests => 7;
use Test::Exception;
use lib 't/lib';

use_ok('TestAppNoSchema');
my $subject = TestAppNoSchema->model('Lucy');

$subject->indexer->add_doc({title=>'foo', desc=>'bar'});
$subject->indexer->commit;

isa_ok $subject->index_searcher, "Lucy::Search::IndexSearcher", "We have a Lucy Searcher Obj";
like $subject->index_path, qr#t/test_index#, "Correct index path";
is $subject->num_wanted, 20, "Page size is 20";

my $hits = $subject->hits(query=>'foo');

is $hits->total_hits, 2;

while ( my $hit = $hits->next ) {
    is $hit->{desc},"bar";
}

