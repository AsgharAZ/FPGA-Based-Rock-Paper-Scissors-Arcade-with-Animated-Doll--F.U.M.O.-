VGA
module clk_div(
clk,clk_d
    );
    //parameter div_value =32'd10000;
    parameter div_value = 1;
    input clk;
    output clk_d;
    reg clk_d;
    reg count;
    initial begin
    clk_d = 0;
    count = 0;    
    end
    always @ (posedge clk)
    begin
    if (count == div_value)
    begin
        clk_d <= ~clk_d;
        count <= 0;
    end
    else
    count <= count + 1;
    end
endmodule





module h_counter(
clk,h_count,trig_v
    );
    input clk;
    output[9:0] h_count;
    output trig_v;
    reg[9:0] h_count;
    reg trig_v;
    initial begin
        h_count <= 0;
        trig_v <= 0;
    end
    always @ (posedge clk)
    begin
        if (h_count < 799)
        begin
            h_count <= h_count + 1;
            trig_v <= 1'b0;       
        end
        else 
        begin
            trig_v <= 1'b1;
            h_count <= 0;        
        end
    end
endmodule


module v_counter(clk,enable_v,v_count);
    input clk;
    input enable_v;
    output[9:0] v_count;
    reg[9:0] v_count;
    initial begin
        v_count = 0;
    end
    always @( posedge clk )
    begin
        if (enable_v & (v_count < 524))
        begin 
                v_count <= v_count + 1;    
        end
        else if (enable_v)
        begin
            v_count <= 0;        
        end
    end
endmodule



module vga_sync(
input[9:0] h_count,
input[9:0] v_count,
output[9:0] x_loc,
output [9:0]  y_loc,
output h_sync,v_sync,video_on
    );
    //horizontal
    localparam HD = 640;
    localparam HF = 16;
    localparam HB = 48;
    localparam HR = 96;
    
    //vertical
    localparam VD = 480;
    localparam VF = 10;
    localparam VB = 33;
    localparam VR = 2;
    
    assign v_sync = (v_count < (VD+VF)) | (v_count >= (VD+VF+VR)); 
    assign h_sync = (h_count < (HD+HF)) | (h_count >= (HD+HF+HR));
    assign video_on = (h_count < HD) & (v_count<VD);
    
    assign x_loc = h_count;
    assign y_loc = v_count;
     
endmodule


module final_pixel_gen(
input [3:0] flag,
input clk_d,
input [9:0] pixel_x,
input [9:0] pixel_y,
input video_on,
output reg [3:0] red = 0,
output reg [3:0] green = 0,
output reg [3:0] blue = 0
);


//end
//end
//always @(posedge clk_d) begin
//title screen
//if (flag==1)
always @(flag)
 begin
 case (flag)
    1:
    begin
