# Project 3

 - Shuyi Jin
 - sj445
 - Regfile project

## Overall  Text Description

This project implements a register file, a crucial component in digital systems that stores data for processing. The first Regfile module has a clock, reset control, and enable signals to facilitate writing and reading from registers. It consists of 32 registers (each 32 bits wide), with a dedicated register (register 0) always holding the value zero.

Upon a write operation, the `ctrl_writeEnable` signal allows data from `data_writeReg` to be stored in the selected register, indicated by `ctrl_writeReg`. The writing process uses a D flip-flop structure, ensuring data integrity with clock synchronization and reset functionality.

To read data, the module decodes the register indices from `ctrl_readRegA` and `ctrl_readRegB`, and based on the decoded signals, it outputs the corresponding register values through `data_readRegA` and `data_readRegB`. The tri-state logic is used during reading to prevent conflicts when multiple registers could drive the output. Overall, the module effectively manages simultaneous read and write operations in a controlled manner, leveraging combinational and sequential logic to achieve its functionality.

The `dffe_ref` module is a D flip-flop with enable and clear functionalities, designed to store a 32-bit data input (`d`). It operates on the rising edge of a clock signal (`clk`) and features a clear signal (`clr`) to reset the output register (`q`) to zero when asserted. Initially, `q` is set to zero. During operation, if `clr` is high, `q` is reset; otherwise, if the enable signal (`enable`) is active, the value of `d` is loaded into `q`. This design allows for controlled data storage, enabling both synchronous data retention and immediate resetting, making it useful for various digital applications.

The `bitChecker` module generates a 32-bit output based on a 5-bit control signal and an enable signal. It initializes a 32-bit wire by concatenating 31 zeros with the enable signal, positioning the active bit at the least significant position. The module then uses conditional shifts for each bit of the control signal, shifting the output left by varying amounts (1, 2, 4, 8, or 16 bits) depending on which control bits are set. This design allows for dynamic manipulation of the bit position within the output, making it suitable for applications that require flexible bit positioning.











