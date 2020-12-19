`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/30/2020 10:32:58 PM
// Design Name: 
// Module Name: rgb2grey
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


module rgb2grey(
input    axi_clk,
input    axi_reset_n,
input    i_rgb_data_valid,
input   i_rgb_reg_Data_Valid,
input [23:0] i_rgb_data,
output   o_rgb_data_ready,
output reg  o_greyScale_data_valid,
output reg [7:0] o_grey_data,
input    i_grey_ready
);

wire [7:0] w_red;
wire [7:0] w_green;
wire [7:0] w_blue;
wire [31:0] filteredData;

reg [7:0] I_Red [262153 : 0];
reg [7:0] I_Green [262153 : 0];
reg [7:0] I_Blue [262153 : 0];

reg [7:0] Max_I_Red;
reg [7:0] Max_I_Green;
reg [7:0] Max_I_Blue;

//
reg [7:0] Min_I_Red;
reg [7:0] Min_I_Green;
reg [7:0] Min_I_Blue;
//

//
reg [7:0] Maximum_Pixel_Value;
reg [7:0] Minimum_Pixel_Value;
//
assign o_rgb_data_ready = i_grey_ready;
assign w_red = i_rgb_data[7:0];
assign w_green = i_rgb_data[15:8];
assign w_blue = i_rgb_data[23:16];

integer i,j,k,l,m,n,o,z;

always @(posedge axi_clk)
begin
    if(!axi_reset_n & !i_rgb_reg_Data_Valid)
      begin
        for(i=0;i<262154;i=i+1)
              begin
                I_Red[i]    = 0;
                I_Green[i]  = 0;
                I_Blue[i]   =0;
                Max_I_Red=0;
                Max_I_Green=0;
                Max_I_Blue=0;
                //
                Min_I_Red=8'b11111111;
                Min_I_Green=8'b11111111;
                Min_I_Blue=8'b11111111;
                //
                Maximum_Pixel_Value=0;
                Minimum_Pixel_Value=0;
               // $display(j,"\t",I_Red[j],"\t",I_Green[j],"\t",I_Blue[j]);
              end
      end
 end

always @(posedge axi_clk)
begin
    if( i_rgb_reg_Data_Valid & axi_reset_n)
    begin
    //Load RGB value to register
        for(j=0;j<262154;j=j+1)
            begin
                @(posedge axi_clk);
                    I_Red[j]    <= w_red;
                    I_Green[j]  <= w_green;
                    I_Blue[j]   <=w_blue;
                    //$display(j,"\t",I_Red[j],"\t",I_Green[j],"\t",I_Blue[j],"\n");
            end
    //Find the maximum of red value
         for (k=0;k<262154;k=k+1)
            begin
               @(posedge axi_clk);
                  if (I_Red[k] > Max_I_Red)
                       Max_I_Red = I_Red[k];
            end
   // Find the maximum of Green value 
         for (l=0;l<262154;l=l+1)
             begin
                @(posedge axi_clk);
                    if (I_Green[l] > Max_I_Green)
                        Max_I_Green = I_Green[l];
             end
   // Find the maximum of Blue value 
         for (m=0;m<262154;m=m+1)
             begin
                @(posedge axi_clk);
                    if (I_Blue[m] > Max_I_Blue)
                         Max_I_Blue = I_Blue[m];
             end
             
    //Find the minimum of red value         
        for (n=10;n<262154;n=n+1)
             begin
                @(posedge axi_clk);
                   if (I_Red[n] < Min_I_Red)
                       Min_I_Red = I_Red[n];
             end
    // Find the minimum of Green value        
        for (o=10;o<262154;o=o+1)
             begin
                 @(posedge axi_clk);
                    if (I_Green[o] < Min_I_Green)
                        Min_I_Green = I_Green[o];
              end
    // Find the minimum of Blue value        
        for (z=10;z<262154;z=z+1)
             begin
                 @(posedge axi_clk);
                    if (I_Blue[z] < Min_I_Blue)
                        Min_I_Blue = I_Blue[z];
             end    
   //Display the result values     
            $display("Max_I_Red","\t",Max_I_Red);
            $display("Max_I_Green","\t",Max_I_Green);
            $display("Max_I_Blue","\t",Max_I_Blue);

            $display("Min_I_Red","\t",Min_I_Red);
            $display("Min_I_Green","\t",Min_I_Green);
            $display("Min_I_Blue","\t",Min_I_Blue);
            
            //Find the Maximum pixel value among Red, Blue and Green
            
               if((Max_I_Green>Max_I_Blue)&(Max_I_Green>Max_I_Red))
                  begin
                    Maximum_Pixel_Value = Max_I_Green;
                    $display("Maximum_Pixel_Value is :","\t",Maximum_Pixel_Value);
                  end 
                    else if((Max_I_Red>Max_I_Green)&(Max_I_Red>Max_I_Blue))
                              begin
                                  Maximum_Pixel_Value = Max_I_Red;
                                  $display("Maximum_Pixel_Value is :","\t",Maximum_Pixel_Value);
                              end   
                     else
                        begin
                            Maximum_Pixel_Value = Max_I_Blue;
                            $display("Maximum_Pixel_Value is :","\t",Maximum_Pixel_Value);
                        end
                  //
             //Find the Minimum pixel value among Red, Blue and Green
                              
                                 if((Min_I_Green<Min_I_Blue)&(Min_I_Green<Min_I_Red))
                                    begin
                                      Minimum_Pixel_Value = Min_I_Green;
                                      $display("Minimum_Pixel_Value is :","\t",Minimum_Pixel_Value);
                                    end 
                                      else if((Min_I_Red<Min_I_Green)&(Min_I_Red<Min_I_Blue))
                                                begin
                                                    Minimum_Pixel_Value = Min_I_Red;
                                                    $display("Minimum_Pixel_Value is :","\t",Minimum_Pixel_Value);
                                                end   
                                       else
                                          begin
                                              Minimum_Pixel_Value = Min_I_Blue;
                                              $display("Minimum_Pixel_Value is :","\t",Minimum_Pixel_Value);
                                          end
                                    //
     end 
  end 
  
always @(posedge axi_clk)
begin
    if(i_rgb_data_valid & o_rgb_data_ready)
        o_grey_data <= (w_red>>2)+(w_red>>5)+(w_green>>1)+(w_green>>4)+(w_blue>>4)+(w_blue>>5);
end

always @(posedge axi_clk)
begin
    o_greyScale_data_valid <= i_rgb_data_valid;
end

endmodule