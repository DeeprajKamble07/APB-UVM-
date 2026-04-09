class apb_coverage extends uvm_subscriber #(seq_item);
  `uvm_component_utils(apb_coverage)
  seq_item item;
  
  covergroup cg1;
    cp_pwrite: coverpoint item.pwrite{bins WRITE={1};
                                      bins READ={0};}
    
    cp_pslverr: coverpoint item.pslverr{bins no_error={0};
                                        bins error={1};}
  endgroup: cg1
  
  covergroup cg2;
    cp_addr: coverpoint item.paddr {bins valid_addr={[0:31]};
                                    bins invalid_addr={[32:32'hFFFF_FFFF]};}
    
    cp_addr_each: coverpoint item.paddr {bins addr[]={[0:31]};}
    
    cp_addr_boundary: coverpoint item.paddr{bins max_addr={31};
                                            bins min_addr={0};
                                            bins mid_addr={[1:30]};}
  endgroup: cg2
  
  covergroup cg3;
    cp_wdata : coverpoint item.pwdata {bins zero={0};
                                       bins max={32'hFFFF_FFFF};
                                       bins mid={[1:32'hFFFF_FFFE]};
                                      option.auto_bin_max = 8; }
    
    cp_rdata: coverpoint item.prdata {bins zero={0};
                                      bins non_zero={[1:32'hFFFF_FFFE]};
                                      option.auto_bin_max = 8; }
    
  endgroup: cg3
  
  
  covergroup cg4;
    cp_valid_addr: coverpoint item.paddr{bins valid_addr= {[0:31]};
                                         bins invalid_addr= {[32:32'hFFFF_FFFF]};}
    
    cp_pslverr: coverpoint item.pslverr{bins no_error={0};
                                        bins error={1};}
  endgroup: cg4
  
  
    
  function new(string name="apb_coverage", uvm_component parent);
    super.new(name,parent);
    cg1=new();
    cg2=new();
    cg3=new();
    cg4=new();
  endfunction
  
  function void write(seq_item t);
    item=t;
    cg1.sample();
    cg2.sample();
    cg3.sample();
    cg4.sample();
  endfunction
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("COV",$sformatf("operation coverage: %.2f%%", cg1.get_coverage()), UVM_NONE)
    `uvm_info("COV",$sformatf("address coverage: %.2f%%", cg2.get_coverage()), UVM_NONE)
    `uvm_info("COV",$sformatf("data coverage: %.2f%%", cg3.get_coverage()), UVM_NONE)
    `uvm_info("COV",$sformatf("error coverage: %.2f%%", cg4.get_coverage()), UVM_NONE)
    `uvm_info("COV",$sformatf("total coverage: %.2f%%", $get_coverage()), UVM_NONE)
  endfunction
endclass
