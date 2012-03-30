use Test::More tests => 4;
use lib 't/lib';

use_ok('TestApp');
my $subject = TestApp->model('Lucy');

$subject->indexer->add_doc({title=>'foo', desc=>'bar'});
$subject->indexer->commit;

isa_ok $subject->index_searcher, "Lucy::Search::IndexSearcher", "We have a Lucy Searcher Obj";
like $subject->index_path, qr#t/index#, "Correct index path";
is $subject->num_wanted, 20, "Page size is 20";

