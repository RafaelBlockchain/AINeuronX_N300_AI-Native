always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out_valid <= 0;
    end else begin
        out_valid <= $random % 2;
        out_flit[3:0]    <= $random % 4;
        out_flit[7:4]    <= $random % 4;
        out_flit[9:8]    <= $random % 2;
        out_flit[11:10]  <= ($random % 3);
        out_flit[31:16]  <= $time; // timestamp
        out_flit[127:32] <= $random;
    end
end

