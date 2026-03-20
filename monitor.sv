class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  virtual intf vif;
  seq_item item;
  uvm_analysis_port #(seq_item) monitor_port;
  
  function new(string name ="monitor", uvm_component parent);
    super.new(name,parent);
    monitor_port=new("monitor_port",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item=seq_item::type_id::create("item");
    if(!uvm_config_db #(virtual intf)::get(this,"*","vif",vif))
      begin
        `uvm_error("DRV","failed to get vif from config db");
      end
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      @(posedge vif.pclk iff (vif.prst==1'b1 || vif.transfer==1'b1));
        item=seq_item::type_id::create("item");
      
        item.prst=vif.prst;
        item.transfer=vif.transfer;
        item.pwrite=vif.pwrite;
        item.paddr=vif.paddr;
        item.pwdata=vif.pwdata;
      
      if(vif.prst)
        begin
          `uvm_info("MON", $sformatf("prst=%0b pwrite=%0d paddr=%0h dataout=%0h",item.prst, item.pwrite, item.paddr, item.dataout), UVM_LOW);
        monitor_port.write(item);
          @(posedge vif.pclk iff (vif.prst ==1'b0));
        end
      
      else begin
        @(posedge vif.pclk iff  (vif.done==1'b1));
        item.pready=vif.pready;
        item.pslverr=vif.pslverr;
        item.prdata=vif.prdata;
        item.psel=vif.psel;
        item.penable=vif.penable;
        item.pwrite_out=vif.pwrite_out;
        item.slverr=vif.slverr;
        item.paddr_out=vif.paddr_out;
        item.pwdata_out=vif.pwdata_out;
        item.done=vif.done;
		item.dataout= vif.dataout;
        `uvm_info("MON", $sformatf("prst=%0b pwrite=%0d paddr=%0h pwdata=%0h dataout=%0h",item.prst, item.pwrite, item.paddr, item.pwdata, item.dataout), UVM_LOW);
        monitor_port.write(item);
        end
    end
  endtask
endclass
