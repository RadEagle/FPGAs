`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    05:55:04 01/08/2021 
// Design Name: 
// Module Name:    rounder 
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
module rounder(exp, sig, sixth_bit, E, F);
	input [2:0] exp;
	input [4:0] sig;
	input sixth_bit;
	output [2:0] E;
	output [4:0] F;
	
	reg [3:0] exponent;
   reg [5:0] significand;
    
   always @* begin
       exponent = exp;
       significand = sig;
        
       if (sixth_bit == 1)
           significand = significand + 1;
            
       if (significand > 'b1_1111) begin
           significand = significand >> 1;
           exponent = exponent + 1;
       end
            
       if (exponent > 'b111) begin
           exponent = exponent - 1;
           significand = 'b11111;
       end
 
   end
    
   assign E = exponent;
   assign F = significand;

endmodule
