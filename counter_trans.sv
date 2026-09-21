class counter_trans;

    rand logic [3:0] data_in;
    logic [3:0] data_out;

    rand bit load;
    rand bit up_down;
    rand bit reset;

    // Constraints
    constraint c1 {data_in inside {[0:11]};}

    constraint c2 {load dist {1 := 50, 0 := 50};}

    constraint c3 {up_down dist {1 := 50, 0 := 50};}

    constraint c4 {reset dist {1 := 50, 0 := 50};}


    // Display method
    virtual function void display(input string s);
    begin
        $display("----------%s----------",s);
        $display("up_down = %0d",up_down);
        $display("load = %0d",load);
        $display("data_in = %0d",data_in);
        $display("data_out = %0d",data_out);
        $display("reset = %0d",reset);
        $display("-----------------------------------");
    end
    endfunction


    function void post_randomize();
        display("randomization completed");
    endfunction

endclass
