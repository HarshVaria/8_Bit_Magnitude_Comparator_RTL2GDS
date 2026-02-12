# RTL-to-GDSII Implementation of 8-bit Magnitude Comparator

> Complete ASIC physical design flow using **Synopsys EDA toolchain** on **SAED 32nm** technology node

---

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Tool Flow](#tool-flow)
- [Tools & Technology](#tools--technology)
- [RTL Design](#1-rtl-design)
- [Functional Simulation](#2-functional-simulation)
- [Synthesis](#3-synthesis)
- [Floorplanning](#4-floorplanning)
- [Power Planning](#5-power-planning)
- [Placement](#6-placement)
- [Clock Tree Synthesis](#7-clock-tree-synthesis)
- [Routing](#8-routing)
- [Static Timing Analysis](#9-static-timing-analysis)
- [Results Summary](#results-summary)
- [Directory Structure](#directory-structure)
- [How to Run](#how-to-run)
- [References](#references)
- [Author](#author)

---

## Overview

This project implements the complete **RTL-to-GDSII** physical design flow for an **8-bit Magnitude Comparator** with registered outputs. The design compares two 8-bit unsigned inputs and produces three single-bit registered outputs indicating whether the first input is greater than, less than, or equal to the second.

The implementation uses an optimized **XNOR-based MSB-priority cascaded architecture** for area and timing efficiency.

---

## Architecture

```
     a[7:0]              b[7:0]
       │                    │
       ▼                    ▼
┌────────────────────────────────┐
│   XNOR Gate Array (x8)         │
│ xnor_bits[i] = ~(a[i]^b[i])    │
└──────┬─────────┬─────────┬────┘
       │         │         │
       ▼         ▼         ▼
┌──────────┐ ┌────────┐ ┌────────┐
│ EQUALITY │ │GREATER │ │  LESS  │
│ &xnor    │ │  THAN  │ │  THAN  │
│  _bits   │ │MSB-1st │ │MSB-1st │
│          │ │cascade │ │cascade │
└────┬─────┘ └───┬────┘ └───┬────┘
     │           │           │
     ▼           ▼           ▼
┌─────────────────────────────────┐
│   D Flip-Flops (posedge clk)    │
└────┬───────────┬───────────┬────┘
     ▼           ▼           ▼
   equal      greater       less
```

### Key Design Features

- **XNOR-based comparison**: Reuses XNOR bits across all three output computations
- **MSB-priority cascade**: Determines magnitude from most significant bit downward
- **Registered outputs**: All outputs are clocked for clean timing and pipelined integration
- **Generate block**: Parameterizable XNOR array using Verilog `generate`

---

## Tool Flow

```
┌──────────────┐
│   RTL Design │  Verilog HDL
│ (Comparator) │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Simulation  │  Synopsys VCS + Verdi
│  & Verify    │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Synthesis   │  Synopsys Design Compiler
│  (Gate-level)│
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Floorplan   │
├──────────────┤
│  Power Plan  │
├──────────────┤  Synopsys IC Compiler II
│  Placement   │
├──────────────┤
│     CTS      │
├──────────────┤
│   Routing    │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│    STA       │  Synopsys PrimeTime
│  (Sign-off)  │
└──────────────┘
```

---

## Tools & Technology

| Category | Detail |
|----------|--------|
| **HDL** | Verilog |
| **Simulation** | Synopsys VCS |
| **Waveform Viewer** | Synopsys Verdi |
| **Synthesis** | Synopsys Design Compiler (DC) |
| **Physical Design** | Synopsys IC Compiler II (ICC2) |
| **STA** | Synopsys PrimeTime (PT) |
| **PDK** | SAED 32nm Educational PDK |
| **Cell Library** | `saed32rvt` (Regular Vt) |
| **Metal Stack** | 1 Poly, 9 Metal layers (1P9M) |
| **Operating Condition** | TT corner, 0.78V, -40°C |

---

## 1. RTL Design

The comparator is implemented in `rtl/comparator_8bit_clk.v` with the following I/O specification:

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `clk` | Input | 1 | System clock |
| `a` | Input | 8 | First operand |
| `b` | Input | 8 | Second operand |
| `equal` | Output | 1 | High when a == b |
| `greater` | Output | 1 | High when a > b |
| `less` | Output | 1 | High when a < b |

<details>
<summary>📄 Click to view RTL source code</summary>

```verilog
module comparator_8bit_clk (
    input  wire        clk,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg         equal,
    output reg         greater,
    output reg         less
);

wire [7:0] xnor_bits;

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : xnor_loop
        assign xnor_bits[i] = ~(a[i] ^ b[i]);
    end
endgenerate

wire eq_wire = &xnor_bits;

wire gt_wire = (a[7] & ~b[7]) |
               ( xnor_bits[7] & (a[6] & ~b[6]) ) |
               ( &xnor_bits[7:6] & (a[5] & ~b[5]) ) |
               ( &xnor_bits[7:5] & (a[4] & ~b[4]) ) |
               ( &xnor_bits[7:4] & (a[3] & ~b[3]) ) |
               ( &xnor_bits[7:3] & (a[2] & ~b[2]) ) |
               ( &xnor_bits[7:2] & (a[1] & ~b[1]) ) |
               ( &xnor_bits[7:1] & (a[0] & ~b[0]) );

wire lt_wire = (~a[7] & b[7]) |
               ( xnor_bits[7] & (~a[6] & b[6]) ) |
               ( &xnor_bits[7:6] & (~a[5] & b[5]) ) |
               ( &xnor_bits[7:5] & (~a[4] & b[4]) ) |
               ( &xnor_bits[7:4] & (~a[3] & b[3]) ) |
               ( &xnor_bits[7:3] & (~a[2] & b[2]) ) |
               ( &xnor_bits[7:2] & (~a[1] & b[1]) ) |
               ( &xnor_bits[7:1] & (~a[0] & b[0]) );

always @(posedge clk) begin
    equal   <= eq_wire;
    greater <= gt_wire;
    less    <= lt_wire;
end

endmodule
```

</details>

---

## 2. Functional Simulation

RTL simulation performed using **Synopsys VCS** with waveform analysis in **Synopsys Verdi**.

![Simulation Waveform](https://github.com/user-attachments/assets/b156a854-341a-43d8-b3d4-ba8ae6626434)

**Testbench Strategy:**
- Exhaustive corner cases: `a == b`, `a > b`, `a < b`
- Boundary values: `8'h00`, `8'hFF`
- Verified all three outputs for each test vector

---

## 3. Synthesis

Gate-level synthesis performed using **Synopsys Design Compiler**.

![Synthesis Schematic](https://github.com/user-attachments/assets/4cf81b99-0e8a-43c1-805b-ce48a99e8767)

**Pre-layout Timing Report (Design Compiler):**

| Metric | Value |
|--------|-------|
| Data Arrival Time | -2.59 ns |
| Data Required Time | 2.85 ns |
| Slack | 0.26 ns |

---

## 4. Floorplanning

Die area and core dimensions defined in **ICC2**.

![Floorplan](https://github.com/user-attachments/assets/c80c8ac0-f2ae-4bc3-aae1-e15363760417)

---

## 5. Power Planning

Power grid (VDD/VSS rings and straps) created for uniform IR drop distribution.

![Power Plan](https://github.com/user-attachments/assets/886a75da-d46a-4b16-b950-aeab8f6bd1b2)

---

## 6. Placement

Standard cell placement with legalization performed in **ICC2**.

![Placement](https://github.com/user-attachments/assets/a15a611c-906c-4b63-8415-d7a27f17129b)

---

## 7. Clock Tree Synthesis

CTS performed with Concurrent Clock and Data (CCD) optimization in **ICC2**.

![CTS](https://github.com/user-attachments/assets/7164931d-9197-4e86-b839-2f2f7326ac9b)

| CTS Metric | Value |
|------------|-------|
| Clock Skew | *update from report* |
| Clock Latency | *update from report* |
| Buffer Count | *update from report* |

---

## 8. Routing

Routing completed using **ICC2 ZRoute** engine.

**Post-Route Timing Report (ICC2):**

![Routing Timing](https://github.com/user-attachments/assets/92388eb2-f32c-48ff-86ab-7c99cd7813b5)

| Metric | Value |
|--------|-------|
| Slack | 0.95 ns |

**Post-Route QoR Summary (ICC2):**

![QoR Summary](https://github.com/user-attachments/assets/ec2defdf-dbb7-46ec-9d75-b93a1df0843f)

| Metric | Value |
|--------|-------|
| Total Cell Area | 154.26 µm² |
| Cell Count | 75 |
| DRC Violations | 0 |

---

## 9. Static Timing Analysis

Final timing sign-off performed using **Synopsys PrimeTime**.

![Timing Report](https://github.com/user-attachments/assets/3ff81cd6-8bbc-492b-bcdb-6218a38849d7)

| Timing Metric | Value |
|---------------|-------|
| WNS (Setup) | +0.95 ns |

✅ **Timing closure achieved** — all setup and hold checks passed with positive slack.

---

## Results Summary

| Stage | Tool | Status |
|-------|------|--------|
| RTL Design | Verilog | ✅ Complete |
| Functional Verification | VCS + Verdi | ✅ All tests passed |
| Logic Synthesis | Design Compiler | ✅ Mapped netlist generated |
| Floorplanning | IC Compiler II | ✅ Die area defined |
| Power Planning | IC Compiler II | ✅ Power grid created |
| Placement | IC Compiler II | ✅ Cells placed & legalized |
| CTS | IC Compiler II (CCD) | ✅ Clock tree balanced |
| Routing | IC Compiler II | ✅ Routed with no DRC |
| STA Sign-off | PrimeTime | ✅ Timing closure achieved |

---

## Directory Structure

```
.
├── CONSTRAINTS/
│   └── comparator.sdc              # SDC timing constraints
│
├── DC/                             # Design Compiler (Synthesis)
│   ├── run_dc.tcl                  # Main synthesis script
│   ├── alib-52/                    # Compiled library cache
│   ├── reports/                    # Synthesis reports
│   ├── results/
│   │   └── comparator_8bit_clk.mapped.v  # Gate-level netlist
│   ├── rm_setup/                   # Reference methodology setup
│   │   ├── common_setup.tcl
│   │   ├── dc_setup.tcl
│   │   └── dc_setup_filenames.tcl
│   └── WORK/                       # DC working directory
│
├── ICCII/                          # IC Compiler II (Physical Design)
│   ├── COMPARATOR_LIB/             # Design library (NDM format)
│   │   ├── comparator/             # Main design
│   │   └── comparator_8bit_floorplan/
│   ├── LIB_9/                      # Technology library (1P9M)
│   │   ├── lib.ndm
│   │   ├── tech_parasitic.ndm
│   │   └── [design blocks]/
│   ├── legalizer_debug_plots/      # Placement debug outputs
│   ├── reports/                    # PnR reports
│   ├── results/
│   │   ├── comparator.routed.v     # Final routed netlist
│   │   └── comparator.routed.sdc   # Back-annotated constraints
│   └── scripts/
│       ├── floorplan.tcl
│       ├── power_planning.tcl
│       ├── placement.tcl
│       ├── clock.tcl               # CTS script
│       └── route.tcl
│
├── PT/                             # PrimeTime (STA)
│   ├── reports/
│   │   ├── analysis_coverage/
│   │   ├── check_timing/
│   │   ├── clock/
│   │   └── timing/                 # Timing reports
│   └── scripts/
│       ├── run_pt_p1.tcl
│       └── run_pt_p2.tcl
│
├── ref/                            # Reference files (PDK)
│   ├── lib/
│   │   ├── ndm/
│   │   │   └── saed32rvt_c.ndm
│   │   └── stdcell_rvt/
│   │       ├── saed32rvt_ff1p16v125c.db
│   │       ├── saed32rvt_ss0p7vn40c.db
│   │       ├── saed32rvt_tt0p78vn40c.db
│   │       └── *.lib
│   └── tech/
│       ├── milkyway/
│       │   └── saed32nm_1p9m_mw.tf
│       └── star_rcxt/
│           ├── saed32nm_1p9m_Cmax.tluplus
│           ├── saed32nm_1p9m_Cmin.tluplus
│           └── saed32nm_tf_itf_tluplus.map
│
├── rtl/                            # RTL Design
│   ├── comparator_rtl.v            # Main RTL source
│   ├── comparator_tb.v             # Testbench
│   └── simv                        # Compiled simulation binary
│
├── rtl_simulation/                 # Simulation workspace
│   ├── comparator_rtl.v
│   ├── comparator_tb.v
│   ├── comparator_wave.vcd         # Waveform dump
│   ├── novas.fsdb                  # Verdi waveform database
│   ├── simv                        # VCS compiled executable
│   └── verdiLog/                   # Verdi logs
│
└── WORK/                           # Additional working directory
    ├── comparator_rtl.v
    ├── comparator_tb.v
    ├── reports/
    └── results/
```

---

## How to Run

⚠️ **Requires Synopsys EDA tools (licensed) and SAED 32nm PDK**

### 1. RTL Simulation

```bash
cd rtl/
vcs -full64 -debug_access+all comparator_8bit_clk.v comparator_tb.v -o simv
./simv
verdi -ssf novas.fsdb &
```

### 2. Synthesis

```bash
cd DC/
dc_shell -topographical_mode -f run_dc.tcl | tee dc.log
```

### 3. Physical Design (ICC2)

```bash
cd ICCII/scripts/
icc2_shell -f floorplan.tcl
icc2_shell -f power_planning.tcl
icc2_shell -f placement.tcl
icc2_shell -f clock.tcl
icc2_shell -f route.tcl
```

### 4. Static Timing Analysis

```bash
cd PT/scripts/
pt_shell -f run_pt_p1.tcl
pt_shell -f run_pt_p2.tcl
```

---

## References

- [Synopsys SAED 32nm Educational PDK Documentation](https://www.synopsys.com/)
- Synopsys Design Compiler User Guide
- Synopsys IC Compiler II User Guide
- Synopsys PrimeTime User Guide

---

## Author

**Harsh**  
📅 June 2025

---

> **Note:** The SAED 32nm PDK and Synopsys tool outputs are subject to Synopsys licensing terms and cannot be redistributed.
