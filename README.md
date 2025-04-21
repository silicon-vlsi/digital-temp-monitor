This is a repository which can be use a starting point to dsign and implement the [Digital Temperature Monitor](https://github.com/silicon-efabless/tt06-silicon-tinytapeout-lm07).

# Project Description

![Block Diagram](docs/tt06-blockdiag.png)

- **PRE-REQUISITES**
  - Install **Ubuntu 24.04** (22.04 is fine too) on **WSL2**. [See instructions here](https://github.com/silicon-vlsi-org/eda-wsl2)
  - Create a [GitHub](https://github.com) account if you don't have one already.
- Create a fork of this repo and clone it on your WSL Linux.
- Check [LM70 Datasheet](docs/datasheet-LM70-TI-tempSensor.pdf)
  - Check the basic electrical characteristics: Supply voltage range, temperature range, temperature resolution and accuracy, timing diagram (p-6), temperature data format (p-10).
- Run the template code which has the DUT module and the model of the LM07 connected.
- Start the blocks:
  - Design a **5-b counter**. Use **DEFINES** for the value for reset (eg. **RST_COUNT**) and maximum count (eg. **MAX_COUNT**)
  - Design **3-state (IDLE, READ, LATCH)**  such that:
    - At _reset_ : **IDLE**
    - During read: **READ**
    - During latch: *LATCH*
