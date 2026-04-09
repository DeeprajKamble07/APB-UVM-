module apb_assertion(input pclk, prst, psel, pwrite, penable, pready, pslverr,
                     input [31:0] pwdata, prdata, paddr);
  
  property p1;
    @(posedge pclk) disable iff(prst)
    $rose(penable) |-> $past(psel,1);
  endproperty
  
  p1_property: assert property(p1)
    else
      `uvm_error("ASSERT","penable rose without psel begin high 1st");
    
    
  property p2;
    @(posedge pclk) disable iff(prst)
    $rose(pready) |-> penable;
  endproperty
    
    p2_property: assert property(p2)
      else
        `uvm_error("ASSERT","pready asserted without penable");
      
   property p3;
     @(posedge pclk) disable iff(prst)
     $rose(pslverr) |-> pready;
   endproperty
      
      p3_property: assert property(p3)
        else
          `uvm_error("ASSERT","pslverr asserted without pready");
        
   property p4;
     @(posedge pclk) disable iff(prst)
     (psel && penable && (paddr>=4)) |=> pslverr;
   endproperty
        
        p4_property: assert property(p4)
          else
            `uvm_error("ASSERT","Invalid address dint not trigger pslverr");
        
   property p5;
     @(posedge pclk) disable iff(prst)
     (psel && penable && (paddr<4)) |=> !pslverr;
   endproperty
        
        p5_property: assert property(p5)
          else
            `uvm_error("ASSERT","Valid address caused PSLVERR unexpectedly");
        
        
   property p6;
     @(posedge pclk) disable iff(prst)
     $rose(prst) |=> (!pready && !pslverr && (prdata==0));
   endproperty
        
        p6_property: assert property(p6)
          else
            `uvm_error("ASSERT","Reset did not clear outputs properly");
        
   property p7;
     @(posedge pclk) disable iff(prst)
     (psel && penable) |-> psel;
   endproperty
        
        p7_property: assert property(p7)
          else
            `uvm_error("ASSERT","psel dropped during access phase");
        
   property p8;
     @(posedge pclk) disable iff(prst)
     (psel && !penable) |=> $stable(paddr);
   endproperty
        
        p8_property: assert property(p8)
          else
            `uvm_error("ASSERT","paddr changed between setup and access phase");
        
   
   property p9;
     @(posedge pclk) disable iff(prst)
     (psel && !penable && pwrite) |=> $stable(pwdata);
   endproperty
        
        p9_property: assert property(p9)
          else
            `uvm_error("ASSERT","pwdata changed between setup and access during pwrite");
        
   
        
   property p10;
     @(posedge pclk) disable iff(prst)
     $rose(penable) |-> ##[1:10] pready;
   endproperty
        
        p10_property: assert property(p10)
          else
            `uvm_error("ASSERT","pready did not assert within 10 cycles of penable");
       
            c_write_tx: cover property(
            @(posedge pclk) disable iff(prst)
            (psel && penable && pwrite && pready && !pslverr));
            
            
            c_read_tx: cover property(
            @(posedge pclk) disable iff(prst)
              (psel && penable && !pwrite && pready && !pslverr));
            
            
            c_write_err: cover property(
            @(posedge pclk) disable iff(prst)
            (psel && penable && pwrite && pready && pslverr));
            
            
            c_read_err: cover property(
            @(posedge pclk) disable iff(prst)
              (psel && penable && !pwrite && pready && pslverr));
            
endmodule  
            
   
