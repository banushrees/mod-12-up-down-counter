class counter_sb;

    event DONE;

    counter_trans rm_data_h;
    counter_trans sb_data;
    counter_trans cov_data;

    static int ref_data;
    static int rm_data;
    static int data_verified;

    mailbox #(counter_trans) ref2sb;
    mailbox #(counter_trans) rdm2sb;


    function new(
        mailbox #(counter_trans) ref2sb,
        mailbox #(counter_trans) rdm2sb
    );

        this.ref2sb = ref2sb;
        this.rdm2sb = rdm2sb;

        this.coverage = new();

    endfunction


    //------------------------- Coverage -------------------------

    covergroup coverage;

        RST: coverpoint cov_data.reset
        {
            bins reset_0 = {0};
            bins reset_1 = {1};
        }

        MODE: coverpoint cov_data.up_down
        {
            bins UP   = {0};
            bins DOWN = {1};
        }

        LOAD: coverpoint cov_data.load
        {
            bins load_0 = {0};
            bins load_1 = {1};
        }

        DATA_IN: coverpoint cov_data.data_in
        {
            bins data_in[] = {[0:11]};
        }

        DATA_OUT: coverpoint cov_data.data_out
        {
            bins data_out[] = {[0:11]};
        }

        CR: cross RST,MODE,LOAD,DATA_IN;

    endgroup


    //------------------------- Start -------------------------

    virtual task start();

        fork

            forever
            begin

                // Get expected transaction
                ref2sb.get(rm_data_h);

                // Get actual transaction
                rdm2sb.get(sb_data);

                // One transaction is actually compared
                ref_data++;
                rm_data++;

                check(sb_data);

            end

        join_none

    endtask


    //------------------------- Check -------------------------

    virtual task check(counter_trans rdata);

        if(rm_data_h.data_out == rdata.data_out)
        begin

            $display("------------------------------------");
            $display("             DATA VERIFIED");
            $display("Expected = %0d",rm_data_h.data_out);
            $display("Actual   = %0d",rdata.data_out);
            $display("------------------------------------");

        end

        else
        begin

            $display("------------------------------------");
            $display("             DATA MISMATCH");
            $display("Expected = %0d",rm_data_h.data_out);
            $display("Actual   = %0d",rdata.data_out);
            $display("------------------------------------");

        end


        data_verified++;


        // Copy transaction for coverage
        cov_data = new();

        cov_data.reset    = rm_data_h.reset;
        cov_data.up_down  = rm_data_h.up_down;
        cov_data.load     = rm_data_h.load;
        cov_data.data_in  = rm_data_h.data_in;
        cov_data.data_out = rm_data_h.data_out;


        // Sample coverage
        coverage.sample();


        if(data_verified == number_of_transactions)
        begin

            $display("------------------------------------");
            $display("     %0d TRANSACTIONS COMPLETED",
                     number_of_transactions);
            $display("------------------------------------");

            ->DONE;

        end


        $display("coverage = %0.2f %%",coverage.get_coverage());

    endtask


    //------------------------- Report -------------------------

    function void report();

        $display("==========================================");
        $display("             SCOREBOARD REPORT");
        $display("==========================================");

        $display("Data Compared   = %0d",data_verified);
        $display("Expected Data   = %0d",ref_data);
        $display("Actual Data     = %0d",rm_data);
        $display("Coverage        = %0.2f %%",coverage.get_coverage());

        $display("==========================================");

    endfunction

endclass