if ((pixel_x==0) || (pixel_x==639) || (pixel_y==0) || (pixel_y == 479))
  begin
          red <= 4'hF;
          green <= 4'hF;
          blue <= 4'hF;
          end
          else begin
            //for black boundarioes
           if ((pixel_x >= 64 & pixel_x <=96 & pixel_y>= 32 & pixel_y <= 192) ||(pixel_x >= 96 & pixel_x <=160 & pixel_y>= 160 & pixel_y <= 192)|| (pixel_x >= 192 & pixel_x <=288 & pixel_y>= 32 & pixel_y <= 64) || (pixel_x >= 192 & pixel_x <=224 & pixel_y>=64 &  pixel_y <= 192)|| (pixel_x >= 224 & pixel_x <= 256 & pixel_y>=96 & pixel_y <= 128)|| (pixel_x >= 224 & pixel_x <=288 & pixel_y>= 160 & pixel_y <= 192) || (pixel_x >= 320 & pixel_x <=416 & pixel_y>= 32 & pixel_y <= 64) ||(pixel_x >= 352 & pixel_x <= 384 & pixel_y>= 64 & pixel_y <= 192) || (pixel_x >= 448 & pixel_x <=480 & pixel_y>= 32 & pixel_y <= 96) || (pixel_x >= 512 & pixel_x <=608 & pixel_y>= 32 & pixel_y <= 64) || (pixel_x >= 512 & pixel_x <=544 & pixel_y>= 64 & pixel_y <= 128) || (pixel_x >= 544 & pixel_x <=608 & pixel_y>= 96 & pixel_y <= 128) || (pixel_x >= 576 & pixel_x <=608 & pixel_y>= 128 & pixel_y <= 192)|| (pixel_x >= 512 & pixel_x <=576 & pixel_y>= 160 & pixel_y <= 192)|| (pixel_x >= 64 & pixel_x <=96 & pixel_y>= 256 & pixel_y <= 416) || (pixel_x >= 96 & pixel_x <=160 & pixel_y>= 256 & pixel_y <= 288) || (pixel_x >= 128 & pixel_x <=160 & pixel_y>= 288 & pixel_y <= 320) || (pixel_x >= 96 & pixel_x <=160 & pixel_y>= 320 & pixel_y <= 352) || (pixel_x >= 192 & pixel_x <=224 & pixel_y>= 256 & pixel_y <= 416) || (pixel_x >= 224 & pixel_x <=288 & pixel_y>= 384 & pixel_y <= 416) || (pixel_x >= 320 & pixel_x <= 416 & pixel_y>= 256 & pixel_y <= 288) || (pixel_x >= 320 & pixel_x <=352 & pixel_y>= 288 & pixel_y <= 416) || (pixel_x >= 384 & pixel_x <=416 & pixel_y>= 288 & pixel_y <= 416) || (pixel_x >= 352 & pixel_x <=384 & pixel_y>= 320 & pixel_y <= 352) || (pixel_x >= 448 & pixel_x <=480 & pixel_y>= 256 & pixel_y <= 352) || (pixel_x >= 480 & pixel_x <=512 & pixel_y>= 320 & pixel_y <= 352) || (pixel_x >= 512 & pixel_x <=544  & pixel_y>= 256 & pixel_y <= 416) || (pixel_x >= 448 & pixel_x <=512 & pixel_y>= 384 & pixel_y <= 416))
           begin
           red <= video_on ? 4'h0 : 4'hF;
           green <= video_on ? 4'h0 : 4'hF;
           blue <= video_on ? 4'h0 : 4'hF;
           end
           
           else
           begin
     
              
               // for Orange background
               red <= video_on ? 4'hA : 4'h0;
               green <= video_on ? 4'h1 : 4'h0;
               blue <= video_on ? 4'h6 : 4'h0;
               
          
           end
           
          end
end


    2:
begin
    if ((pixel_x==0) || (pixel_x==639) || (pixel_y==0) || (pixel_y == 479))
          begin
          red <= 4'hF;
          green <= 4'hF;
          blue <= 4'hF;
          end
          else begin
            //for black boundarioes
           if ((pixel_x >= 160 & pixel_x <= 416 & pixel_y >= 96 & pixel_y<= 128)|| (pixel_x >= 160 & pixel_x <= 192 & pixel_y >= 128 & pixel_y<= 374)|| (pixel_x >= 384 & pixel_x <= 416 & pixel_y >= 128 & pixel_y<= 374)|| (pixel_x >= 192 & pixel_x <= 384 & pixel_y >= 342 & pixel_y<= 374) || (pixel_x >= 224 & pixel_x <= 352 & pixel_y >= 150 & pixel_y<= 182)|| (pixel_x >= 224 & pixel_x <= 280 & pixel_y >= 214 & pixel_y<= 246)|| (pixel_x >= 224 & pixel_x <= 256 & pixel_y >= 278 & pixel_y<= 310) )
           begin
           red <= video_on ? 4'h0 : 4'hF;
           green <= video_on ? 4'h0 : 4'hF;
           blue <= video_on ? 4'h0 : 4'hF;
           end
           
           else
           begin
                //for White color
               if (((pixel_x >= 192 & pixel_x <= 384) & ((pixel_y >=128 & pixel_y<= 150) || (pixel_y >= 182 & pixel_y<= 214) || (pixel_y >= 246 & pixel_y <= 278) || (pixel_y>= 310 & pixel_y<= 342))) || (pixel_y >= 128 & pixel_y <= 342 & pixel_x >=192 & pixel_x<= 224)||(pixel_y >= 128 & pixel_y <= 342 & pixel_x >= 352 & pixel_x <=384) || (pixel_x>=280 & pixel_x <= 352 & pixel_y >= 214 & pixel_y <= 246) || (pixel_x >=256 & pixel_x <=352 & pixel_y>= 278 & pixel_y <=310))
               begin
               red <= video_on ? 4'hF : 4'h0;
               green <= video_on ? 4'hF : 4'h0;
               blue <= video_on ? 4'hF : 4'h0;
               end
               
               else begin
               // for Pink background
               red <= video_on ? 4'hF : 4'h0;
               green <= video_on ? 4'h9 : 4'h0;
               blue <= video_on ? 4'hF : 4'h0;
               
               end
           end
           
          end


