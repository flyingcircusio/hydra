use strict;
use warnings;
use Setup;
use Test2::V0;
use Hydra::Helper::Exec;

my $ctx = test_context();

my $jobsetCtx = $ctx->makeJobset(
    expression => 'constituents-broken.nix',
);
my $jobset = $jobsetCtx->{"jobset"};

my ($res, $stdout, $stderr) = captureStdoutStderr(60,
    ("hydra-eval-jobset", $jobsetCtx->{"project"}->name, $jobset->name)
);
ok(utf8::decode($stderr), "Stderr output is UTF8-clean");
like(
    $stderr,
    qr/aggregate job 'mixed_aggregate' references non-existent job 'constituentA'/,
    "The stderr record includes a relevant error message"
);

$jobset->discard_changes;  # refresh from DB
like(
    $jobset->errormsg,
    qr/in job ‘mixed_aggregate’:\nconstituentA: does not exist/,
    "The jobset records a relevant error message"
);

done_testing;
