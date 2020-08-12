`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*文件中的coef系数由matlab的fdatool工具箱产生，并实现浮点数转定点数*/
//////////////////////////////////////////////////////////////////////////////////


module FIR_filter(data_in,data_out,reset,CLK,music);
input wire signed [15:0]data_in;
output reg signed [31:0]data_out;
input reset;
input music;
input CLK;

parameter word_width = 16;
parameter      order =15;
wire signed [15:0] coef [0:15];
reg signed [15:0] delay_pipeline[0:15];          
          assign coef[0]=-58;
          assign coef[1]=15;
          assign coef[2]=601;
          assign coef[3]=223;
          assign coef[4]=-2831;
          assign coef[5]=-2447;
          assign coef[6]=10325;
          assign coef[7]=26941;
          assign coef[8]=26941;
          assign coef[9]=10325;
          assign coef[10]=-2447;
          assign coef[11]=-2831;
          assign coef[12]=223;
          assign coef[13]=601;
          assign coef[14]=15;
          assign coef[15]=-58;
reg signed [31:0]product[0:15];
reg signed [31:0]sum;
reg signed [15:0]data_in_buf;
always@(posedge CLK or negedge reset)
begin 
  if (!reset)
   begin
    data_in_buf<=0;
   end
  else begin
    data_in_buf<=data_in;
   end
end
always@(posedge CLK or negedge reset)
  begin 
    if(!reset) begin
        delay_pipeline[0]<=0;
        delay_pipeline[1]<=0;
        delay_pipeline[2]<=0;
        delay_pipeline[3]<=0;
        delay_pipeline[4]<=0;
        delay_pipeline[5]<=0;
        delay_pipeline[6]<=0;
        delay_pipeline[7]<=0;
        delay_pipeline[8]<=0;
        delay_pipeline[9]<=0;
        delay_pipeline[10]<=0;
        delay_pipeline[11]<=0;
        delay_pipeline[12]<=0;
        delay_pipeline[13]<=0;
        delay_pipeline[14]<=0;
        delay_pipeline[15]<=0;
        delay_pipeline[16]<=0;
      end
      else begin
      delay_pipeline[0]<=data_in_buf;
      delay_pipeline[1]<=delay_pipeline[0];
      delay_pipeline[2]<=delay_pipeline[1];
      delay_pipeline[3]<=delay_pipeline[2];
      delay_pipeline[4]<=delay_pipeline[3];
      delay_pipeline[5]<=delay_pipeline[4];
      delay_pipeline[6]<=delay_pipeline[5];
      delay_pipeline[7]<=delay_pipeline[6];
      delay_pipeline[8]<=delay_pipeline[7];
      delay_pipeline[9]<=delay_pipeline[8];
      delay_pipeline[10]<=delay_pipeline[9];
      delay_pipeline[11]<=delay_pipeline[10];
      delay_pipeline[12]<=delay_pipeline[11];
      delay_pipeline[13]<=delay_pipeline[12];
      delay_pipeline[14]<=delay_pipeline[13];
      delay_pipeline[15]<=delay_pipeline[14];
      end 
    end 
always@(posedge CLK or negedge reset)
begin
  if (!reset)begin
  product[0]<=0;
  product[1]<=0;
  product[2]<=0;
  product[3]<=0;
  product[4]<=0;
  product[5]<=0;
  product[6]<=0;
  product[7]<=0;
  product[8]<=0;
  product[9]<=0;
  product[10]<=0;
  product[11]<=0;
  product[12]<=0;
  product[13]<=0;
  product[14]<=0;
  product[15]<=0;
  product[16]<=0;
  end
  else begin
  product[0]<=coef[0]*delay_pipeline[0];
  product[1]<=coef[1]*delay_pipeline[1];
  product[2]<=coef[2]*delay_pipeline[2];
  product[3]<=coef[3]*delay_pipeline[3];
  product[4]<=coef[4]*delay_pipeline[4];
  product[5]<=coef[5]*delay_pipeline[5];
  product[6]<=coef[6]*delay_pipeline[6];
  product[7]<=coef[7]*delay_pipeline[7];
  product[8]<=coef[8]*delay_pipeline[8];
  product[9]<=coef[9]*delay_pipeline[9];
  product[10]<=coef[10]*delay_pipeline[10];
  product[11]<=coef[11]*delay_pipeline[11];
  product[12]<=coef[12]*delay_pipeline[12];
  product[13]<=coef[13]*delay_pipeline[13];
  product[14]<=coef[14]*delay_pipeline[14];
  product[15]<=coef[15]*delay_pipeline[15];
  end
end
always@(posedge CLK or negedge reset)
begin
  if(!reset)
  begin
  sum<=0;
  end
  else begin
  sum<=product[0]+product[1]+product[2]+product[3]+product[4]+product[5]+product[6]+product[7]+product[8]+product[9]+product[10]+product[11]+product[12]+product[13]+product[14]+product[15];
  end
end
always@(posedge CLK or negedge reset)
begin
  if(!reset)
  begin
  data_out<=0;
  end
  else begin
  data_out = sum;
  end
end
endmodule
