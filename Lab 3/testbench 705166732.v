`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:14:29 02/15/2021
// Design Name:   vending_machine
// Module Name:   /home/ise/lab3_final2/testbench_705166732.v
// Project Name:  lab3_final2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: vending_machine
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
	reg CLK;
	reg RESET;
	reg RELOAD;
	reg CARD_IN;
	reg [3:0] ITEM_CODE;
	reg KEY_PRESS;
	reg VALID_TRAN;
	reg DOOR_OPEN;

	// Outputs
	wire VEND;
	wire INVALID_SEL;
	wire FAILED_TRAN;
	wire [2:0] COST;

	// Instantiate the Unit Under Test (UUT)
	vending_machine uut (
		.CLK(CLK), 
		.RESET(RESET), 
		.RELOAD(RELOAD), 
		.CARD_IN(CARD_IN), 
		.ITEM_CODE(ITEM_CODE), 
		.KEY_PRESS(KEY_PRESS), 
		.VALID_TRAN(VALID_TRAN), 
		.DOOR_OPEN(DOOR_OPEN), 
		.VEND(VEND), 
		.INVALID_SEL(INVALID_SEL), 
		.FAILED_TRAN(FAILED_TRAN), 
		.COST(COST)
	);

	initial begin
		// Initialize Inputs
		CLK = 1;
		RESET = 1;
		RELOAD = 0;
		CARD_IN = 0;
		ITEM_CODE = 0;
		KEY_PRESS = 0;
		VALID_TRAN = 0;
		DOOR_OPEN = 0;
		
		#20;
		RESET = 0;
		VALID_TRAN = 1;
		
		#10;
		RELOAD = 1;
		
		#10;
		RELOAD = 0;
		
		// 1. Successful Purchase
		// 2. After 10 Purchases, Item Out of Stock
		repeat(12) begin
			#10;
			CARD_IN = 1;
			ITEM_CODE = 1;
			KEY_PRESS = 1;
			
			#10;
			CARD_IN = 0;
			KEY_PRESS = 0;
			
			#20;
			KEY_PRESS = 1;
			ITEM_CODE = 7;
			
			#10;
			KEY_PRESS = 0;
			DOOR_OPEN = 1;
			
			#50;
			DOOR_OPEN = 0;
		end
		
		#10;
		RELOAD = 1;
		
		#10;
		RELOAD = 0;
		
		// 3. No Input
		#10;
		CARD_IN = 1;
		
		#80;
		CARD_IN = 0;
		
		// 4. One Input
		#10;
		ITEM_CODE = 1;
		KEY_PRESS = 1;
		
		#10;
		KEY_PRESS = 0;
		
		#10;
		ITEM_CODE = 9;
		
		// 5. Key Press on Idle
		#50;
		
		#20;
		ITEM_CODE = 0;
		KEY_PRESS = 1;
		
		#10;
		KEY_PRESS = 0;
		
		#20;
		KEY_PRESS = 1;
		ITEM_CODE = 8;
		
		#10;
		KEY_PRESS = 0;
		
		// 6. Door Doesn't Open
		#40;
		VALID_TRAN = 0;
		KEY_PRESS = 0;
		
		#10;
		CARD_IN = 1;
		KEY_PRESS = 1;
		ITEM_CODE = 0;

		#10;
		CARD_IN = 0;
		KEY_PRESS = 0;
		
		#20;
		KEY_PRESS = 1;
		ITEM_CODE = 7;
		VALID_TRAN = 1;
		
		#10;
		KEY_PRESS = 0;
		VALID_TRAN = 0;
		
		#70;
		
		// 7. Failed Transaction
		#10;
		CARD_IN = 1;
		ITEM_CODE = 0;
		KEY_PRESS = 1;
		
		#10;
		CARD_IN = 0;
		KEY_PRESS = 0;
		
		#20;
		KEY_PRESS = 1;
		ITEM_CODE = 8;
		
		#10;
		KEY_PRESS = 0;
		
		#70;
		
		// 8. Item Number Out of Range
		#10;
		CARD_IN = 1;
		ITEM_CODE = 2;
		KEY_PRESS = 1;
		
		#10;
		CARD_IN = 0;
		KEY_PRESS = 0;
		
		#20;
		KEY_PRESS = 1;
		ITEM_CODE = 0;
		
		#10;
		KEY_PRESS = 0;

	end
	
	// Set clock frequency to 100 MHz (edge flip at 5ns)
	always #5 CLK = ~CLK;
      
endmodule

