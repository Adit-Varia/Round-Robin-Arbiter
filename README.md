# Round Robin Arbiter (4-Input) | Verilog HDL

A synthesizable **4-input Round Robin Arbiter** implemented in **Verilog HDL**. The design ensures **fair access** among multiple requesters by rotating the priority after every successful grant, preventing starvation commonly found in fixed-priority arbiters.

## Features

- 4 request inputs (`req[3:0]`)
- One-hot grant output (`grant[3:0]`)
- Fair Round Robin arbitration
- Rotating priority pointer
- Asynchronous active-high reset
- Fully synthesizable RTL
- Suitable for FPGA and ASIC implementations

---

## Architecture

```
                +------------------+
Request[3:0] -->|                  |
                | Search Logic     |
                | (Round Robin)    |
                |                  |
                +---------+--------+
                          |
                          v
                  +---------------+
                  | Grant Logic   |
                  +-------+-------+
                          |
                    Grant[3:0]
                          ^
                          |
                  +-------+-------+
                  | Priority      |
                  | Pointer       |
                  +---------------+
```

The arbiter maintains a **2-bit pointer** that stores the highest-priority requester. During each clock cycle, the search begins from the current pointer position and scans all request lines in a circular fashion. The first active request receives the grant, and the pointer advances to the next requester, ensuring fair allocation.

---

## Working Principle

On every rising edge of the clock:

1. Clear the previous grant.
2. Start searching from the current priority pointer.
3. Check all four request lines sequentially.
4. Grant the first active request encountered.
5. Update the pointer to the requester immediately after the granted requester.
6. If no requests are active, no grant is issued and the pointer remains unchanged.

---

## Example

| Clock Cycle | Requests | Pointer | Grant | Next Pointer |
|-------------|----------|---------|-------|--------------|
| 1 | 1111 | 0 | 0001 | 1 |
| 2 | 1111 | 1 | 0010 | 2 |
| 3 | 1111 | 2 | 0100 | 3 |
| 4 | 1111 | 3 | 1000 | 0 |

This rotation guarantees that every requester eventually receives service.

---

## Module Interface

```verilog
module round_robin_arbiter (
    input              clk,
    input              rst,
    input      [3:0]   req,
    output reg [3:0]   grant
);
```

### Inputs

| Signal | Width | Description |
|--------|------:|-------------|
| `clk` | 1 | System clock |
| `rst` | 1 | Asynchronous active-high reset |
| `req` | 4 | Request inputs |

### Outputs

| Signal | Width | Description |
|--------|------:|-------------|
| `grant` | 4 | One-hot grant output |

---

## Applications

- Bus Arbitration
- Shared Memory Controllers
- AXI/AHB Bus Masters
- Network-on-Chip (NoC)
- DMA Controllers
- Multi-Core Resource Sharing
- Communication Interfaces

---

## Advantages

- Fair resource allocation
- Prevents starvation
- Simple hardware implementation
- Low area overhead
- Easy to extend for larger arbiters

---

## Future Improvements

- Parameterizable number of requesters
- Weighted Round Robin arbitration
- Lock/Hold support
- Dynamic priority updates
- Pipelined implementation for high-speed designs

---

## Author

**Adit Varia**

If you found this project useful, consider giving it a ⭐ on GitHub.
