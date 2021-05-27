`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:51:26 03/08/2021 
// Design Name: 
// Module Name:    parking_meter 
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
module parking_meter(
		input add1,
		input add2,
		input add3,
		input add4,
		input rst1,
		input rst2,
		input clk,
		input rst,
		output [6:0] led_seg,
		output a1,
		output a2,
		output a3,
		output a4,
		output [3:0] val1,
		output [3:0] val2,
		output [3:0] val3,
		output [3:0] val4
	);

	// part 1: process time
	reg [13:0] timer;
	reg [6:0] duty_counter;
	
	always @ (posedge clk)
	begin
		// countdown clock
		if (timer == 0) begin
			timer = 0;
			duty_counter = 0;
		end
		else if (duty_counter == 7'b1100011) // 99 cycles
		begin
			timer = timer - 1'b1;
			duty_counter = 0;
		end
		else begin
			timer = timer;
			duty_counter = duty_counter + 1'b1;
		end
	
		// add timer
		if (add1)
			timer = timer + 6'b111100; // 60
		if (add2)
			timer = timer + 7'b1111000; // 120
		if (add3)
			timer = timer + 8'b10110100; // 180
		if (add4)
			timer = timer + 9'b100101100; // 300
			
		// if beyond 9999
		if (timer > 14'b10011100001111) // 9999
		begin
			timer = 14'b10011100001111; // 9999
			duty_counter = 0;
		end
	
		// reset timer
		if (rst1) begin
			timer = 5'b10000; // 16
			duty_counter = 0;
		end
		if (rst2) begin
			timer = 8'b10010110; // 150
			duty_counter = 0;
		end
	
		// resetting clock
		if (rst)
			timer = 0;
	
	end

	// part 2: set current state
	// initialize states
	parameter INITIAL = 1'b0;
	parameter SHORT = 1'b1;
	parameter ON = 2'b10;
	
	reg [1:0] state;
	reg [1:0] next_state;
	
	always @ (posedge clk) begin
		if (timer > 8'b10110100) // 180
		begin
			next_state = ON;
		end
		else if (timer > 0)
			next_state = SHORT;
		else
			next_state = INITIAL;
	end
	
	always @ (posedge clk) begin
		state = next_state;
	end

	// part 3: handle BCD conversion
	// initialize registers
	reg [3:0] digit1;
	reg [3:0] digit2;
	reg [3:0] digit3;
	reg [3:0] digit4;
	
	always @ (posedge clk) begin
		digit1 = (timer / 10'b1111101000) % 4'b1010; // 1000, 10
		digit2 = (timer / 7'b1100100) % 4'b1010; // 100, 10
		digit3 = (timer / 4'b1010) % 4'b1010; // 10, 10
		digit4 = timer % 4'b1010; // 10
	end
	
	assign val1 = digit1;
	assign val2 = digit2;
	assign val3 = digit3;
	assign val4 = digit4;

	// part 4: handle seven-seg display
	// initialize flash variables
	reg [5:0] flash_counter;
	reg flash;
	reg [1:0] anode_select;
	reg [3:0] digit;
	
	// initialize output registers
	reg [6:0] display;
	reg anode1;
	reg anode2;
	reg anode3;
	reg anode4;
	
	// set flash parameters
	always @ (posedge clk) begin
		case (state)
		INITIAL: begin
			if (rst) begin
				flash_counter = 0;
				flash = 1;
				anode_select = 2'b11;
			end
			else if (flash_counter == 6'b110001) begin
				flash_counter = 0;
				flash = ~flash;
			end
			else begin
				flash_counter = flash_counter + 1'b1;
			end
		end
		SHORT: begin
			if (digit4 % 2 == 1)
				flash = 0;
			else
				flash = 1;
		end
		ON:
			flash = 1;
		endcase
		
		if (flash == 0)
			anode_select = 2'b11;
			
		else begin
			anode_select = anode_select + 1'b1;
			case (anode_select)
			0: digit = digit1;
			1: digit = digit2;
			2: digit = digit3;
			3: digit = digit4;
			endcase
		end
		
	end
	
	// display
	always @ (posedge clk) begin
		anode1 <= 1;
		anode2 <= 1;
		anode3 <= 1;
		anode4 <= 1;
		
		if (flash == 0) begin
			display <= 0;
		end
		
		else begin
			case(anode_select)
			0: anode1 <= 0;
			1: anode2 <= 0;
			2: anode3 <= 0;
			3: anode4 <= 0;
			endcase
			
			case (digit)
			0: display <= 7'b1111110;
			1: display <= 7'b0110000;
			2: display <= 7'b1101101;
			3: display <= 7'b1111001;
			4: display <= 7'b0110011;
			5: display <= 7'b1011011;
			6: display <= 7'b1011111;
			7: display <= 7'b1110000;
			8: display <= 7'b1111111;
			9: display <= 7'b1111011;
			endcase
		end
	end

	assign led_seg = display;
	assign a1 = anode1;
	assign a2 = anode2;
	assign a3 = anode3;
	assign a4 = anode4;
	
endmodule
