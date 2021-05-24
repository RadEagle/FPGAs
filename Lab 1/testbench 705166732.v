`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:13:11 01/24/2021
// Design Name:   FPCTV
// Module Name:   /home/ise/lab1/FPCTV/testbench705166732.v
// Project Name:  FPCTV
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FPCTV
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench705166732;

	// Inputs
	reg [12:0] D;

	// Outputs
	wire S;
	wire [2:0] E;
	wire [4:0] F;

	// Instantiate the Unit Under Test (UUT)
	FPCTV uut (
		.D(D), 
		.S(S), 
		.E(E), 
		.F(F)
	);

	initial begin
		// Initialize Inputs
		D = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		D = 1;
		#10;
		D = 32;
		#10;
		D = 31;
		#10;
		D = 33;
		#10;

		// A large-number case
		D = 4095;
		#10;

		// Edge case
		D = -4096;
		#10;

		// More large-number cases
		D = -4095;
		#10;
		D = -2047;
		#10;

	end
      
endmodule

