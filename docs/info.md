<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works
A tapped-delay-line (TDL) time-to-digial-converter (TDC) is a circuit that drives a pulse through a delay line to capture measurements of propagation delay. Sending a pulse through the delay line and subsequently capturing the state of the delay line with a fixed phase offset from the input pulse allows for a thermometer-encoded measure of propagation delay. In the ideal case, this delay would be constant. However, supply noise, dynamic IR drop, temperature fluctuations, and clock jitter can make these measurements fluctuate. The number of transitioned bits in the thermometer code can be computed by counting the number of ones for a more compact representation of the propagation delay.

TDL TDCs present a wide range of security use-cases for both attacks and mitigations. For example, measurements of  propagation delay fluctuations can be used by an adversary to infer activity (i.e. power side-channel). FPGAs can be configured to implement TDL TDCs and this has led to the study of TDL TDCs for use in multi-tenant FPGA side-channel attacks. Unfortunately, the exact architecture of the FPGA, and therefore the path used for propagation measurement is unknown, limiting the depth of study.

In this project, we implement one of many possible TDL TDCs using standard cells. We use simple ripple-carry adder standard cells and a set of macro placement commands to construct a relatively uniform delay line using the Tiny Tapeout flow. We allow the user to either drive a pulse from an internal register or from an external source. We expose two clock inputs, capture and launch so that a user equiped with an FPGA or another test instrument can tune the phase shift between the pulse generator domain (```clk_launch```) and the capture register domain (```clk_capture```).

| Direction | Signal      | Purpose                                  |
| --------- | ----------- | ---------------------------------------- |
| Input     | clk_launch  | Launch clock (pulse generator domain)    |
| Input     | clk_capture | Capture clock (capture register domain)  |
| Input     | rst         | Reset                                    |
| Input     | en          | Enable                                   |
| Input     | val_in      | Valid in, design is always ready         |
| Input     | pg_src      | Input pulse select (see next table)      |
| Input     | pg_bypass   | Register bypass (see next table)         |
| Input     | pg_in       | Static input (see next table)            |
| Input     | pg_tog      | Constant toggling input (see next table) |
| Output    | hw          | Output ones count                        |
| Output    | val_out     | Valid out                                |

The pulse generator configuration details are shown below. A user is responsible for providing a toggling input, synchronized to the launch clock, to the ```pg_tog``` input pin. This input can be generated from a simple counter, and we reccommend keeping the counter running for the duration of use. To apply something other than a pulse to the TDL, the ```pg_in``` pin can be used. ```pg_src``` is used to select between the toggling input and the user input. Sync resisters are included in the design but may be bypassed using the ```pg_bypass``` input.

| Input     | Configuration Details |
| --------- | ------------------------------------------ |
| pg_src    | 0 - user-defined input, 1 - toggling input |
| pg_bypass | 0 - input is forward to sync registers, 1 - input is driven directly to the TDL |
| pg_in     | User input |
| pg_tog    | Constant toggling input |

## How to test

Setup VCS on you local machine, cd to test run:
```make SIM=vcs GATES=yes```

## External hardware

To operate the design, two phase-shifted clock inputs should be applied to the capture and launch clock inputs along with a toggle input synchronized to the launch clock domain. To maintain regularity of measurements, we recommend keeping the toggle input running at all times, and switching to a constant using ```pg_src``` if another input to the TDL is desired.

We intend to use an FPGA to apply all inputs and capture responses. PLL IPs with programmable phase-shift capabilities may be used to calibrate the capture and/or launch clock phases.