end


//else if (flag==3) //rock
    3:
begin
   //displays white border
          if ((pixel_x==0) || (pixel_x==639) || (pixel_y==0) || (pixel_y == 479))
          begin
          red <= 4'hF;
          green <= 4'hF;
          blue <= 4'hF;
          end
          else begin
            //for black boundarioes
           if ((pixel_x>=160  & pixel_x<= 192 & pixel_y >= 224 & pixel_y <= 320) || (pixel_x>= 192 & pixel_x<= 224 & pixel_y >= 192 & pixel_y <= 256) || (pixel_x>= 224 & pixel_x<= 256 & pixel_y >= 160 & pixel_y <= 224) || (pixel_x>= 256 & pixel_x<= 288 & pixel_y >= 160 & pixel_y <= 192)|| (pixel_x>= 288 & pixel_x<= 320 & pixel_y >= 160 & pixel_y <= 224)|| (pixel_x>= 320 & pixel_x<= 384 & pixel_y >= 192 & pixel_y <= 224)|| (pixel_x>= 352 & pixel_x<= 384 & pixel_y >= 224 & pixel_y <= 256)|| (pixel_x>= 384 & pixel_x<= 416 & pixel_y >= 224 & pixel_y <= 320)|| (pixel_x>= 160 & pixel_x<= 416 & pixel_y >= 288 & pixel_y <= 320))
           begin
           red <= video_on ? 4'h0 : 4'h0;
           green <= video_on ? 4'h0 : 4'h0;
           blue <= video_on ? 4'h0 : 4'h0;
           end
           
           else
           begin
                //for Gray color
               if ((pixel_x >= 256 & pixel_x<= 288 & pixel_y>=192 & pixel_y<= 224) || (pixel_x >= 224 & pixel_x<= 352 & pixel_y>=224 & pixel_y<= 256) ||(pixel_x >= 192 & pixel_x<= 384 & pixel_y>=256 & pixel_y<= 288))
               begin
               red <= video_on ? 4'h9 : 4'h0;
               green <= video_on ? 4'h9 : 4'h0;
               blue <= video_on ? 4'h9 : 4'h0;
               end
               
               else begin
               // for Pink background
               red <= video_on ? 4'hF : 4'h0;
               green <= video_on ? 4'h9 : 4'h0;
               blue <= video_on ? 4'hF : 4'h0;
               
               end
           end
           end

end


//else if (flag==4) //scissor
    4:
