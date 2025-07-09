# Power Synthesis Power Analysis
---

## 🌟 About the Project

This includes the script to perform the power analysis of partial switching circuit of synthesised design.  
 
---



## 🚀 Getting Started

Instructions on how to set up and run the project locally.

### Prerequisites

List any software, libraries, or tools users need to have installed before setting up your project.
Following are the requirements to run the project.
* `Cadence Genus` for synthesis 
* `Cadence Incisive` simulator for behavioural, post-synthesis and post-P&R simulation
* `Cadence Voltus` for Power analysis  
* Standard cell library PDK
* Verilog files and testbench

### Set Enviornment
1. **Clone the repository:**
    ```bash
    git clone https://github.com/RUSHIKESHWKAWALE/Post_Synthesis_Power_Analysis.git
2. **set Directory**
   Update the root folder name with the top-level Design name.
   For example, `mul_adr` is a top-level design.
   Change the current directory 
   ```bash
   cd mul_adr
   ```
### Preparation

1. **Add standard cell library:**
   Add  `.lib` path of the standard cell PDK in [Synthesis](./mul_adr/scripts/genus.tcl#L18) script.
   ```tcl
   set_db library {*.lib} #add path to .lib files
   ```
3. **Add design:**
   Add all design files in the [vfiles](./mul_adr/sourcecode/vfiles) folder.  
5. **Prepare Testbench:**
   Prepare a testbench for the top module and save as `$design(TOPLEVEL)_tb_ps.v` file in [testbench](./mul_adr/sourcecode/tb) directory.
   In this testbench, the inputs to the module that will not be switched should be constant.
   In the provided example, the inputs to the multiplier are constant, and the adder inputs are switching.
6. **Update Source list:**
   
   * Update [dut_src_lst](mul_adr/sourcecode/dut_src_lst.txt) with all Verilog file paths for synthsis.
   * Update [dut_src_list_glv_sdf](mul_adr/sourcecode/dut_src_list_glv_sdf.txt) with all Verilog  and testbench file paths.
   * Also, add standard cell Verilog file path in [dut_src_list_glv_sdf](mul_adr/sourcecode/dut_src_list_glv_sdf.txt) file.
   * Update the sdf file path in [irun_sdf_bk](mul_adr/scripts/irun_sdf_bk.glv) file.
   * Add license and source path for cadence tools in [genus_ru.sh](mul_adr/workspace/genus_ru.sh), [irun_ru.sh](mul_adr/workspace/irun_ru.sh) and [voltus_ru.sh](mul_adr/workspace/voltus_ru.sh).
8. **Define Top-level design:**
   Replace the top module name `design(TOPLEVEL)` in the following files:
   * [genus.tcl](./mul_adr/scripts/genus.tcl)
   * [backannotation.tcl](./mul_adr/scripts/backannotation.tcl)
   * [voltus.tcl](./mul_adr/scripts/voltus.tcl)
10. **Rename files**
    * Rename [mul_adr.defines](mul_adr/inputs/mul_adr.defines) to `design(TOPLEVEL).defines`.
    * Rename [mul_adr.vcd](mul_adr/export/post_sim/mul_adr.vcd) to `design(TOPLEVEL).vcd`.
### Flow
Set the workspace as the current directory
```bash
cd workspace
```
1. **Run Synthesis:**
   * Launch genus in stylus mode and run the command given in [genus.tcl](./mul_adr/scripts/genus.tcl) or run:
   ```bash
   ./genus_ru.sh
   ```
3. **Generate VCD file**
   * VCD file is generated from gate level simulation using `Cadence Incisive` by running below command:
   ```bash
   ./irun_ru.sh
   ```
   * To use `Cadence Xelium` change `irun` to `xrun` in  [irun_ru.sh](mul_adr/workspace/irun_ru.sh) file.
   * If sufficient testcases are not covered, change the simulation time in [mul_adr.defines](mul_adr/inputs/mul_adr.defines#L107-L109) file.
5. **Run power analysis**
  * Launch Voltus in stylus mode and run the command given in [voltus.tcl](./mul_adr/scripts/voltus.tcl) or run:
   ```bash
   ./voltus_ru.sh
   ```
* It will generate a power in  `../report/power` directory. 
