use strict;
use warnings;
use Test::More 0.88;
# This is a relatively nice way to avoid Test::NoWarnings breaking our
# expectations by adding extra tests, without using no_plan.  It also helps
# avoid any other test module that feels introducing random tests, or even
# test plans, is a nice idea.
our $success = 0;
END { $success && done_testing; }

# List our own version used to generate this
my $v = "\nGenerated by Dist::Zilla::Plugin::ReportVersions::Tiny v1.08\n";

eval {                     # no excuses!
    # report our Perl details
    my $want = '5.010';
    $v .= "perl: $] (wanted $want) on $^O from $^X\n\n";
};
defined($@) and diag("$@");

# Now, our module version dependencies:
sub pmver {
    my ($module, $wanted) = @_;
    $wanted = " (want $wanted)";
    my $pmver;
    eval "require $module;";
    if ($@) {
        if ($@ =~ m/Can't locate .* in \@INC/) {
            $pmver = 'module not found.';
        } else {
            diag("${module}: $@");
            $pmver = 'died during require.';
        }
    } else {
        my $version;
        eval { $version = $module->VERSION; };
        if ($@) {
            diag("${module}: $@");
            $pmver = 'died during VERSION check.';
        } elsif (defined $version) {
            $pmver = "$version";
        } else {
            $pmver = '<undef>';
        }
    }

    # So, we should be good, right?
    return sprintf('%-45s => %-10s%-15s%s', $module, $pmver, $wanted, "\n");
}

eval { $v .= pmver('Bio::Chado::Schema','0.20000') };
eval { $v .= pmver('Bio::GFF3::LowLevel','1.5') };
eval { $v .= pmver('BioPortal::WebService','v1.0.0') };
eval { $v .= pmver('Child','0.009') };
eval { $v .= pmver('DBD::Oracle','1.52') };
eval { $v .= pmver('Email::Sender::Simple','0.102370') };
eval { $v .= pmver('Email::Simple','2.10') };
eval { $v .= pmver('Email::Valid','0.184') };
eval { $v .= pmver('File::Find::Rule','0.32') };
eval { $v .= pmver('Log::Log4perl','1.40') };
eval { $v .= pmver('Math::Base36','0.10') };
eval { $v .= pmver('Module::Build','0.3601') };
eval { $v .= pmver('MooseX::App::Cmd','0.06') };
eval { $v .= pmver('MooseX::Attribute::Dependent','v1.1.2') };
eval { $v .= pmver('MooseX::ConfigFromFile','0.02') };
eval { $v .= pmver('MooseX::Event','v0.2.0') };
eval { $v .= pmver('MooseX::Getopt','0.50') };
eval { $v .= pmver('Pod::Coverage::TrustPod','any version') };
eval { $v .= pmver('Spreadsheet::WriteExcel','2.37') };
eval { $v .= pmver('Test::CPAN::Meta','any version') };
eval { $v .= pmver('Test::File','1.34') };
eval { $v .= pmver('Test::Moose::More','0.0019') };
eval { $v .= pmver('Test::More','0.88') };
eval { $v .= pmver('Test::Pod','1.41') };
eval { $v .= pmver('Test::Pod::Coverage','1.08') };
eval { $v .= pmver('Test::Spec','0.46') };
eval { $v .= pmver('Text::TablularDisplay','1.33') };
eval { $v .= pmver('Tie::Cache','0.17') };
eval { $v .= pmver('XML::LibXML','1.70') };
eval { $v .= pmver('XML::Simple','2.18') };
eval { $v .= pmver('version','0.9901') };


# All done.
$v .= <<'EOT';

Thanks for using my code.  I hope it works for you.
If not, please try and include this output in the bug report.
That will help me reproduce the issue and solve your problem.

EOT

diag($v);
ok(1, "we really didn't test anything, just reporting data");
$success = 1;

# Work around another nasty module on CPAN. :/
no warnings 'once';
$Template::Test::NO_FLUSH = 1;
exit 0;
