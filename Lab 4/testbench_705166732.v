`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:53:53 03/08/2021
// Design Name:   parking_meter
// Module Name:   /home/ise/lab4_final2/testbench_705166732.v
// Project Name:  lab4_final2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: parking_meter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench_705166732;

	// Inputs
	reg add1;
	reg add2;
	reg add3;
	reg add4;
	reg rst1;
	reg rst2;
	reg clk;
	reg rst;

	// Outputs
	wire [6:0] led_seg;
	wire a1;
	wire a2;
	wire a3;
	wire a4;
	wire [3:0] val1;
	wire [3:0] val2;
	wire [3:0] val3;
	wire [3:0] val4;

	// Instantiate the Unit Under Test (UUT)
	parking_meter uut (
		.add1(add1), 
		.add2(add2), 
		.add3(add3), 
		.add4(add4), 
		.rst1(rst1), 
		.rst2(rst2), 
		.clk(clk), 
		.rst(rst), 
		.led_seg(led_seg), 
		.a1(a1), 
		.a2(a2), 
		.a3(a3), 
		.a4(a4), 
		.val1(val1), 
		.val2(val2), 
		.val3(val3), 
		.val4(val4)
	);

	initial begin
		// Initialize Inputs
		add1 = 0;
		add2 = 0;
		add3 = 0;
		add4 = 0;
		rst1 = 0;
		rst2 = 0;
		clk = 1;
		rst = 1;

		// 1. Initial State
		#10000000; // 10 ms
		rst = 0;
		
		#1000000000;
		#990000000; // 990 ms
		
		// 2. Add1
		add1 = 1;
		
		#10000000;
		add1 = 0;
		
		#1000000000;
		#560000000; // 560 ms
		
		// 3. Add2, but not at the second
		add2 = 1;
		
		#10000000;
		add2 = 0;
		
		#1000000000;
		#1000000000;
		#420000000; // 420 ms
		
		// 4. Add3
		add3 = 1;
		
		#10000000;
		add3 = 0;
		
		#1000000000;
		#990000000; // 990 ms
		
		// 5. Add4
		add4 = 1;
		
		#10000000;
		add4 = 0;
		
		#1000000000;
		#990000000; // 990 ms
		
		// 6. 9999s
		repeat(40) begin
			add4 = 1;
			#5000000;
			add4 = 0;
			#5000000;
		end
		
		#1000000000;
		#600000000; // 600 ms
		
		// 7. rst
		rst = 1;
		
		#10000000;
		rst = 0;
		
		#1000000000;
		#490000000; // 490 ms
		
		// 8. rst1
		rst1 = 1;
		
		#10000000;
		rst1 = 0;
		
		repeat(3)
			#1000000000;
			
		#490000000; // 490 ms
		
		add1 = 1;
		
		#10000000;
		add1 = 0;
		#990000000; // 990 ms
		
		repeat(9)
			#1000000000;
		
		// 9. Add to over 180s at odd time
		add2 = 1;
		
		#10000000;
		add2 = 0;
		#990000000;
		
		// 10. Running below 180s
		repeat(4)
			#1000000000;
			
		// 11. Add to over 180s at even time
		add3 = 1;
		
		#10000000;
		add3 = 0;
		#990000000; // 990 ms
		
		repeat(2)
			#1000000000;
		
		// 12. rst2
		rst2 = 1;
		
		#10000000;
		rst2 = 0;
		#490000000; // 490 ms
		
		repeat(3)
			#1000000000;
		
		// 13. rst at odd time
		rst1 = 1;
		
		#10000000;
		rst1 = 0;
		
		// 14. time expires -- wait 16s

	end
	
	// Set clock frequency to 100 Hz (edge flip at 5ms)
	always #5000000 clk = ~clk;
      
endmodule

