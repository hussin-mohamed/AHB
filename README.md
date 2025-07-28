# AHB-Lite Bus

The AMBA AHB-Lite is a simplified version of the AMBA AHB protocol. It is designed for single-master systems, reducing complexity while retaining the high-performance features of AHB.
In AHB-Lite, the single master controls all transactions, and slaves respond accordingly. This makes it ideal for microcontrollers and embedded systems where only one master (usually the CPU) is present.

Key Features
Single Master Architecture: Simplifies design by removing arbitration logic.

High Performance: Supports pipelined operations and burst transfers.

Low Complexity: Fewer control signals compared to full AHB.

Standardized Interface: Compatible with AMBA specifications.

Signal Lines
HADDR – Address bus from master to slave

HWDATA / HRDATA – Write / Read data lines

HWRITE – Indicates transfer direction (write/read)

HSIZE – Transfer size (byte, half-word, word)

HTRANS – Transfer type (IDLE, NONSEQ, SEQ)

HREADY – Indicates transfer completion and ready state

HRESP – Slave response (OKAY or ERROR)

HCLK – System clock

HRESETn – Active-low reset

Communication Process
Address Phase: Master places address, control, and write data (for writes).

Data Phase: Slave drives read data or accepts write data.

Response: Slave signals readiness and status through HREADY and HRESP.

Advantages
✅ Simple Implementation (no arbitration required)

✅ High Throughput with pipelining

✅ Low Hardware Overhead

Disadvantages
❌ Only One Master supported

❌ No Parallel Master Transactions

## architecture

<img width="521" height="271" alt="image" src="https://github.com/user-attachments/assets/abd25dc4-ca8f-4611-8800-f43e4dbc39a1" />

## state diagram 

<img width="726" height="979" alt="fsm" src="https://github.com/user-attachments/assets/e405da3f-f9cf-4818-ac3f-79991b97dcf7" />

