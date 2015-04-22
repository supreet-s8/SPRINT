package Configuration;

use MIME::Lite;
use vars qw( $instaLag $currentTime $collectorLag $screenScriptMonitoring $hadoop $hadoopdfs $hadoop_mising_corpt );
use strict;

$currentTime = time();
chomp ($currentTime);

# Put comma seperated email id's in to and cc variables. Please escape the "@" by using "\" bcoz it is a special character in perl. As done below.
#NOTE : Email ID's mentioned in the indeviual monitor object will be given more weightage then the default one.
#If we have not mentioned the Email id list in indiviual monitor object then the to will be defualt one.  

our $email_to_default = "robert.phillips\@guavus.com , noc.support\@guavus.com, jatinder.singh\@guavus.com , eric.darby\@guavus.com , samuel.joseph\@guavus.com , mohsin.ali\@guavus.com";
#our $email_cc_default = "jatin.gupta\@guavus.com";

$instaLag = {
	"monitor" => {
		"aggregationinterval" => {

			"db" => "dpifive",
			"app_name" => "Content Analytics",
				"ip" => "10.23.80.38",
			"query" => "select maxts from bin_metatable where aggregationinterval=-1",
			"daylimit" => "0",
			"hourlimit" => "8"


		},
		"NerActual" => {

			"db" => "nae_bad_luck", 
			"app_name" => "NER",
				"ip" => "10.23.80.30",
			"query" => "select maxts from bin_metatable where binclass='NerActual'",
			"daylimit" => "0",
			"hourlimit" => "9"


		},
		"RrBinDaily" => {

			"db" => "nae_bad_luck",
			"app_name" => "RR",
				"ip" => "10.23.80.30",
			"query" => "select maxts from bin_metatable where binclass='RrBinDaily'",
			"daylimit" => "0",
			"hourlimit" => "8"


		}
	},

	"email_to" => "",
	"email_cc" => ""

};

$collectorLag = {
	"monitor" => {
		"10.23.80.11" => {

			"adaptors" => [ "cdmaIpdr" , "cdmaVoice" , "lteIpdr" , "wimax" ],
			"app_name" => "NAE",
			"limit" => 2
		}
	},
	"email_to" => "",
	"email_cc" => ""
};

$screenScriptMonitoring = {

	"monitor" => {
		#"10.23.80.26" => [ "load_data" , "load_data_hive.py" ],
		 "ip" => "10.23.80.26",
                 #"cmd" => "ps -ef |grep -v grep |grep python |wc -l",
	},
	"app_name" => "SAS",
	"email_to" => "",
	"email_cc" => ""

};

$hadoopdfs = {

	"monitor" => {
		"NAE" => 
			{
				"ip" => "10.23.80.70",
				"cmd" => "hadoop dfsadmin -report 2>/dev/null | head -5 | tail -1",
				"limit" => "86"
			},
		"SAS" =>
			{
				"ip" => "10.23.80.26",
				"cmd" => "hadoop dfsadmin -report 2>/dev/null | head -5 | tail -1",
				"limit" => "80"
			}
	},
	"email_to" => "",
	"email_cc" => ""

};


$hadoop_mising_corpt = {

	"monitor" => {
		"NAE" => 
			{
				"ip" => "10.23.80.70",
				"cmd" => "hadoop fsck / - notify 2>/dev/null",
			},
		"SAS" =>
			{
				"ip" => "10.23.80.26",
				"cmd" => "hadoop fsck / - notify 2>/dev/null",
			}
	},
	"email_to" => "",
	"email_cc" => ""

};

sub send_mail {

	my $from = shift;
	my $to = shift;
	my $cc = shift;
	my $subject = shift;
	my $data = shift;
	
	$to = $to || $email_to_default;
#	$cc = $cc || $email_cc_default;
	
	my $msg = MIME::Lite->new(
			From     =>$from,
			To       =>$to,
			Cc       =>$cc,
			Subject  =>$subject,
			Data     =>$data
			);
	$msg->send();
}


;
