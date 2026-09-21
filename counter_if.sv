interface counter_if(input bit clock);

    logic [3:0] data_in;
    logic [3:0] data_out;
    logic load;
    logic up_down;
    logic reset;


    clocking dr_cb @(posedge clock);

        default input #1 output #0;

        output data_in;
        output load;
        output up_down;
        output reset;

    endclocking


    clocking wr_cb @(posedge clock);

        default input #1 output #0;

        input data_in;
        input load;
        input up_down;
        input reset;

    endclocking


    clocking rd_cb @(posedge clock);

        default input #1 output #0;

        input data_out;

    endclocking


    modport DRV_MP(
        clocking dr_cb
    );


    modport WR_MON_MP(
        clocking wr_cb
    );


    modport RD_MON_MP(
        clocking rd_cb
    );

endinterface