begin
 if ((pixel_x==0) || (pixel_x==639) || (pixel_y==0) || (pixel_y == 479))
          begin
          red <= 4'hF;
          green <= 4'hF;
          blue <= 4'hF;
          end
          else begin
            //for black boundarioes
           if ((pixel_x >= 96 & pixel_x<= 192 & pixel_y >= 128 & pixel_y <=160) || (pixel_x>= 160 & pixel_x<= 256 & pixel_y >= 160 & pixel_y<=192) || (pixel_x>= 96 & pixel_x <= 128 & pixel_y >= 160 & pixel_y <= 192) || (pixel_x >= 96 & pixel_x<= 192 & pixel_y >= 192 & pixel_y <=224) || (pixel_x >= 224 & pixel_x<= 480 & pixel_y >= 192 & pixel_y <=224)|| (pixel_x >= 224 & pixel_x<= 256 & pixel_y >= 192 & pixel_y <=320) || (pixel_x >= 224 & pixel_x<= 480 & pixel_y >= 250 & pixel_y <=288) || (pixel_x >= 160 & pixel_x<= 256 & pixel_y >= 288 & pixel_y <=320)||(pixel_x >= 96 & pixel_x<= 192 & pixel_y >= 250 & pixel_y <=288) || (pixel_x >= 96 & pixel_x<= 192 & pixel_y >= 320 & pixel_y <=352) || (pixel_x >= 96 & pixel_x<= 128 & pixel_y >= 288 & pixel_y <=320)) 
           begin
           red <= video_on ? 4'h0 : 4'hF;
           green <= video_on ? 4'h0 : 4'hF;
           blue <= video_on ? 4'h0 : 4'hF;
           end
           
           else
           begin
     
              
               // for Pink background
               red <= video_on ? 4'hF : 4'h0;
               green <= video_on ? 4'h9 : 4'h0;
               blue <= video_on ? 4'hF : 4'h0;
               
          
           end
           
          end



end


//else if (flag== 5) //win
    5:
begin
 if ((pixel_x==0) || (pixel_x==639) || (pixel_y==0) || (pixel_y == 479))
          begin
          red <= 4'hF;
          green <= 4'hF;
          blue <= 4'hF;
          end
          else begin
            //for black boundarioes
           if((pixel_x >= 64 & pixel_x <= 96 & pixel_y >= 32 & pixel_y<= 128) || (pixel_x >= 128 & pixel_x <= 160 & pixel_y >= 32 & pixel_y<= 192) || (pixel_x >= 96 & pixel_x <= 128 & pixel_y >= 96 & pixel_y<= 128) || (pixel_x >= 64 & pixel_x <= 128 & pixel_y >= 160 & pixel_y<= 192) || (pixel_x >= 192 & pixel_x <= 288 & pixel_y >= 32 & pixel_y<= 64) || (pixel_x >= 192 & pixel_x <= 224 & pixel_y >= 64 & pixel_y<= 192) || (pixel_x >= 256 & pixel_x <= 288 & pixel_y >= 64 & pixel_y<= 192) || (pixel_x >= 224 & pixel_x <= 256 & pixel_y >= 160 & pixel_y<= 192) || (pixel_x >= 320 & pixel_x <= 352 & pixel_y >= 32 & pixel_y<= 192)|| (pixel_x >= 384 & pixel_x <= 416 & pixel_y >= 32 & pixel_y<= 192) || (pixel_x >= 352 & pixel_x <= 384 & pixel_y >= 160 & pixel_y<= 192) || (pixel_x >= 64 & pixel_x <= 96 & pixel_y >= 256 & pixel_y<= 448) || (pixel_x >= 96 & pixel_x <= 128 & pixel_y >= 384 & pixel_y<= 416) || (pixel_x >= 128 & pixel_x <= 160 & pixel_y >= 352 & pixel_y<= 384) || (pixel_x >= 160 & pixel_x <= 192 & pixel_y >= 384 & pixel_y<= 416) || (pixel_x >= 256 & pixel_x <= 352 & pixel_y >= 256 & pixel_y<= 288) || (pixel_x >= 256 & pixel_x <= 288 & pixel_y >= 288 & pixel_y<= 448) || (pixel_x >= 320 & pixel_x <= 352 & pixel_y >= 288 & pixel_y<= 448) || (pixel_x >= 288 & pixel_x <= 320 & pixel_y >= 416 & pixel_y<= 448) || (pixel_x >= 384 & pixel_x <= 416 & pixel_y >= 256 & pixel_y<= 448) || (pixel_x >= 512 & pixel_x <= 544 & pixel_y >= 256 & pixel_y<= 448) || (pixel_x >= 416 & pixel_x <= 448 & pixel_y >= 320  & pixel_y<= 352) || (pixel_x >= 448 & pixel_x <= 480 & pixel_y >= 352 & pixel_y<= 384) || (pixel_x >= 480 & pixel_x <= 512 & pixel_y >= 384 & pixel_y<= 416) || (pixel_x >= 192 & pixel_x <= 224 & pixel_y >=256 & pixel_y <=448))
              begin
           red <= video_on ? 4'h0 : 4'hF;
           green <= video_on ? 4'h0 : 4'hF;
           blue <= video_on ? 4'h0 : 4'hF;
           end
           
           else
           begin
     
              
               // for Yellow background
               red <= video_on ? 4'hF : 4'h0;
               green <= video_on ? 4'h7 : 4'h0;
               blue <= video_on ? 4'h8 : 4'h0;
               
          
           end
           
          end

