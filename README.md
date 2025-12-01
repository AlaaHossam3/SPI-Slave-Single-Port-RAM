# SPI Slave with Single Port RAM

## Project Description
This project implements an SPI Slave interface connected to a Single Port RAM. The design utilizes a Finite State Machine (FSM) to handle data transaction and memory operations. A key focus of this project was timing optimization; the FSM was synthesized using three different encodings (Gray, One-Hot, and Sequential) to determine the highest operating frequency.

## Key Features
* **Core Logic:** SPI Slave Protocol & Single Port RAM.
* **Reset:** Synchronous active low reset.
* **Verification:** Verified via directed testbench in **QuestaSim**.

## Tools Used
* **Simulation:** QuestaSim
* **Synthesis & Implementation:** Xilinx Vivado
