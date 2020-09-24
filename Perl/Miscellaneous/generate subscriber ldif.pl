###############################################################################
##                                               DTT (c)2005 FSL - FreeSoftLand
## Title: generate subscriber ldif
##
## Date : 12/10/2005
## By   : Oracle Corporation.  All rights reserved.
###############################################################################

#!/usr/local/bin/perl
# 
# $Header: flattenlst.pl 08-apr-2002.17:53:48 stlee Exp $
#
# generatesubscriberldif.pl
# 
# Copyright (c) 2001, 2002, Oracle Corporation.  All rights reserved.
#
#    NAME
#     flattenlst.pl : flattens a nested list of template files into one single
#                      template file
#
#    DESCRIPTION
#
#    NOTES
#      <other useful comments, qualifications, etc.>
#
#    MODIFIED   (MM/DD/YY)
#    stlee       04/08/02 - stlee_bug-2310185
#    akolli      04/01/02 - Creation
# 

use Getopt::Std; # get the standard options package

################################################################
################################################################
## usage function
################################################################
################################################################
## standard usage file 
sub usage 
{
  print qq@
    Usage : $0 -i input_file -o output_file

        where
          input_file: the file containing the nested templates
          output_file: the file containing the un-nested templates
          \n@;
  exit();
}


################################################################
################################################################
## variable substitution.logic
################################################################
################################################################
sub do_substitution {
  local($output_file, @file_array) = @_;

  open (LDIF_FILE, ">$output_file")  || die "cannot open file $output_file: $!";
  foreach $file (@file_array) {
    open(SBS_FILE,"$file")  || die "cannot open file $file: $!";
    print LDIF_FILE qq@#################################################################
# Beginning of LDIF from $file   
#################################################################\n@;

SBS_LOOP:
    while( $sbs_line = <SBS_FILE>) {
      print LDIF_FILE $sbs_line;
    }
    
    print LDIF_FILE qq@#################################################################
# End of LDIF from $file   
#################################################################\n@;
    
    close(SBS_FILE);
  }
  close (LDIF_FILE);

}
  
################################################################
################################################################
## file extraction logic (recursively descend lst files)
################################################################
################################################################
sub get_sbs_files {
  local($lst_file) = @_;
  local(@sbs_files);
  local($meta_line);
  local($ldif_template_file);
  local * LST_FILE; ## scope the filehandle locally so that recursion works

  open(LST_FILE , $lst_file)  || die "cannot open file $lst_file : $!";
  
LST_LOOP:
  while($meta_line = <LST_FILE>) {
    chomp($meta_line); # get rid of newlines 
    $meta_line =~ s/^ *//; ## get rid of leading spaces on the line
    if($meta_line =~ /^#/) { #ignore comment lines (lines that begin with #)
      # print"comment line: $meta_line \n";
      next LST_LOOP;
    }
    # at this stage we know that we have a valid line 
    if ($meta_line =~ /\./) {
      ($ldif_template_file, $dummy) = split(/ /, $meta_line);
      # print "ldif template file: $ldif_template_file \n";
      if( $ldif_template_file =~ /\.lst/) { # if it is a lst file
        # print" this is a .lst file, so I am gonna search further in this \n";
        @sbs_files = (@sbs_files, get_sbs_files($ldif_template_file));
        # print "after search: @sbs_files \n";
      }
      else {
        @sbs_files = (@sbs_files , $ldif_template_file);
      }
#push(@ldif_templates, $ldif_template_file);
    }
  }
  close(LST_FILE);
#  print "returning: @sbs_files \n";
  return @sbs_files;
}

################################################################
################################################################
## main logic
################################################################
################################################################
# get the options
getopt("io");
if (!$opt_i || !$opt_o ) { # we require all four options 
 usage;
} 

$input_file = $opt_i;
$output_file = $opt_o;


#begin process
print "Input file: $input_file \n";
print "Output file: $output_file \n";

if ($input_file =~ /\.lst/) {
  @ldif_templates = get_sbs_files($input_file);
}
else {
  @ldif_templates = $input_file;
}
print "concatenating files: @ldif_templates \n\n";
&do_substitution($output_file, @ldif_templates);



