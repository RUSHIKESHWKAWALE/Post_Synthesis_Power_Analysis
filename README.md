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
* `Cadence Innovus` for Placement and Routing
* `Cadence Incisive` simulator for behavioural, post synthesis and post P&R simulation
* `Cadence Voltus` for Power analysis  
* Standard cell library PDK
* Verilog files and testbench

### Flow

1. **Add standard cell library:**
   Add .lib path of standard cell PDK in [Synthesis](./mul_adr/scripts/genus.tcl#L18) script.
   ```tcl
   set_db library {*.lib} #add path to .lib files
   ```

3. **Testbench**
