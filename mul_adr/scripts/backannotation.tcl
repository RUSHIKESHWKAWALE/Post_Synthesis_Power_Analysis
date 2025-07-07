
set design(TOPLEVEL) "mul_adr"
set debug_file "debug.irun.txt"
set design(power_report_start_time) 0
#set design(power_report_end_time) 0
set design(power_report_end_time) "6000000000ps"

# read in the project defination/variables
source ../inputs/$design(TOPLEVEL).defines


# open waveform and add relevant signals to the waveform
set w [simvision waveform new]
simvision scope set $design(tb_name)
simvision waveform add -using "Waveform 1" -signals "$design(tb_name).$design(dut_name)" -depth 2

database -open $design(vcd_file) -vcd

probe -create "$design(tb_name).$design(dut_name)" -vcd -all -database $design(vcd_file) -depth 9
# the vcd probe will continue untill the end of the simulation

simvision simcontrol run -time 1


#dumptcf -end
simvision window geometry Console 1336x500+10+700
simvision window geometry "Design Browser 1" 1336x500+10+700
simvision window geometry "Waveform 1" 1336x400+10+25
simvision waveform xview limits 0 $design(power_report_end_time)


reset 
puts "The simulation will run from $design(power_report_start_time) to $design(power_report_end_time)"
simvision simcontrol run -time $design(power_report_end_time)

#exit
