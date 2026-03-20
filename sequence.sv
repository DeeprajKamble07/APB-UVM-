class apb_rst extends uvm_sequence;
  `uvm_object_utils(apb_rst)
  seq_item item1;
  function new(string name ="apb_rst");
    super.new(name);
  endfunction
  
  task body();
    item1=new();
    start_item(item1);
    item1.randomize() with {prst==1;};
    finish_item(item1);
  endtask
endclass

class apb_write extends uvm_sequence;
  `uvm_object_utils(apb_write)
  seq_item item2;
  function new(string name ="apb_write");
    super.new(name);
  endfunction
  
  task body();
    item2=new();
    start_item(item2);
    item2.randomize() with {prst==0; pwrite==1;};
    finish_item(item2);
  endtask
endclass


class apb_read extends uvm_sequence;
  `uvm_object_utils(apb_read)
    seq_item item3;
  function new(string name ="apb_read");
    super.new(name);
  endfunction
  rand logic [31:0] read_addr;
  
  task body();
    item3=new();
    start_item(item3);
    item3.randomize() with {prst==0; pwrite==0; paddr==read_addr;};
    finish_item(item3);
  endtask
endclass
