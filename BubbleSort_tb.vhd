library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
use     ieee.math_real.all;

entity BubbleSort_tb is
    generic (
        DATA_WIDTH      :   positive    :=  16;
        LIST_SIZE       :   positive    :=  10
    );
end BubbleSort_tb;

architecture Behavioral of BubbleSort_tb is

    -- Clock and reset signals
    constant Tclk       :   time        :=  1 us;
    signal stop_clk     :   boolean     :=  false;    

    -- DUT signals
    signal clk          :   std_logic;
    signal rst          :   std_logic;
    signal i_en         :   std_logic;
    signal i_data       :   std_logic_vector(DATA_WIDTH-1 downto 0);
    signal o_en         :   std_logic;
    signal o_data       :   std_logic_vector(DATA_WIDTH-1 downto 0);

    -- Internal signals
    signal stop_stimuli :   boolean     :=  false;
    signal index        :   integer range 0 to LIST_SIZE-1;
    type slv_array is array (0 to LIST_SIZE-1) of std_logic_vector(DATA_WIDTH-1 downto 0);    
    signal stimuli      :   slv_array   :=  (x"AF21", x"92AB", x"1723", x"FA5C",
                                            x"AF21", x"52AB", x"1B23", x"FBBC",
                                            x"059D", x"A341");

begin

    -- DUT instantiation
    DUT :   entity work.BubbleSort(Behavioral)
        generic map (
            DATA_WIDTH  =>  DATA_WIDTH,
            LIST_SIZE   =>  LIST_SIZE
        )   
        port map (
            clk         =>  clk,
            rst         =>  rst,
            i_en        =>  i_en,
            i_data      =>  i_data,
            o_en        =>  o_en,
            o_data      =>  o_data
        ); 

    -- Clock generator
    process
    begin
        while not stop_clk loop
            clk <=  '1';
            wait for Tclk/2;
            clk <=  '0';
            wait for Tclk/2;
        end loop;
        wait for 25 us;
        wait;
    end process;

    -- Reset generator
    process
    begin
        rst <=  '0';
        wait for 25 us;
        rst <=  '1';
        wait;
    end process;

    -- Stimuli generator
    process
    begin
        while not stop_stimuli loop
            if rst = '0' then
                index   <=  0;
                i_en    <=  '0';
                i_data  <=  (others => '0');
            elsif index < LIST_SIZE then 
                index   <=  index + 1;
                i_en    <=  '1';
                i_data  <=  stimuli(index);
            elsif index = LIST_SIZE then 
                stop_stimuli    <=  true;
                index           <=  0;
                i_en            <=  '0';
                i_data          <=  (others => '0');
            end if;
            wait until clk = '1';
        end loop;
        wait for 200 us;
        stop_clk    <=  true;
        wait;
    end process;

end Behavioral;