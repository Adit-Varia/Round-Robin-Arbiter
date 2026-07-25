# 4-Input Round Robin Arbiter (Verilog)

## Overview

This project implements a **4-input Round Robin Arbiter** in Verilog HDL. The arbiter grants access to one requester at a time while ensuring fairness by rotating the priority after every successful grant. This prevents starvation and guarantees that all requesters eventually receive service.

The design is suitable for FPGA and ASIC digital systems where multiple masters compete for a shared resource such as a bus, memory, or peripheral.

---

## Features

- 4 request inputs
- Single grant output
- Fair Round Robin arbitration
- Rotating priority pointer
- Starvation-free scheduling
- Synchronous RTL implementation
- Synthesizable Verilog design

---

## Specifications

| Parameter | Value |
|-----------|-------|
| Number of Requesters | 4 |
| Arbitration Policy | Round Robin |
| Clock Domains | 1 |
| Grant Type | One-Hot |
| Fairness | Starvation-Free |

---

## Block Diagram

```
             +-------------------------+
req[3:0] --->|                         |
             |   Round Robin Arbiter   |-----> grant[3:0]
 clk ------->|                         |
 rst ------->|                         |
             +-------------------------+
                     |
                     |
                Priority Pointer
```

---

## Working Principle

The arbiter continuously monitors all request lines.

When one or more requests are active:

1. Arbitration begins from the current priority pointer.
2. Requesters are checked in circular order.
3. The first active requester receives the grant.
4. The priority pointer moves to the next requester.
5. Arbitration repeats in the next clock cycle.

This rotation ensures that no requester can permanently block others.

---

## Priority Rotation Example

Assume all requesters continuously request access.

| Clock Cycle | Priority Starts At | Granted | Next Priority |
|-------------|-------------------|----------|---------------|
| 1 | 0 | Request 0 | 1 |
| 2 | 1 | Request 1 | 2 |
| 3 | 2 | Request 2 | 3 |
| 4 | 3 | Request 3 | 0 |
| 5 | 0 | Request 0 | 1 |

Grant order:

```
0 → 1 → 2 → 3 → 0 → ...
```

---

## Arbitration Example

Requests

```
req = 1011
```

which means

```
Requester 3 : Active
Requester 2 : Inactive
Requester 1 : Active
Requester 0 : Active
```

If the priority pointer is **2**, the search order becomes

```
2 → 3 → 0 → 1
```

Since requester **3** is the first active request encountered,

```
grant = 1000
```

The priority pointer is then updated to **0**.

---

## Project Structure

```
.
├── arbiter.v          # RTL implementation
├── arbiter_tb.v       # Testbench
├── README.md
```

---

## Simulation

Example using ModelSim

```bash
vlog arbiter.v arbiter_tb.v
vsim arbiter_tb
run -all
```

Example using Vivado Simulator

```bash
xvlog arbiter.v arbiter_tb.v
xelab arbiter_tb
xsim arbiter_tb
```

---

## Applications

- AMBA AXI Bus Arbitration
- AHB Bus Arbitration
- NoC Routers
- Shared Memory Controllers
- DMA Controllers
- Multi-Core Processor Interconnects
- Cache Controllers
- Resource Scheduling in FPGA/ASIC Designs

---

## Future Improvements

- Parameterizable number of requesters
- Locked transactions
- Weighted Round Robin arbitration
- Dynamic priority selection
- Parking support
- Grant valid signal
- Timeout and starvation monitoring
- SystemVerilog assertions for verification

---

## Author

Developed as part of RTL Design and Digital System Design practice using Verilog HDL.
