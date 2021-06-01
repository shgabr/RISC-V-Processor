

module testbench;

    
    reg clk, reset;
    reg [1:0] led_sel;
    reg [3:0] ssd_sel;
    wire [7:0] leds; 
    wire [12:0] ssd;
    
    parameter Period = 10;
    
    processor_main RISV_V_MINA_SHERIF_PROCESSOR (clk, reset, led_sel, ssd_sel, leds, ssd);
    
    
    initial begin
        clk = 0;
        reset = 1;
        led_sel = 2'b01;
        ssd_sel = 0;
        #(10*Period) reset = 0;
   
    end
    
    
    always #(Period/2) clk = ~clk;



endmodule
