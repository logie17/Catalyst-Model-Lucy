package # hide from PAUSE
    TestApp;
 
use strict;
use warnings;
use FindBin;
use File::Spec;
 
use Catalyst;
 
__PACKAGE__->config(
    name        => 'TestApp',
    'Model::Lucy' => {
         index_path     => File::Spec->catfile($FindBin::Bin,'index'),
         num_wanted     => 20,
         language       => 'en',
         create_index   => 1,
         schema_params  => [
                               { name => 'title' },
                               { name => 'desc' }
                           ]
    },
);
 
__PACKAGE__->setup;
 
1;