end


//else if (flag ==6) //tie
    6:
begin

 if ((pixel_x==0) || (pixel_x==639) || (pixel_y==0) || (pixel_y == 479))
          begin
          red <= 4'hF;
          green <= 4'hF;
          blue <= 4'hF;
          end
          else begin
            //for black boundarioes
           if ((pixel_x >= 64 & pixel_x <= 224 & pixel_y >= 128 & pixel_y <= 160) || (pixel_x >= 128 & pixel_x <= 160 & pixel_y >= 160 & pixel_y <= 320) || (pixel_x >= 256 & pixel_x <= 352 & pixel_y >= 128 & pixel_y <= 160) || (pixel_x >= 256 & pixel_x <= 352 & pixel_y >= 288 & pixel_y <= 320) || (pixel_x >= 288 & pixel_x <= 320 & pixel_y >= 160 & pixel_y <= 288)|| (pixel_x >= 384 & pixel_x <= 480 & pixel_y >= 128 & pixel_y <= 160)|| (pixel_x >= 384 & pixel_x <= 416 & pixel_y >= 160 & pixel_y <= 288) || (pixel_x >= 384 & pixel_x <= 480 & pixel_y >= 288 & pixel_y <= 320) || (pixel_x >= 416 & pixel_x <= 448 & pixel_y >= 224 & pixel_y <= 256))
            begin
           red <= video_on ? 4'h0 : 4'hF;
           green <= video_on ? 4'h0 : 4'hF;
           blue <= video_on ? 4'h0 : 4'hF;
           end
           
           else
           begin
     
              
               // for Golden background
               red <= video_on ? 4'h6 : 4'h0;
               green <= video_on ? 4'h6 : 4'h0;
               blue <= video_on ? 4'h0 : 4'h0;
               
          
           end
           
          end

end

//else if (flag==7) //lost
    7:
