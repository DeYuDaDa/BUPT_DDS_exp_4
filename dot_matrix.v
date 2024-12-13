// Updated dot_matrix module with stop signal handling
module dot_matrix (
    input wire clk,           // Clock signal
    input wire rst,           // Reset signal
    input wire stop,          // Stop signal
    input wire [3:0] dice1,   // Dice 1 value (1-9)
    input wire [3:0] dice2,   // Dice 2 value (1-9)
    output reg [7:0] row,     // Row signal (ROW7 - ROW0)
    output reg [7:0] r_col,   // Red column signal (R_COL7 - R_COL0)
    output reg [7:0] g_col    // Green column signal
);

    reg [7:0] row_patterns;  // Row signal patterns
    reg [2:0] red_patterns[2:0];  // Red column patterns
    reg [2:0] green_patterns[2:0]; // Green column patterns
    reg [2:0] scan_index;         // Current scan row index (0~7)
    reg stop_flag;                // Internal flag for stopping display

    // Initialize registers
    initial begin
        row <= 8'b1111_1111;
        r_col <= 8'b0000_0000;
        g_col <= 8'b0000_0000;
        stop_flag <= 0;
    end

    // Handle dice1 (red) and dice2 (green) patterns
    always @(*) begin
        case (dice1)
            4'b0001: begin red_patterns[0] = 3'b000; red_patterns[1] = 3'b010; red_patterns[2] = 3'b000; end
            4'b0010: begin red_patterns[0] = 3'b001; red_patterns[1] = 3'b000; red_patterns[2] = 3'b100; end
            4'b0011: begin red_patterns[0] = 3'b100; red_patterns[1] = 3'b010; red_patterns[2] = 3'b001; end
            // Additional dice1 patterns...
            default: begin red_patterns[0] = 3'b000; red_patterns[1] = 3'b000; red_patterns[2] = 3'b000; end
        endcase

        case (dice2)
            4'b0001: begin green_patterns[0] = 3'b000; green_patterns[1] = 3'b010; green_patterns[2] = 3'b000; end
            4'b0010: begin green_patterns[0] = 3'b001; green_patterns[1] = 3'b000; green_patterns[2] = 3'b100; end
            4'b0011: begin green_patterns[0] = 3'b100; green_patterns[1] = 3'b010; green_patterns[2] = 3'b001; end
            // Additional dice2 patterns...
            default: begin green_patterns[0] = 3'b000; green_patterns[1] = 3'b000; green_patterns[2] = 3'b000; end
        endcase
    end

    // Display logic
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            row <= 8'b1111_1111;
            r_col <= 8'b0000_0000;
            g_col <= 8'b0000_0000;
            stop_flag <= 0;
        end else if (stop) begin
            stop_flag <= 1; // Freeze the current display
        end else if (!stop_flag) begin
            // Dynamic scanning logic
            case (scan_index)
                3'b000: begin row <= 8'b0111_1111; r_col[2:0] <= red_patterns[0]; g_col[2:0] <= green_patterns[0]; end
                3'b001: begin row <= 8'b1011_1111; r_col[2:0] <= red_patterns[1]; g_col[2:0] <= green_patterns[1]; end
                3'b010: begin row <= 8'b1101_1111; r_col[2:0] <= red_patterns[2]; g_col[2:0] <= green_patterns[2]; end
                // Additional scanning cases...
                default: begin row <= 8'b1111_1111; r_col <= 8'b0000_0000; g_col <= 8'b0000_0000; end
            endcase
            scan_index <= scan_index + 1;
        end
    end

endmodule