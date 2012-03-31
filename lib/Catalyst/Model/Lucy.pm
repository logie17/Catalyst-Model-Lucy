package Catalyst::Model::Lucy;
use Moo;
use FindBin;
use File::Spec;
use Lucy::Search::IndexSearcher;
use Lucy::Plan::Schema;
use Lucy::Analysis::PolyAnalyzer;
use Lucy::Plan::FullTextType;
use namespace::clean;

extends 'Catalyst::Model';
# ABSTRACT: A model for Lucy

has create_index => (
    is => 'rw',
    default => sub { 0 },);

has index_path => (
    is => 'ro',
    default => sub { return File::Spec->catfile("$FindBin::Bin","index") }, );

has index_searcher => (
    builder => '_index_searcher_builder',
    is => 'ro',
    handles => { hits => 'hits' },
    lazy => 1,);

has indexer => (
    builder => '_indexer_builder',
    is => 'ro',
    lazy => 1,);

has language => (
    is => 'rw',
    required => 1,
    default => sub { return 'en' },);

has num_wanted => (
    is => 'rw',
    default => sub { return 10 },);

has schema => (
    builder => '_schema_builder',
    is => 'ro',
    lazy => 1,);

has schema_params => (
    is => 'ro',);

has truncate_index => (
    is => 'rw',
    default => sub { 0 },);

sub _indexer_builder {
    my $self = shift;

    my $indexer = Lucy::Index::Indexer->new(
        index    => $self->index_path,
        schema   => $self->schema,
        create   => $self->create_index,
        truncate => $self->truncate_index,
    );
    return $indexer;
}

sub _index_searcher_builder {
    my $self = shift;
    return Lucy::Search::IndexSearcher->new(
        index => $self->index_path,
    );
}

sub _schema_builder {
    my $self = shift;
    my $schema = Lucy::Plan::Schema->new;
    if ( $self->schema_params ) {
        my $polyanalyzer = Lucy::Analysis::PolyAnalyzer->new(
            language => $self->language
        );
        my $default_type = Lucy::Plan::FullTextType->new(
            analyzer => $polyanalyzer,
        );
        for my $param ( @{$self->schema_params} ) {
            $schema->spec_field(
                name => $param->{name}, 
                type => $param->{type} || $default_type);
        }

    }

    return $schema;
}

__PACKAGE__->meta->make_immutable;

1;
