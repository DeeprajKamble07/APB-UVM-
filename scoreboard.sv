class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  uvm_analysis_imp #(seq_item, scoreboard) scb_port;
  
  bit [31:0] mem[4];
  bit [31:0] dout;
  
  function new(string name="scoreboard",uvm_component parent);
    super.new(name,parent);
    scb_port=new("scb_port",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  function void write(seq_item item);
    if(item.prst)
      begin
        foreach(mem[i]) mem[i]=0;
        `uvm_info("SCB","system reset detection",UVM_NONE);
      end
    
    else if(item.pwrite==1)
      begin
        mem[item.paddr] =item.pwdata;
        `uvm_info("SCB",$sformatf("WRITE: mem[%0h]=%0h written into mem",item.paddr,item.pwdata),UVM_NONE);
      end
    
    else if(item.pwrite==0)
      begin
        dout=mem[item.paddr];
        `uvm_info("SCB",$sformatf("READ: mem[%0h]=%0h dataout %0h read from mem",item.paddr, dout, item.dataout),UVM_NONE);
            if(dout==item.dataout)
              begin
                `uvm_info("SCB PASS", $sformatf("MATCH: mem[%0h]=%0h == dataout=%0h",item.paddr, dout, item.dataout), UVM_NONE);;
              end
            else
              begin
                `uvm_error("SCB FAIL", $sformatf("MISMATCH: mem[%0h]=%0h != dataout=%0h",item.paddr, dout, item.dataout));
              end
          end
  endfunction
endclass
