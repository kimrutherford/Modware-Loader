
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "Module::Build" => "0.3601"
  },
  "configure_requires" => {
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "Data loading modules and scripts for Chado relational database ",
  "dist_author" => [
    "Siddhartha Basu <biosidd\@gmail.com>"
  ],
  "dist_name" => "Modware-Loader",
  "dist_version" => "1.0.0",
  "license" => "perl",
  "module_name" => "Modware::Loader",
  "recommends" => {
    "Child" => "0.009",
    "Email::Sender::Simple" => "0.102370",
    "Email::Simple" => "2.10",
    "Email::Valid" => "0.184",
    "GOBO" => "0.03",
    "Log::Dispatchouli" => "2.005",
    "Log::Log4perl" => "1.30",
    "Modware" => "0.001",
    "MooseX::Attribute::Dependent" => "v1.1.2",
    "Spreadsheet::WriteExcel" => "2.37",
    "Text::TablularDisplay" => "1.33",
    "XML::LibXML" => "1.70",
    "XML::Simple" => "2.18"
  },
  "recursive_test_files" => 1,
  "requires" => {
    "Bio::Chado::Schema" => "0.09000",
    "Bio::GFF3" => "0.7",
    "BioPortal::WebService" => "v1.0.0",
    "File::Find::Rule" => "0.32",
    "Log::Log4perl" => "1.38",
    "MooseX::App::Cmd" => "0.06",
    "MooseX::ConfigFromFile" => "0.02",
    "MooseX::Getopt" => "0.33",
    "Throwable" => "0.102080",
    "Tie::Cache" => "0.19",
    "perl" => "5.010"
  },
  "script_files" => [
    "bin/chado2dicty_gff3_parallel.sh",
    "bin/discoideum_tblastn_filter.pl",
    "bin/modware",
    "bin/modware-export",
    "bin/modware-filter",
    "bin/modware-load",
    "bin/modware-report",
    "bin/modware-transform",
    "bin/modware-update",
    "bin/chado2dicty_gff3_parallel.sh",
    "bin/discoideum_tblastn_filter.pl",
    "bin/modware",
    "bin/modware-export",
    "bin/modware-filter",
    "bin/modware-load",
    "bin/modware-report",
    "bin/modware-transform",
    "bin/modware-update"
  ]
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;