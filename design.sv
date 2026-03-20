module apb_master(input pclk, prst, transfer, pwrite,
                  input [31:0] paddr, pwdata,
                  input pready, pslverr,
                  input [31:0] prdata,

                  output logic psel, penable, pwrite_out,
                  output logic [31:0] paddr_out, pwdata_out, dataout,
                  output logic slverr, done);

  typedef enum logic [1:0] {idle, setup, access} state_t;
  state_t state, next_state;

  logic [31:0] paddr_reg;
  logic [31:0] pwdata_reg;
  logic        pwrite_reg;

  
  always_ff @(posedge pclk or posedge prst) begin
    if (prst) state <= idle;
    else      state <= next_state;
  end

  
  always_comb begin
    case (state)
      idle:    next_state = transfer ? setup : idle;
      setup:   next_state = access;
      access:  next_state = pready ? (transfer ? setup : idle) : access;
      default: next_state = idle;
    endcase
  end

  
  always_ff @(posedge pclk or posedge prst) begin
    if (prst) begin
      paddr_reg  <= 0;
      pwdata_reg <= 0;
      pwrite_reg <= 0;
    end else if (state == idle && next_state == setup) begin
      paddr_reg  <= paddr;
      pwdata_reg <= pwdata;
      pwrite_reg <= pwrite;
    end
  end

  
  always_comb begin
    psel       = 0;
    penable    = 0;
    paddr_out  = paddr_reg;
    pwrite_out = pwrite_reg;
    pwdata_out = pwdata_reg;
    done       = 0;

    case (state)
      idle: begin
        psel    = 0;
        penable = 0;
      end

      setup: begin
        psel    = 1;
        penable = 0;
      end

      access: begin
        psel    = 1;
        penable = 1;
        done    = pready;
      end

      default: begin
        psel    = 0;
        penable = 0;
      end
    endcase
  end

 
  assign dataout = prdata;
  assign slverr  = pslverr;

endmodule


module apb_slave(input pclk, prst, psel, penable, pwrite,
                 input  [31:0] paddr, pwdata,
                 output logic [31:0] prdata,
                 output logic pready, pslverr);

  logic [31:0] mem [0:3];

  
  logic valid_transfer;
  assign valid_transfer = psel && penable;

  logic valid_addr;
  assign valid_addr = (paddr < 4);

  
  always_ff @(posedge pclk or posedge prst) begin
    if (prst) begin
      for (int i = 0; i < 4; i++)
        mem[i] <= 0;
    end else if (valid_transfer && valid_addr && pwrite) begin
      mem[paddr] <= pwdata;
      $display("[SLAVE] WRITE: mem[%0h] = %0h", paddr, pwdata);
    end
  end

  
  always_comb begin
    if (valid_transfer && valid_addr && !pwrite)
      prdata = mem[paddr];
    else
      prdata = 0;
  end

  assign pready  = 1'b1;
  assign pslverr = valid_transfer && !valid_addr;

endmodule
