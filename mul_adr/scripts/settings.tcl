###############################################################################
# General Genus Settings
###############################################################################
set_db source_verbose true ; # Sourcing files will be verbose

# Attributes that only Genus understands...
if {$runtype=="synthesis"} {
  set_db information_level 9 ; # The log file will be verbose
  # set_db hdl_track_filename_row_col true -quiet;
  set_db hdl_language v2001 -quiet
  set_db lp_insert_clock_gating true
  set_db detailed_sdc_messages true ;
  # helps read sdc messages
}
#################