begin
 if ((pixel_x==0) || (pixel_x==639) || (pixel_y==0) || (pixel_y == 479))
          begin
          red <= 4'hF;
          green <= 4'hF;
          blue <= 4'hF;
          end
          else begin
            //for black boundarioes
           if ( (pixel_x >= 64 & pixel_x <= 96 & pixel_y >= 32 & pixel_y <= 128) || (pixel_x >= 128 & pixel_x <= 160 & pixel_y >= 32 & pixel_y <= 192) || (pixel_x >= 96 & pixel_x <= 128 & pixel_y >= 96 & pixel_y <= 128) || (pixel_x >= 64 & pixel_x <= 128  & pixel_y >= 160 & pixel_y <= 192) || (pixel_x >= 192 & pixel_x <= 288 & pixel_y >= 32 & pixel_y <= 64) || (pixel_x >= 192 & pixel_x <= 288 & pixel_y >= 160 & pixel_y <= 192) || (pixel_x >= 192 & pixel_x <= 224 & pixel_y >= 64 & pixel_y <= 160) || (pixel_x >= 256 & pixel_x <= 288 & pixel_y >= 64 & pixel_y <= 160) || (pixel_x >= 320 & pixel_x <= 352 & pixel_y >= 32 & pixel_y <= 192) || (pixel_x >= 384 & pixel_x <= 416 & pixel_y >= 32 & pixel_y <= 192) || (pixel_x >= 352 & pixel_x <= 384 & pixel_y >= 160 & pixel_y <= 192) || (pixel_x >= 64 & pixel_x <= 96 & pixel_y >= 32 & pixel_y <= 128) || (pixel_x >= 64 & pixel_x <= 96 & pixel_y >= 32 & pixel_y <= 128) || (pixel_x >= 128 & pixel_x <= 160 & pixel_y >= 32 & pixel_y <= 192) || (pixel_x >= 96 & pixel_x <= 128 & pixel_y >= 96 & pixel_y <= 128) || (pixel_x >= 64 & pixel_x <= 128  & pixel_y >= 160 & pixel_y <= 192) || (pixel_x >= 192 & pixel_x <= 288 & pixel_y >= 32 & pixel_y <= 64) || (pixel_x >= 192 & pixel_x <= 288 & pixel_y >= 160 & pixel_y <= 192) || (pixel_x >= 192 & pixel_x <= 224 & pixel_y >= 64 & pixel_y <= 160) || (pixel_x >= 256 & pixel_x <= 288 & pixel_y >= 64 & pixel_y <= 160) || (pixel_x >= 320 & pixel_x <= 352 & pixel_y >= 32 & pixel_y <= 192) || (pixel_x >= 384 & pixel_x <= 416 & pixel_y >= 32 & pixel_y <= 192) || (pixel_x >= 352 & pixel_x <= 384 & pixel_y >= 160 & pixel_y <= 192) || (pixel_x >= 64 & pixel_x <= 96 & pixel_y >=224 & pixel_y <= 384) || (pixel_x >= 64 & pixel_x <= 96 & pixel_y >= 32 & pixel_y <= 128) || (pixel_x >= 128 & pixel_x <= 160 & pixel_y >= 32 & pixel_y <= 192) || (pixel_x >= 96 & pixel_x <= 128 & pixel_y >= 96 & pixel_y <= 128) || (pixel_x >= 64 & pixel_x <= 128  & pixel_y >= 160 & pixel_y <= 192) || (pixel_x >= 192 & pixel_x <= 288 & pixel_y >= 32 & pixel_y <= 64) || (pixel_x >= 192 & pixel_x <= 288 & pixel_y >= 160 & pixel_y <= 192) || (pixel_x >= 192 & pixel_x <= 224 & pixel_y >= 64 & pixel_y <= 160) || (pixel_x >= 256 & pixel_x <= 288 & pixel_y >= 64 & pixel_y <= 160) || (pixel_x >= 320 & pixel_x <= 352 & pixel_y >= 32 & pixel_y <= 192) || (pixel_x >= 384 & pixel_x <= 416 & pixel_y >= 32 & pixel_y <= 192) || (pixel_x >= 352 & pixel_x <= 384 & pixel_y >= 160 & pixel_y <= 192) || (pixel_x >= 96 & pixel_x <= 128 & pixel_y >= 352 & pixel_y <= 384) || (pixel_x >= 192 & pixel_x <= 288 & pixel_y >= 352 & pixel_y <= 384) || (pixel_x >= 192 & pixel_x <= 224 & pixel_y >= 256 & pixel_y <= 352) || (pixel_x >= 256 & pixel_x <= 288 & pixel_y >= 256 & pixel_y <= 352) || (pixel_x >= 320 & pixel_x <= 416 & pixel_y >= 224 & pixel_y <= 256) || (pixel_x >= 320 & pixel_x <= 352 & pixel_y >= 256 & pixel_y <= 320) || (pixel_x >= 352 & pixel_x <=416 & pixel_y >= 288 & pixel_y <= 320) || (pixel_x >= 384 & pixel_x <= 416 & pixel_y >= 320 & pixel_y <= 384)|| (pixel_x >= 320 & pixel_x <= 384 & pixel_y >= 352 & pixel_y <= 384) || (pixel_x >= 448 & pixel_x <= 544 & pixel_y >= 224 & pixel_y <= 256) || (pixel_x >= 480 & pixel_x <= 512 & pixel_y >= 256 & pixel_y <= 384) || (pixel_x >= 192 & pixel_x <= 288 & pixel_y >=224 & pixel_y <= 256))
           begin
           red <= video_on ? 4'h0 : 4'hF;
           green <= video_on ? 4'h0 : 4'hF;
           blue <= video_on ? 4'h0 : 4'hF;
           end
           
           else
           begin
     
              
               // for Red background
               red <= video_on ? 4'hF : 4'h0;
               green <= video_on ? 4'h0 : 4'h0;
               blue <= video_on ? 4'h0 : 4'h0;
               
          
           end
           
          end


