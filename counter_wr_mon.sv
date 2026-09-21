class counter_wr_mon;

    virtual counter_if.WR_MON_MP wr_mon_if;

    mailbox #(counter_trans) mon2rm;

    counter_trans wr_data;


    function new(
        virtual counter_if.WR_MON_MP wr_mon_if,
        mailbox #(counter_trans) mon2rm
    );

        this.wr_mon_if = wr_mon_if;
        this.mon2rm = mon2rm;

        this.wr_data = new();

    endfunction


    virtual task monitor();

        @(wr_mon_if.wr_cb);

        wr_data = new();

        wr_data.load    = wr_mon_if.wr_cb.load;
        wr_data.reset   = wr_mon_if.wr_cb.reset;
        wr_data.up_down = wr_mon_if.wr_cb.up_down;
        wr_data.data_in = wr_mon_if.wr_cb.data_in;

    endtask


    virtual task start();

        fork

            forever
            begin

                monitor();

                mon2rm.put(wr_data);

                $display("write monitor is working");

            end

        join_none

    endtask

endclass
