Name: Zhou Lu, Shuyi Jin
NetID: zl438,sj445

Design Description
This Verilog module describes a simplified processor designed to execute basic arithmetic and logical operations, featuring an ALU, control logic, and supporting structures outlined in a skeleton architecture.

Processor Architecture
The design leverages modular components to ensure flexibility and ease of expansion:

Arithmetic Logic Unit (ALU): Handles core arithmetic and logic tasks, including addition, subtraction, and bitwise operations based on control signals.
Control Unit: Governs operation selection by interpreting control codes to produce the corresponding outputs.
Registers and Storage: Temporary storage is provided by internal registers that are updated on each clock cycle to store intermediate results and state information.
Skeleton Structure: The architecture follows a skeletal structure, with specific modules connecting through well-defined ports, allowing the modular addition of new features.
ALU Operation Control
The ALU uses operation codes to select the required function. The control logic handles switching between different types of arithmetic and logical tasks:

Operand Selection: Operand values are chosen based on the operation type, with mechanisms to modify values as needed (e.g., complementing for subtraction).
Control Code Mapping: Control codes determine specific ALU functions, allowing dynamic modification of operands and directing outputs accordingly.
Overflow Detection
Overflow detection for addition and subtraction operations ensures accurate arithmetic under various conditions:

Addition/Subtraction Overflow: Overflow is checked by analyzing the sign bits of operands and the result, identifying conditions where the result exceeds the expected range.
Logic Implementation: XOR and XNOR gates are used to detect overflow conditions based on input signs.
Status Flags: Overflow flags and other relevant status indicators are set, allowing conditional logic or branching based on these outcomes.
Skeleton-Specific Features
This design includes specific components introduced through a skeleton structure:

Modularity: The skeleton’s modular approach allows for organized connections between processor components, making it easy to isolate and test individual sections.
Expandability: With well-defined interfaces, new features and operations can be added without altering the entire architecture.
Debugging Ease: The skeleton architecture aids debugging by providing isolated testing points for each module.