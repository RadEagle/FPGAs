`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:12:58 02/15/2021 
// Design Name: 
// Module Name:    vending_machine 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module vending_machine(
		input CLK,
		input RESET,
		input RELOAD,
		input CARD_IN,
		input [3:0] ITEM_CODE,
		input KEY_PRESS,
		input VALID_TRAN,
		input DOOR_OPEN,
		output VEND,
		output INVALID_SEL,
		output FAILED_TRAN,
		output [2:0] COST
	);
	
	// Initialize states
	parameter RESETTING = 1'b0;
	parameter IDLE = 1'b1;
	parameter RELOADING = 2'b10;
	parameter TRANSACT = 2'b11;
	parameter VENDING = 3'b100;
	
	// Part 1 - States
	reg [2:0] state;
	reg [2:0] next_state;
	
	// first, update next state
	always @(posedge CLK) begin
	case (state)
	RESETTING: begin
		next_state = IDLE;
		end
	IDLE, RELOADING: begin
		if (RELOAD)
			next_state = RELOADING;
		else if (CARD_IN)
			next_state = TRANSACT;
		else
			next_state = IDLE;
		end
	TRANSACT: begin
		if (VEND)
			next_state = VENDING;
		else if (CARD_IN)
			next_state = TRANSACT;
		else if (INVALID_SEL || FAILED_TRAN)
			next_state = IDLE;
		else
			next_state = TRANSACT;
		end
	VENDING: begin
		if (VEND)
			next_state = VENDING;
		else if (CARD_IN)
			next_state = TRANSACT;
		else
			next_state = IDLE;
		end
	endcase
	end
	
	// then, update current state
	always @ (posedge CLK) begin
	if (RESET)
		state = RESETTING;
	else
		state = next_state;
	end

	// Part 2 - Selector
	reg [2:0] timer;
	reg [2:0] vend_timer;
	reg [6:0] item_num;
	reg [1:0] keys_pressed;
	reg [3:0] code_one;
	
	// non-blocking statements come before blocking statements
	always @ (posedge CLK) begin
		if (state == RESETTING) begin
			item_num = 7'b1111111;
			keys_pressed = 0;
			code_one = 0;
		end
	
		if (timer == 0) begin
			item_num = 7'b1111111;
			keys_pressed = 0;
		end
			
		if (state == TRANSACT && KEY_PRESS) begin
			if (keys_pressed == 0) begin
				code_one = ITEM_CODE;
				keys_pressed = keys_pressed + 1'b1;
			end
			else if (keys_pressed == 1) begin
				item_num = (code_one * 4'b1010) + ITEM_CODE;
				keys_pressed = keys_pressed + 1'b1;
			end
		end
	end
	
	// have time bomb be a blocking statement
	always @ (posedge CLK) begin
		case(state)
		RESETTING, IDLE: 
		begin
			timer <= 0;
			vend_timer <= 0;
		end
			
		TRANSACT: 
		begin
			if (timer == 0 || KEY_PRESS)
				timer <= 3'b101;
			else
				timer <= timer - 1'b1;
		end
		
		VENDING:
		begin
			timer <= 0;
			if (vend_timer == 0)
				vend_timer <= 3'b100;
			else
				vend_timer <= vend_timer - 1'b1;
		end
		
		endcase
	end
		
	// Part 3 - Vendor
	// Initialize registers
	reg vend;
	reg invalid;
	reg failed;
	reg [2:0] cost;
	reg valid;
	reg [3:0] item_counters [19:0];
	reg opened;
	integer i;
	
	// combinational - valid happens before anything else
	always @ (posedge CLK) begin
		if (state == RESETTING) begin
			valid = 0;
		end
		
		// check validity
		if (item_num < 5'b10100 && item_counters[item_num] > 0)
			valid = 1'b1;
		else if (failed)
			valid = 0;
			
		if (VEND)
			valid = 0;
	end
	
	always @ (posedge CLK) begin
		case(state)
		RESETTING: begin
			vend <= 0;
			invalid <= 0;
			failed <= 0;
			cost <= 0;
			opened <= 0;
			for (i = 0; i < 20; i = i + 1)
				item_counters[i] <= 0;
		end
		
		IDLE: begin
			vend <= 0;
			invalid <= 0;
			failed <= 0;
			cost <= 0;
		end
		
		RELOADING: begin
			for (i = 0; i < 20; i = i + 1)
				item_counters[i] <= 4'b1010;
		end
		
		TRANSACT: begin
			// check for invalid cases
			if (item_num < 7'b1100100 && !valid)
				invalid <= ~invalid;
				
			if (valid) begin
				// get cost
				if (item_num < 18)
					cost <= item_num[4:2] + 1'b1;
				else
					cost <= item_num[4:2] + 2'b10;
			end
			
			else
				cost <= 0;
		
			if (VALID_TRAN && valid) begin
				// vend the item
				vend <= 1'b1;
				item_counters[item_num] <= item_counters[item_num] - 1'b1;
				opened <= 0;
			end
		
			else if (timer == 1) begin
				if (valid)
					failed <= ~failed;
				else
					invalid <= ~invalid;
			end
		
		end
		
		VENDING: begin
			if (DOOR_OPEN)
				opened <= 1'b1;
			else if (opened && !DOOR_OPEN) begin
				vend <= 0;
				cost <= 0;
			end
			else if (vend_timer == 1) begin
				vend <= 0;
				cost <= 0;
			end
		end
		endcase
	
		if (invalid)
			invalid <= ~invalid;
			
		if (failed)
			failed <= ~failed;
			
	end
	
	assign VEND = vend;
	assign INVALID_SEL = invalid;
	assign FAILED_TRAN = failed;
	assign COST = cost;

endmodule
