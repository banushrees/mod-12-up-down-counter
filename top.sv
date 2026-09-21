module top();

    import counter_pkg::*;

    parameter cycle = 10;

    reg clock;

    counter_if DUV_IF(clock);

    test t_h;


    // DUT
    counter DUV(
        .clock    (clock),
        .reset    (DUV_IF.reset),
        .up_down  (DUV_IF.up_down),
        .load     (DUV_IF.load),
        .data_in  (DUV_IF.data_in),
        .data_out (DUV_IF.data_out)
    );


    // Test
    initial
    begin

        t_h = new(
            DUV_IF,
            DUV_IF,
            DUV_IF
        );

        number_of_transactions = 100;


        // Initial reset
        DUV_IF.reset   = 1'b1;
        DUV_IF.load    = 1'b0;
        DUV_IF.up_down = 1'b0;
        DUV_IF.data_in = 4'd0;


        // Wait for reset to be sampled by DUT
        repeat(2)
            @(posedge clock);


        // Release reset
        DUV_IF.reset = 1'b0;


        t_h.build();

        t_h.run();

        $finish;

    end


    // Clock generation
    initial
    begin

        clock = 1'b0;

        forever #(cycle/2)
            clock = ~clock;

    end

endmodule
