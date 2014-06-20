#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use 5.010;

use LWP;
use Encode qw/encode decode/;

sub get_html($) {
    my ($card_id) = @_;
    my $ua = LWP::UserAgent->new;
    $ua->agent('Mozilla/5.0 (X11; Linux x86_64; rv:33.0) Gecko/20100101 Firefox/33.0');
    push @{ $ua->requests_redirectable }, 'POST';
    $ua->cookie_jar({});
    my $url = 'http://jtk.sptcc.com:8080/servlet';
    my $response = $ua->post($url, [
        'Card_id' => $card_id,
        'hiddentype' => 's_index',
        ]);

    return encode 'utf8', decode('euc-cn', $response->content);

}

sub main(@) {
    my ($card_id) = @_;
    die '请输入您的交通卡卡号（11位数字）！' if (@_ != 1);
    die '交通卡卡号必须为11位数字！' if !($card_id =~ /[[:digit:]]{11}/);
    my %card;
    my $html = get_html $card_id;
    if ($html =~ /<span class="greenBoldTitle">  ([[:digit:]]{4})年 ([[:digit:]]{2})月 ([[:digit:]]{2})日  <\/span>/) {
        $card{'date'} = [$1, $2, $3];
    }

    if ($html =~ /<span class="orangeNumber">  ([[:digit:].]+)<\/span> <span class="black14"> 元<\/SPAN><\/TD>/) {
        $card{'money'} = $1;
    }

    print "截至${card{'date'}[0]}年${card{'date'}[1]}月${card{'date'}[2]}日，您卡内余额为${card{'money'}}元。\n";
}

main @ARGV;