end

    0: //Waiting Mark
    begin
        if ((pixel_x==0) || (pixel_x==639) || (pixel_y==0) || (pixel_y == 479))
          begin
          red <= 4'hF;
          green <= 4'hF;
          blue <= 4'hF;
          end
          else begin
            //for black boundarioes
          if ((pixel_x>= 256 & pixel_x <=384 &  pixel_y >=96 & pixel_y<=128) || (pixel_x >= 352 & pixel_x <=384 & pixel_y >=96 & pixel_y<=256) || (pixel_x >= 288 & pixel_x <=320 & pixel_y >=224 & pixel_y<=256) || (pixel_x >= 288 & pixel_x <= 320 & pixel_y >=256 & pixel_y<=288) || (pixel_x>= 288 & pixel_x <= 320 &  pixel_y >= 320 & pixel_y<= 352) )

            begin
           red <= video_on ? 4'h0 : 4'hF;
           green <= video_on ? 4'h0 : 4'hF;
           blue <= video_on ? 4'h0 : 4'hF;
           end
           
           else
           begin
     
              
               // for Pink background
               red <= video_on ? 4'hF : 4'h0;
               green <= video_on ? 4'h9 : 4'h0;
               blue <= video_on ? 4'hF : 4'h0;
               
          
           end
           
          end
    end 
    default:
    begin
    end
    endcase
end
endmodule

Main—-------------------
module vga_top(
input [3:0] states,
input clk,
output h_sync,v_sync,
output [3:0] red,green,blue
    );
    
    wire clk_d, v_trig, video_on;
    wire [9:0] h_count;
    wire[9:0] v_count;
    wire[9:0] x_loc;
    wire[9:0] y_loc;
    reg [3:0]Tflag;
    clk_div cd(clk,clk_d);
    h_counter hc(clk_d,h_count,v_trig);
    v_counter vc(clk_d,v_trig,v_count);
    vga_sync vgas(h_count,v_count,x_loc,y_loc,h_sync,v_sync,video_on);
    
//     title_pixel_gen tt(Tflag ,clk_d,x_loc,y_loc,video_on,red,green,blue);
//    paper_pixel_gen p(Pflag ,clk_d,x_loc,y_loc,video_on,red,green,blue);
//    rock_pixel_gen r(Rflag ,clk_d,x_loc,y_loc,video_on,red,green,blue);
//    sciss_pixel_gen s(Sflag ,clk_d,x_loc,y_loc,video_on,red,green,blue);
//    win_pixel_gen w(Wflag ,clk_d,x_loc,y_loc,video_on,red,green,blue);
//    tie_pixel_gen t(tflag ,clk_d,x_loc,y_loc,video_on,red,green,blue);
//    lost_pixel_gen pg(Lflag ,clk_d,x_loc,y_loc,video_on,red,green,blue);
    reg [24:0] count=0;
    reg [1:0] helper;
initial helper=0;


    always @ (posedge clk)
    begin
    
    if (states == 4'b0000)
    begin
    Tflag=1;
  
    end
    
    else
        begin 
        //if (states= 4'b0001) looping waiting
        
        if (states== 4'b0010) begin //paper
                    Tflag=2;
               end
        else
            begin
            if (states== 4'b0011) begin
                  Tflag= 3; 
                  
                  end
           else
             begin
              if (states== 4'b0100)
              begin 
              Tflag= 4;
               end
              else
              begin
              if (states== 4'b0101)
                begin
               Tflag=5;
            
            end
              else
                begin
                if (states== 4'b0110)
                        begin
                    Tflag=6;
                        end
                else
                begin
                if (states== 4'b0111)
                    begin
                    Tflag= 7;
                
                end
                else
                begin
                //Looping
                    if (states== 4'b0001)
                    begin
                    
                   Tflag= 0;
                    

                  
                    
                 end   
               
                end
//                end 
              end 
             
             end
                
            end 
            
               
        end
    end
    end
    end
final_pixel_gen tt(Tflag ,clk_d,x_loc,y_loc,video_on,red,green,blue);
endmodule


