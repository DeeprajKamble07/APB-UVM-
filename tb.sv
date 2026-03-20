
`timescale 1ns/1ns
`include "uvm_macros.svh"
import uvm_pkg::*;
`include "interface.sv"
`include "sequence_item.sv"
`include "sequence.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "enivornment.sv"
`include "test.sv"

module top;
  logic pclk;
  
  intf intff(pclk);
  
  apb_master dut1(.pclk(intff.pclk),.prst(intff.prst),.transfer(intff.transfer),.pwrite(intff.pwrite),.paddr(intff.paddr),.pwdata(intff.pwdata),.pready(intff.pready),.prdata(intff.prdata),.pslverr(intff.pslverr),.psel      (intff.psel),.penable(intff.penable),.paddr_out(intff.paddr_out),.pwrite_out(intff.pwrite_out),.pwdata_out(intff.pwdata_out),.dataout(intff.dataout),.slverr(intff.slverr),.done(intff.done));
  
  apb_slave dut2(.pclk(intff.pclk),.prst(intff.prst),.psel(intff.psel),.penable(intff.penable),.pwrite  (intff.pwrite_out),.paddr(intff.paddr_out),.pwdata(intff.pwdata_out),.prdata(intff.prdata),.pready(intff.pready),.pslverr (intff.pslverr));
  
  initial begin
    pclk=0;
    forever #5 pclk=~pclk;
  end
  
  initial begin
    uvm_config_db #(virtual intf)::set(null,"*","vif",intff);
  end
  
  initial begin
    run_test("test");
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end
endmodule
  
