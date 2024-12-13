// Enhanced Testbench for dice game
`timescale 1ms / 10ns

module tb_dice_game();

    reg clk;
    reg rst;
    reg start1;    // Player 1 button
    reg start2;    // Player 2 button
    wire [7:0] row;
    wire [7:0] r_col;
    wire [7:0] g_col;
    wire clk_div;
    wire [3:0] dice1;
    wire [3:0] dice2;
    wire [7:0] signal;
    wire [7:0] cat;
    wire [15:0] rgb_led;

    // Instantiate the dice module
    dice uut (
        .clk(clk),
        .rst(rst),
        .start1(start1),
        .start2(start2),
        .row(row),
        .r_col(r_col),
        .g_col(g_col),
        //.clk_div(clk_div),
        .dice1(dice1),
        .dice2(dice2),
        .signal(signal),
        .cat(cat),
        .rgb_led(rgb_led),
		  .divided_clk(divided_clk)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test sequence
    initial begin
        // Initialize inputs
        rst = 0;
        start1 = 0;
        start2 = 0;

        // Reset the system
        #10 rst = 1;
        #10 rst = 0;
        //#10 rst = 1;

        // Simulate Player 1 rolling the dice
        #50 start1 = 1;
        repeat (20) begin // Increase repeat count for detailed monitoring
            #20 $display("Player 1 rolling dice: %d, LFSR: %b", dice1, uut.u_roll.u_random1.lfsr);
				$display("Roll 1: %d",uut.u_roll.u_random1.roll);
        end
        #200 start1 = 0;
        $display("Player 1 dice stopped: %d", dice1);

        // Simulate Player 2 rolling the dice
        #50 start2 = 1;

        repeat (20) begin // Increase repeat count for detailed monitoring
            #20 $display("Player 2 rolling dice: %d, LFSR: %b", dice2, uut.u_roll.u_random2.lfsr);
				$display("Roll 2: %d",uut.u_roll.u_random2.roll);
        end
        #200 start2 = 0;
        $display("Player 2 dice stopped: %d", dice2);

        // Wait for next round
        #300;
        $display("Round complete. Dice1: %d, Dice2: %d", dice1, dice2);

        // Simulate another round
        #500;
        start1 = 1; start2 = 1;
        repeat (199) begin
            #200 $display("Rolling dice - Player 1: %d, LFSR: %b, Player 2: %d, LFSR: %b", dice1, uut.u_roll.u_random1.lfsr, dice2, uut.u_roll.u_random2.lfsr);
				$display("Start1: %b, Start2: %b, Roll1: %b, Roll2: %b", start1, start2, uut.u_roll.u_random2.roll, uut.u_roll.u_random2.roll);
				$display("Finish1: %d  Finish2: %d", uut.u_roll.u_random1.finish, uut.u_roll.u_random2.finish);
				//$display("divide_clk: ", uut.divided_clk);
        end
        #2000 start1 = 0; start2 = 0;
        $display("Next round - Player 1 dice: %d, Player 2 dice: %d", dice1, dice2);

        // Wait and observe
        #2000;
        $display("Final state - Dice1: %d, Dice2: %d", dice1, dice2);

        $stop;
    end

endmodule