`timescale 1ns / 1ps

`define STATE_RESET 0
`define STATE_PULSE 1
`define STATE_BACK 2
`define STATE_DISPLAY 3
`define STATE_FRONT 4

module Display_VGA # (parameter XWidth = 8,
		      parameter YWidth = 8,
		      parameter X_length = 256,
		      parameter Y_length =256
		      )
   (		   
		   input wire 		  Clock,
		   input wire 		  Reset,
		   output reg [XWidth-1:0] oCol,
		   output reg [YWidth-1:0] oRow,
		   output reg 		  oHSync,
		   output reg 		  oVSync,
		   output reg 		  oDisplay
		   );

   reg [3:0] 				  rCurrentState,rNextState;
   reg [16:0] 				  rTimeCount;
   reg 					  rTimeCountReset,VFinish;
   reg [XWidth-1:0] 			  rNextCol;
   reg [YWidth-1:0] 			  rNextRow;
   

   always @ ( posedge Clock )
     begin
	if (Reset)
	  begin
	     rCurrentState <= `STATE_RESET;
	     rTimeCount <= 16'b0;
	  end
	else
	  begin
	     rCurrentState <= rNextState;
	       if (rTimeCountReset)
		 begin
		    rTimeCount <= 16'b0; // resets count
		 end
	       else
		 begin
		    rTimeCount <= rTimeCount + 16'b1; // increments count
		    oCol <= rNextCol;
		    oRow <= rNextRow;
		 end
	  end
     end

   always @ ( * )
     begin
	case (rCurrentState)
	  //-----------------------------------------------------------------------
	  
	  `STATE_RESET:
	    begin
	       rNextCol = 				10'h0;
	       rNextRow = 				9'h0;
	       rTimeCountReset =                        1'b1;
	       oHSync =                                 1'b1;
	       oVSync =                                 1'b1;
	       oDisplay =                               1'b0;
	       VFinish =                                1'b0;
	       
	       rNextState = 				`STATE_PULSE;
	    end
	  
	  //-------------------------------------------------------------------------
	  
	  `STATE_PULSE:
	    begin
	       rNextCol =                            	10'h0; 
	       rNextRow = 				oRow;
	       oDisplay =                               1'b0;

	       if (VFinish)
		 begin
		    oVSync =                            1'b0;
		    oHSync =                            1'b1;
		 end
	       else
		 begin
		    oVSync =                            1'b1;
		    oHSync =                            1'b0;
		 end

	       
	       if(rTimeCount < 16'd95)
		 begin
		    rTimeCountReset =                   1'b0;
		    rNextState = 		       	`STATE_PULSE;
		 end
	       else
		 begin
		    rTimeCountReset =                     1'b1;
		    VFinish =                             1'b0;
		    rNextState = 			  `STATE_BACK;
		 end
	    end // case: `STATE_PULSE

	  //--------------------------------------------------------------------------

	  `STATE_BACK:
	    begin
	       rNextCol =                            	10'h0; 
	       rNextRow = 				oRow;
	       oHSync =                                 1'b1;
	       oVSync =                                 1'b1;
	       oDisplay =                               1'b0;
	       VFinish = 1'b0;

	       if(rTimeCount < 16'd47)
		 begin
		    rTimeCountReset =                        1'b0;
		    rNextState = 				`STATE_BACK;
		 end
	       else
		 begin
		    rTimeCountReset =                        1'b1;
		    rNextState = 				`STATE_DISPLAY;
		 end
	    end // case: `STATE_BACK

	  //--------------------------------------------------------------------------

	  `STATE_DISPLAY:
	    begin
	       rNextCol =                            	oCol + 10'd1; 
	       oHSync =                                 1'b1;
	       oVSync =                                 1'b1;
	       oDisplay =                               1'b1;
	       rTimeCountReset =                        1'b0;

	       if(rTimeCount < X_length)
		 begin
		    rNextRow = oRow;
		    VFinish = 1'b0;
		    rNextState = `STATE_DISPLAY;
		 end
	       else
		 begin
		    if(oRow < Y_length)
		      begin
			 rNextRow = oRow + 9'd1;
			 VFinish = 1'b0;
		      end
		    else
		      begin
			 rNextRow = 9'd0;
			 VFinish = 1'b1;
		      end
		    rNextCol = 10'd0;
		    rTimeCountReset = 1'b1;
		    rNextState = `STATE_FRONT;
		 end // else: !if(TimeCount < X_length)
	    end // case: `STATE_DISPLAY

	  //--------------------------------------------------------------------------

	  `STATE_FRONT:
	    begin
	       rNextCol =                            	10'h0; 
	       rNextRow = 				oRow;
	       oHSync =                                 1'b1;
	       oVSync =                                 1'b1;
	       oDisplay =                               1'b0;
	       VFinish =                                VFinish;

	       if(rTimeCount < 16'd16)
		 begin
		    rTimeCountReset =                        1'b0;
		    rNextState = 			     `STATE_FRONT;
		 end
	       else
		 begin
		    rTimeCountReset =                        1'b1;
		    rNextState = 			     `STATE_PULSE;
		 end
	    end // case: `STATE_FRONT

	  //-------------------------------------------------------------------------------

	  default:
	    begin
	       rNextCol =                            	10'h0; 
	       rNextRow = 				9'h0;
	       oHSync =                                 1'b1;
	       oVSync =                                 1'b1;
	       oDisplay =                               1'b0;
	       VFinish =                                1'b0;
	       rTimeCountReset =                        1'b0;
	       rNextState =                             `STATE_RESET;
	    end // case: default
	  endcase
	 end
endmodule
