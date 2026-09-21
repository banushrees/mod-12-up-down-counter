class counter_driver;

    virtual counter_if.DRV_MP dr_if;

    mailbox #(counter_trans) gen2dr;

    counter_trans data2duv;


    function new(
        virtual counter_if.DRV_MP dr_if,
        mailbox #(counter_trans) gen2dr
    );

        this.dr_if = dr_if;
        this.gen2dr = gen2dr;

    endfunction


    virtual task drive();

        @(dr_if.dr_cb);

        dr_if.dr_cb.load    <= data2duv.load;
        dr_if.dr_cb.data_in <= data2duv.data_in;
        dr_if.dr_cb.up_down <= data2duv.up_down;
        dr_if.dr_cb.reset   <= data2duv.reset;

        data2duv.display("driver");

    endtask


    virtual task start();

        fork

            forever
            begin

                gen2dr.get(data2duv);

                drive();

            end

        join_none

    endtask

endclass
