
`timescale 1ns / 1ps
`include "Definitions.v"

`define STATE_RESET 0
`define STATE_DISPLAY 1 
`define STATE_PULSE 2
`define STATE_FRONT_PORCH 3
`define STATE_BACK_PORCH 4


module VGA_CONTROLLER # (parameter X_WIDTH=8, 
			 parameter Y_WIDTH=8,
			 parameter X_SIZE=256, 
			 parameter Y_SIZE=256
			 )
   (
    input wire 		      Clock,
    input wire 		      Reset,
    output wire [X_WIDTH-1:0] oVideoMemCol,
    output wire [Y_WIDTH-1:0] oVideoMemRow,
    output wire 	      oVGAHorizontalSync,
    output wire 	      oVGAVerticalSync,
    output wire 	      oDisplay
    );

   

   VGA_CONTROL_HS_FSM #(X_WIDTH,Y_WIDTH, 
			X_SIZE, Y_SIZE) 
   vga_hs_fsm
      (
       .Clock(Clock),
       .Reset(Reset),
       .oVideoMemCol(oVideoMemCol),
       .oVideoMemRow(oVideoMemRow),
       .oVGAHorizontalSync(oVGAHorizontalSync),
       .oDisplay(oDisplay)
       );
   
   VGA_CONTROL_VS_FSM #(X_WIDTH, Y_WIDTH) 
   vga_vs_fsm 
      (
       .Clock(Clock),
       .Reset(Reset),
       .iCurrentCol(oVideoMemCol),
       .iCurrentRow(oVideoMemRow),
       .oVGAVerticalSync(oVGAVerticalSync)
       );

endmodule



module VGA_CONTROL_HS_FSM # (parameter X_WIDTH=8, 
			     parameter Y_WIDTH=8,
			     parameter X_SIZE=256, 
			     parameter Y_SIZE=256
			     )
   (
    input wire 		     Clock,
    input wire 		     Reset,
    output reg [X_WIDTH-1:0] oVideoMemCol,
    output reg [Y_WIDTH-1:0] oVideoMemRow,
    output reg 		     oVGAHorizontalSync,
    output reg 		     oDisplay
    );

   reg [3:0] 		     rCurrentState, rNextState;
   
   reg [15:0] 		     rHSyncCount;
   reg 			     rHSyncCountReset;
   
   reg [X_WIDTH-1:0] 	     rNextVideoMemCol;
   reg [Y_WIDTH-1:0] 	     rNextVideoMemRow;

   reg 			     rCountEnable;
   
   always @(posedge Clock)
      begin
	 if (Reset)
	    begin
	       rCurrentState <= `STATE_RESET;
	       rHSyncCount   <= 16'b0;
	       rCountEnable  <= 1'b1;
	    end
	 else
	    begin
	       if (rHSyncCountReset)
		  rHSyncCount <= 16'b0;
	       else
		  begin
		     if (rCountEnable) 
			rHSyncCount <= rHSyncCount + 16'b1;
		  end
		     
	       rCountEnable  <= ~rCountEnable;
	       rCurrentState <= rNextState;
	       oVideoMemCol  <= rNextVideoMemCol;
	       oVideoMemRow  <= rNextVideoMemRow;
	    end
      end


   always @(*)
      begin
	 //Default values
	 oVGAHorizontalSync  = 1'b1;
	 rHSyncCountReset    = 1'b0;
	 oDisplay 	     = 1'b0;
	 
	 //Keep row and col value by default
	 rNextVideoMemCol    = oVideoMemCol; 
	 rNextVideoMemRow    = oVideoMemRow;

	 
	 case (rCurrentState)
	    //-----------------------------------
	    `STATE_RESET:
	       begin
		  rNextVideoMemCol  = 0;		  
		  rNextVideoMemRow  = 0;
		  rNextState 	    = `STATE_PULSE;
	       end
	    //-----------------------------------
	    `STATE_PULSE:
	       begin
		  oVGAHorizontalSync  = 1'b0;

		  if (rHSyncCount < 16'd95 || rCountEnable == 1'b0)
		     rNextState  = `STATE_PULSE;
		  else
		     begin
			rNextState 	  = `STATE_BACK_PORCH;
			rHSyncCountReset  = 1'b1;
		     end
	       end
	    //-----------------------------------
	    `STATE_BACK_PORCH:
	       begin
		  if (rHSyncCount < 16'd47 || rCountEnable == 1'b0)
		     rNextState  = `STATE_BACK_PORCH;
		  else
		     begin
			rHSyncCountReset  = 1'b1;
			oDisplay  = 1'b1; //FIXME: Check sync
			rNextState 	  = `STATE_DISPLAY;
		     end
	       end
	    //-----------------------------------
	    `STATE_DISPLAY:
	       begin
		  oDisplay  = 1'b1;
		  if(rCountEnable) rNextVideoMemCol = oVideoMemCol + 1;
		  
		  if (rHSyncCount < X_SIZE-1 || rCountEnable == 1'b0)
		     rNextState  = `STATE_DISPLAY;
		  else
		     begin
			if (rCountEnable)
			   begin
			      if (oVideoMemRow < Y_SIZE-1)
				 rNextVideoMemRow  = oVideoMemRow + 1;
			      else
				 rNextVideoMemRow  = 0;
			   end

			rNextVideoMemCol  = 0;
			rHSyncCountReset  = 1'b1;
			rNextState 	  = `STATE_FRONT_PORCH;
		     end
	       end
	    //-----------------------------------
	    `STATE_FRONT_PORCH:
	       begin
		  if (rHSyncCount < 16'd47 || rCountEnable == 1'b0)
		     rNextState  = `STATE_FRONT_PORCH;
		  else
		     begin
			rHSyncCountReset  = 1'b1;
			rNextState 	  = `STATE_PULSE;
		     end
	       end
	 endcase
	 
      end

