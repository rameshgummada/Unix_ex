#!/usr/bin/perl
while (@ARGV) {
   $p = (shift @ARGV);
   if ($p eq "-action") {
      $action = @ARGV[0];
      }
   }
$action = uc($action);
if ($action ne "START") {
   print stderr "ssstartup.pl -action START not specified, exitting\n";
   exit;
   }
my $rc = `who am i`;
($realuser,$rest) = split(" ",$rc);
################################################
$host = `uname -n`;
chomp $host;
################################################
$rc = `id`;
($id,$group) = split(" ",$rc);
($rest,$id,$rest) = split("[()]",$id);
################################################
$home = `env $HOME | egrep -i "^HOME"`;
chomp $home;
$home = "/export/home/$id";
print "HOME=<$home>\n";
$startupfile = "$home/ssstartup.txt";
################################################
$logdir = "$home/initlogs";
if (-e $logdir) {
   $msg = "LogDirectory ($logdir) exists, cleaning up\n";
   printmsg("$msg\n");
   cleanup_logs("$logdir");
   }
else {
   $rc = `mkdir $logdir`;
   $rc = `chmod 775 $logdir`;
   }
################################################
$d1 = `date +%Y%m%d%H%M%S`;
chomp $d1;
################################################
#$logfile = "$logdir/WASSTART$d1.log";
$t = localtime();
#$t1 = "#ssstartup.pl LOGFILE=$logfile $t";
#print stderr "$t1\n";
#print "$t1\n";
open (startuplist, "<$startupfile") or die  "Cannot Open $startupfile: $!\n";
while (<startuplist>) {
   chomp;
   $t = localtime();
   $cmd = $_;
   if ($cmd eq "") {next;}
   if (substr($cmd,0,1) eq "#") {next;}
   #$cmd =~ s/\$log$/$logfile/;
   printmsg("SSINIT005I $t\n");
   printmsg("SSINIT029I Issuing $cmd\n");
   `echo "Issuing CMD=$cmd"`;
   $rc = `$cmd`;
   printmsg("$rc");

   }
################################################
$t = localtime();
send_email();
#$rc = `echo $host SSINIT ACTION=$action Initiated $t\n$id\n | mailx -s "$host SSINIT ACTION=$action $t" -r "example\@ex.com" myex@ex.com`;
#print "RC=<$rc>\n";
################################################
#exit;
##################################
sub send_email {
   #print "In send_email\n";
   push @mailusers, "Alliance-Infrastructure2\@ex.com";
   my $msg = "$host SSINIT ACTION=$action Initiated by $realuser $t\n$id\n";
   $t = localtime();
   foreach my $emailid (@mailusers) {
      `echo "$msg" | mailx -s "$host WAS$action $msg $t" -r "ATO-Alliance-Infrastructure\@ex.com" $emailid`;
      printmsg("SSINIT090E: Mail $msg submitted to $emailid\n");
      }
   }
##################################
sub send_email_OLD {
   #print "In send_email\n";
   my $rc = `who am i`;
   ($iam,$rest) = split(" ",$rc);
   push @mailusers, "jedga\@ex.com";
   if ($iam ne "") {
      push @mailusers, "$iam\@ex.com";
      }
   my $msg = "$host SSINIT ACTION=$action Initiated $t\n$id\n";
   $t = localtime();
   foreach my $emailid (@mailusers) {
      `echo "$msg" | mailx -s "$host WAS$action $msg $t" -r "example\@ex.com" $emailid`;
      printmsg("SSINIT090E: Mail $msg submitted to $emailid\n");
      }
   }
##################################################
sub cleanup_logs {
   my $logdir = @_[0];
   $diropen = "OK";
   opendir (localdir, $logdir) or $diropen = "NotOK";
   if ($diropen ne "OK") {print "Error opening $logdir\n"; return;}
   @file_array = readdir(localdir);
   foreach $direntry (@file_array) {
      if ($direntry eq ".") {next;}
      if ($direntry eq "..") {next;}
      $age = -M "$logdir/$direntry";
      $age = sprintf("%05.0f",$age);
      if ($age > 60) {
          print "$logdir/$direntry $age Days Old\n";
          $rc = `rm $logdir/$direntry`;
          print "deleting $logdir/$direntry\n";
          }
      }
   close localdir;
   }
##################################################
sub printmsg {
   my $msg = @_[0];
   print stderr $msg;
   print $msg;
   }
