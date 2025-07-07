

set design(TOPLEVEL) "mul_adr"
set debug_file "debug.voltus.txt"
set runtype "power"

source ../scripts/procedures.tcl -quiet


# read in the project defination/variables
source ../inputs/$design(TOPLEVEL).defines -quiet



read_db $design(postsyn_db)

set_db power_method static
set_db power_report_missing_nets true

read_activity_file -reset
read_activity_file -format VCD -scope "$design(tb_name).$design(dut_name)" -start  $design(power_report_start_time) -end $design(power_report_end_time) $design(vcd_file)

report_power -rail_analysis_format VS -out_file "$design(reports_dir)/power/$design(TOPLEVEL).rpt"

