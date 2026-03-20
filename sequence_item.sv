class seq_item extends uvm_sequence_item;
  `uvm_object_utils(seq_item)
  
  rand logic prst, transfer, pwrite;
  rand logic [31:0] paddr, pwdata;
  
  logic  pready, pslverr;
  logic [31:0] prdata;

  logic  psel, penable, pwrite_out, slverr;
  logic  [31:0] dataout, paddr_out, pwdata_out;
  logic done;
  
  constraint c1{paddr inside {[0:3]};}
  
  function new(string name="seq_item");
    super.new(name);
  endfunction
endclass
