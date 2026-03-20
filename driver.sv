class driver extends uvm_driver #(seq_item);
  `uvm_component_utils(driver)
  virtual intf vif;
  seq_item item;
  
  function new(string name ="driver", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item=seq_item::type_id::create("item");
    if(!uvm_config_db #(virtual intf)::get(this,"","vif",vif))
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
    seq_item_port.get_next_item(item);
    
      if(item.prst)
      begin
        vif.prst<=1;
        vif.transfer<=0;
        vif.paddr<=0;
        vif.pwdata<=0;
        vif.pwrite<=0;
        repeat(4) @(posedge vif.pclk);
        vif.prst=0;
        @(posedge vif.pclk);
      end
    
      
      else if(!item.prst && item.pwrite)
      begin
        vif.prst<=0;
        vif.paddr<=item.paddr;
        vif.pwdata<=item.pwdata;
        vif.pwrite<=1;
        @(posedge vif.pclk);
        vif.transfer<=1;
        @(posedge vif.pclk);
        vif.transfer<=0;
        @(posedge vif.pclk);
      end
      
    
      else if(!item.prst && !item.pwrite)
      begin
        vif.prst<=0;
        vif.paddr<=item.paddr;
        vif.pwrite<=0;
        @(posedge vif.pclk);
        vif.transfer<=1;
        @(posedge vif.pclk);
        vif.transfer<=0;
        @(posedge vif.pclk);  
      end
      
      seq_item_port.item_done();
    end
  endtask
endclass
