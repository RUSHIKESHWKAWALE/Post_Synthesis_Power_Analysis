#Name of top level design
set design(TOPLEVEL) "mul_adr"

set runtype "synthesis"

#load genus procedure
source ../scripts/procedures.tcl -quiet

set debug_file "debug_genus.txt"

#load defination and variables
source ../inputs/$design(TOPLEVEL).defines -quiet

#load setting
source ../scripts/settings.tcl -quiet

#load libraries
set_db library {*.lib} #add path to .lib files




###############################################################################
# Read RTL
###############################################################################
enics_start_stage "read_rtl"

set db_init_hdl_search_path $design(hdl_search_paths)
read_hdl -f $design(read_hdl_list)

###############################################################################
# Elaborate and Init Design
###############################################################################
# Elaborate
# ---------
enics_start_stage "elaborate"
elaborate $design(TOPLEVEL) ; # -update
dc::get_ports
current_design $design(TOPLEVEL)



# Check Design
# ------------
enics_start_stage "post_elaboration"
enics_message "Checking design post elaboration"
check_design -unresolved
check_design -all > $design(synthesis_reports)/post_elaboration/check_design_post_elab.rpt
if {[check_design -status]} {
  puts "ENICSINFO: ###################################################### There is an issue with check design. You better look at it! ######################################################"
}

# Init Design
# -----------
enics_message "Running init design in an MMMC flow"
init_design


# save elaborated design
# ----------------------
write_design -base_name $design(export_dir)/post_elaboration/$design(TOPLEVEL)

###############################################################################
# For physical synthesis
###############################################################################

# Optionally read floorplan
#gui

###############################################################################
# Synthesize
###############################################################################
enics_start_stage "synthesis"

# Define cost groups (reg2reg, in2reg, reg2out, in2out)
#
enics_default_cost_groups
# enics_report_timing $design(synthesis_reports)

# clock gating settings
#
# set_db [get_db design:$design(TOPLEVEL)] .lp_clock_gating_min_flops 8
# set_db [get_db design:$design(TOPLEVEL)] .lp_clock_gating_style latch

# Don't use scan cells
# ---------------------
# enics_message "Setting Don't Use on scan flip flops"
# foreach cell [get_db lib_cells -if {.scan_enable_pins!=""}] {set_db $cell .avoid true}
enics_message "Running optimization"


# Set Synthesis Efforts
# ----------------------
set_db syn_generic_effort medium      ; # low|medium|high|express
set_db syn_map_effort medium          ; # low|medium|high
set_db syn_opt_effort medium          ; # low|medium|high|extreme
set_db opt_spatial_effort standard ; # legacy|standard|extreme
set_db design_power_effort none    ; # none|low|high

enics_message "done optimization"


  # Synthesize to generics with square floorplan 0.7 utilization
  enics_start_stage "syn_generic"
  syn_generic 
  # -create_floorplan -physical
  # Map to technology
  enics_start_stage "technology_mapping"
  syn_map 
  #  -physical
  enics_report_timing $design(synthesis_reports)
  enics_start_stage "post_syn_opt"
  syn_opt 
  # -spatial


###############################################################################
# Post Synthesis Reports
###############################################################################
enics_report_timing $design(synthesis_reports)
set post_synth_reports [list \
  report_area \
  report_gates \
  report_power \
  report_hierarchy \
  report_design_rules \
  report_dp \
  report_qor \
]
foreach rpt $post_synth_reports {
  enics_message "$rpt" medium
  $rpt > $design(synthesis_reports)/$this_run(stage)/${rpt}.rpt
}

###############################################################################
# Exporting the Design
###############################################################################
enics_start_stage "export_design"

# Write out a database for loading in Innovus/Voltus/Tempus
# ---------------------------------------------------------
enics_message "Exporting the design Database to $design(postsyn_db_base_name)"
write_design -base_name $design(postsyn_db_base_name) -innovus -db

# Write out a netlist for simulation or Innovus
# ---------------------------------------------
enics_message "Writing the post synthesis netlist to $design(postsyn_netlist)"
write_netlist > $design(postsyn_netlist)

# Write out SDF for backannotation simulation
# ------------------------------------------
enics_message "Writing the post synthesis SDF"
mkdir -pv $design(export_dir)/post_synth
write_sdf > $design(postsyn_sdf)
# write_sdf -nonegchecks -edges check_edge -timescale ns -recrem split > $design(postsyn_sdf1)
# write_sdf -nonegchecks -edges check_edge -timescale ns -recrem split -setuphold split > $design(postsyn_sdf)