endmodule


module VGA_CONTROL_VS_FSM # (parameter X_WIDTH=8, parameter Y_WIDTH=8)
   (
    input wire 		     Clock,
    input wire 		     Reset,
    input wire [X_WIDTH-1:0] iCurrentCol,
    input wire [Y_WIDTH-1:0] iCurrentRow,
    output reg 		     oVGAVerticalSync
    );

   reg [3:0] 		     rCurrentState, rNextState;
   reg [31:0] 		     rTimeCount, rNextTimeCount;

   
   always @(posedge Clock)
      begin
	 if (Reset)
	    begin
	       rCurrentState <= `STATE_RESET;
	       rTimeCount    <= 32'b0;
	    end
	 else
	    begin
	       rTimeCount    <= rNextTimeCount;
	       rCurrentState <= rNextState;
	    end
      end
   
   always @(*) 
     begin
      //Default values
	oVGAVerticalSync  = 1'b1;
	rNextTimeCount 	  = rTimeCount + 32'd1;
	
	case (rCurrentState)
	   //-----------------------------------
	   `STATE_RESET:
	      begin
		 rNextState  = `STATE_DISPLAY;
	      end
	   //-----------------------------------
	   `STATE_DISPLAY:
	      begin
		 rNextTimeCount  = rTimeCount;
		 
		 if (iCurrentRow < `VGA_Y_RES-1 ||
		     (iCurrentRow == `VGA_Y_RES-1 && iCurrentCol < `VGA_X_RES-1))
		    rNextState  = `STATE_DISPLAY;
		 else
		    rNextState  = `STATE_FRONT_PORCH;
	      end
	   //-----------------------------------
	   `STATE_FRONT_PORCH:
	      begin
		 if (rTimeCount < 32'd16000)
		    rNextState  = `STATE_FRONT_PORCH;
		 else
		    begin
		       rNextTimeCount  = 1'b0;
		       rNextState      = `STATE_PULSE;
		    end
	      end
	   //-----------------------------------
	   `STATE_PULSE:
	      begin
		 oVGAVerticalSync  = 1'b0;

		 if (rTimeCount < 32'd3200)
		    rNextState 	= `STATE_PULSE;
		 else
		    begin
		       rNextTimeCount  = 1'b0;
		       rNextState      = `STATE_BACK_PORCH;
		    end
	      end
	   //-----------------------------------
	   `STATE_BACK_PORCH:
	      begin
		 if (rTimeCount < 32'd46400)
		    rNextState  = `STATE_BACK_PORCH;
		 else
		    begin
		       rNextTimeCount  = 1'b0;
		       rNextState      = `STATE_DISPLAY;
		    end
	      end
	   
	endcase
	
     end

   
endmodule
