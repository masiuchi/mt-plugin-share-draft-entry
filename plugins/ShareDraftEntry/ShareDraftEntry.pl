package MT::Plugin::ShareDraftEntry;
use strict;
use warnings;
use utf8;

use base qw( MT::Plugin );

my $plugin = __PACKAGE__->new(
    {
        name        => 'ShareDraftEntry',
        id          => 'ShareDraftEntry',
        version     => 0.01,
        description => '<__trans phrase="Enable sharing draft entries.">',
        plugin_link =>
          'https://github.com/masiuchi/mt-plugin-share-draft-entry',

        author_name => 'Masahiro Iuchi',
        author_link => 'https://twitter.com/masiuchi',

        registry => {
            l10n_lexicon => {
                ja => &_l10n_lexicon_ja,
            },

            applications => {
                cms => {
                    callbacks =>
                      { 'template_source.edit_entry' => \&_insert_mtml, },
                },
            },

            default_templates => {
                base_path      => 'tmpl/global',
                'global:email' => {
                    'notify-entry' => { label => 'Entry Notify', },
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

sub _l10n_lexicon_ja {
    return {
        # ShareDraftEntry
        'Enable sharing draft entries.' =>
'公開前の記事／ページも共有できるようにします。',

        # tmpl/global/notify-entry.mtml
        q{A [lc,_3] entitled '[_1]' has been created to [_2].} =>
          q{[_3]「[_1]」を[_2]で作成しました。},

'You are receiving this email either because you have elected to receive notifications about content on [_1], or the author of the post thought you would be interested. If you no longer wish to receive these emails, please contact the following person:'
          => 'このメールは[_1]で作成されたコンテンツに関する通知>を送るように設定されているか、またはコンテンツの著者が選択したユーザーに送信されています。このメールを受信し>たくない場合は、次のユーザーに連絡してください:',
    };
}

1;
