`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    05:53:25 01/08/2021 
// Design Name: 
// Module Name:    extractor 
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
module extractor(output_data, exp, sig, sixth_bit);
	input [12:0] output_data;
	output [2:0] exp;
	output [4:0] sig;
	output sixth_bit;
	
	
	reg [3:0] count;
   reg [2:0] exponent;
   reg [2:0] six_shift;
   reg bit_scan;
	reg six;
    
   // assign output_data = 'b0_0001_0110_0111;
    
   always @* begin
       bit_scan = (output_data >> 12) & 1;
       for (count = 0; bit_scan == 0 && count < 12; count = count + 1)
           bit_scan = (output_data >> 12 - count - 1) & 1;
           // count - 1 necessary to sync count correctly
            
       exponent = 0;
       six_shift = 0;
		 six = 0;
            
       if (count < 8) begin
           exponent = 8 - count;
           six_shift = exponent - 1;
			  six = (output_data >> six_shift) & 1;
		 end
 
   end
    
   assign exp = exponent;
   assign sig = output_data >> exp;
   assign sixth_bit = six;
	
endmodule
