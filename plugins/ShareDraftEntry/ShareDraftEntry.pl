package MT::Plugin::ShareDraftEntry;
use strict;
use warnings;
use utf8;

use base qw( MT::Plugin );

my $plugin = __PACKAGE__->new(
    {   name        => 'ShareDraftEntry',
        version     => 0.01,
        description => '<__trans phrase="Enable sharing draft entries.">',
        plugin_link =>
            'https://github.com/masiuchi/mt-plugin-share-draft-entry',

        author_name => 'Masahiro Iuchi',
        author_link => 'https://twitter.com/masiuchi',

        registry => {
            applications => {
                cms => {
                    callbacks =>
                        { 'template_source.edit_entry' => \&_insert_mtml, },
                },
            },
        },
    }
);
MT->add_plugin($plugin);

sub _insert_mtml {
    my ( $cb, $app, $tmpl ) = @_;

    my $insert = quotemeta <<'__INSERT__';
    <strong><__trans phrase="Permalink:"></strong> <mt:var name="entry_permalink">
__INSERT__

    # MT6.
    my $mtml = <<'__MTML__';
      <mt:unless name="status_publish">
        <mt:if name="can_send_notifications">
      <a href="<mt:var name="script_url">?__mode=entry_notify&amp;blog_id=<mt:var name="blog_id" escape="url">&amp;entry_id=<mt:var name="id" escape="url">" class="button<mt:unless name="from_email"> disabled<mt:else> mt-open-dialog</mt:unless>"<mt:unless name="from_email"> onclick="return false;"</mt:unless>><__trans phrase="Share"></a>
        </mt:if>
      </mt:unless>
__MTML__

    $$tmpl =~ s/($insert)/$1$mtml/;
}

1;
