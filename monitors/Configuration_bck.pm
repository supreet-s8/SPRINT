package Configuration;

use MIME::Lite;
use vars qw( $instaLag $currentTime $collectorLag $screenScriptMonitoring $hadoop $hadoopdfs $hadoop_mising_corpt );
use strict;

$currentTime = time();
chomp ($currentTime);

our $email_to_default = "samuel.joseph\@guavus.com";
our $email_cc_default = "jatin.gupta\@guavus.com";

$instaLag = {
	"monitor" => {
#10.23.80.38
		"aggregationinterval" => {

			"db" => "nae_feb27",#nae_bad_luck
			"app_name" => "Content Analytics",
				"ip" => "172.30.3.62",
			"query" => "select maxts from bin_metatable where aggregationinterval=-1",
			"daylimit" => "0",
			"hourlimit" => "8"


		},
#10.23.80.30
		"NerActual" => {

			"db" => "nae_feb27", #dpifive
			"app_name" => "NER",
				"ip" => "172.30.3.62",
			"query" => "select maxts from bin_metatable where binclass='NerActual'",
			"daylimit" => "0",
			"hourlimit" => "8"


		},
#10.23.80.30
		"RrBinDaily" => {

			"db" => "nae_feb27", #dpifive
			"app_name" => "RR",
				"ip" => "172.30.3.62",
			"query" => "select maxts from bin_metatable where binclass='RrBinDaily'",
			"daylimit" => "0",
			"hourlimit" => "8"


		}
	},

	"email_to" => "jatin.gupta\@guavus.com , samuel.joseph\@guavus.com",
	"email_cc" => "jatin.gupta\@guavus.com , samuel.joseph\@guavus.com"

};

$collectorLag = {
	"monitor" => {
#10.23.80.70
		"172.30.3.60" => {

			"adaptors" => [ "cdmaIpdr" , "cdmaVoice" , "lteIpdr" , "wimax" ],
			"app_name" => "NAE",
			"limit" => 2
		}
	},
	"email_to" => "jatin.gupta\@guavus.com",
	"email_cc" => "jatin.gupta\@guavus.com"
};

$screenScriptMonitoring = {

	"monitor" => {
		"172.30.3.66" => [ "load_data" , "load_data_hive.py" ],
	},
	"app_name" => "SAS",
	"email_to" => "jatin.gupta\@guavus.com",
	"email_cc" => "jatin.gupta\@guavus.com"

};

$hadoopdfs = {

	"monitor" => {
		"NAE" => 
			{
				"ip" => "172.30.3.60",
				"cmd" => "hadoop dfsadmin -report 2>/dev/null | head -5 | tail -1",
				"limit" => "80"
			},
		"SAS" =>
			{
				"ip" => "172.30.3.60",
				"cmd" => "hadoop dfsadmin -report 2>/dev/null | head -5 | tail -1",
				"limit" => "2"
			}
	},
	"email_to" => "jatin.gupta\@guavus.com",
	"email_cc" => "jatin.gupta\@guavus.com"

};


$hadoop_mising_corpt = {

	"monitor" => {
		"NAE" => 
			{
				"ip" => "172.30.3.60",
				"cmd" => "hadoop fsck / - notify 2>/dev/null",
			},
		"SAS" =>
			{
				"ip" => "172.30.3.60",
				"cmd" => "hadoop fsck / - notify 2>/dev/null",
			}
	},
	"email_to" => "jatin.gupta\@guavus.com",
	"email_cc" => "jatin.gupta\@guavus.com"

};

sub send_mail{

	my $from = shift;
	my $to = shift;
	my $cc = shift;
	my $subject = shift;
	my $data = shift;
	
	$to = $to || $email_to_default;
	$cc = $cc || $email_cc_default;
	
	my $msg = MIME::Lite->new(
			From     =>$from,
			To       =>$to,
			Cc       =>$cc,
			Subject  =>$subject,
			Data     =>$data
			);
	$msg->send();
}


1;
