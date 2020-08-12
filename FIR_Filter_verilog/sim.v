`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/21 19:28:25
// Design Name: 
// Module Name: sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sim();
 reg CLK;
 reg reset;
 reg signed [15:0] data_in;
 wire signed [31:0]data_out;
 FIR_filter U1(.data_in(data_in),.data_out(data_out),.CLK(CLK),.reset(reset));
 initial begin
    reset = 0;
    #15;
    reset = 1;
 end
 initial begin
    CLK = 0;
    forever #10 CLK = ~CLK; 
 end
 
reg signed[15:0] mem[0:48000];

initial begin
$readmemb("G:/MATLAB/R2018a/bin/databin1.mem" , mem);
end
integer i=0;
initial begin
#15;
for(i = 0 ; i < 48000 ; i = i+1) begin
data_in = mem[i];
#20;
end 
end
integer file;
integer cnt=0;
initial begin
file = $fopen("dataout1.txt" , "w");
end
always @(posedge CLK) begin
$fdisplay(file , data_out);
end
always @(posedge CLK) begin
cnt = cnt + 1;
if (cnt == 48000) begin
$fclose(file);
reset = 0;
#20 $stop;
end
end
endmodule
