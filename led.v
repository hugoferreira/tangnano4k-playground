module led (
    input clk,
    input rstn,
    output reg led_o
);

reg [23:0] counter;

always @(posedge clk or negedge rstn) begin
    if (!rstn)
        counter <= 24'd0;
    else if (counter < 24'd675_0000)
        counter <= counter + 1;
    else
        counter <= 24'd0;
end

always @(posedge clk or negedge rstn) begin
    if (!rstn)
        led_o <= 1'b1;
    else if (counter == 24'd675_0000)
        led_o <= ~led_o;
end

endmodule
