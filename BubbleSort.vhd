----------------------------------------------------------------------------------
-- Engineer: Yohan Curbel Anglés
-- 
-- Create Date: 23.12.2021
-- Module Name: BubbleSort - Behavioral
--
-- Description: 
-- 1. Customizable Bubble sort technique
-- 2. Serial input
-- 3. Serial output sends lowers first 
--
-- Descripción:
-- 1. Tecnica Bubble, configurable, para el sorteo de listas
-- 2. Entrada serial.
-- 3. Salida serial, enviando primero los valores mas bajos
----------------------------------------------------------------------------------

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
use     ieee.math_real.all;

entity BubbleSort is
    generic (
        DATA_WIDTH  :   positive    :=  12;
        LIST_SIZE   :   positive    :=  8
    );
    port (
        clk         :   in    std_logic;
        rst         :   in    std_logic;
        i_en        :   in    std_logic;
        i_data      :   in    std_logic_vector(DATA_WIDTH-1 downto 0);
        o_en        :   out   std_logic;
        o_data      :   out   std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end BubbleSort;

architecture Behavioral of BubbleSort is

    -- States declaration
    type states is (idle, check, sort, outputs);
    signal state        :   states;

    -- Internal signals
    type slv_array is array (0 to LIST_SIZE-1) of std_logic_vector(DATA_WIDTH-1 downto 0);    
    signal sorted_list  :   slv_array;
    signal index        :   integer range 0 to LIST_SIZE-1; 

begin

    fsm     :   process(clk)
    begin
        if rising_edge(clk) then
            if rst = '0' then
                state       <=  idle;
                index       <=  0;
                o_en        <=  '0';
                o_data      <=  (others => '0');
                sorted_list <=  (others => (others => '0'));                
            else
                case state is
                    when idle   =>  -- Save data input and next state
                                    if i_en = '1' then
                                        sorted_list(index)  <=  i_data;
                                        if index = LIST_SIZE-1 then
                                            state   <=  check;
                                            index   <=  0;
                                        else
                                            index   <=  index + 1;  
                                        end if;                                                                              
                                    end if;
                                    
                                    -- Outputs
                                    o_en        <=  '0';
                                    o_data      <=  (others => '0');

                    when check  =>  -- Check the sorting
                                    if index <= LIST_SIZE-2 then                                        
                                        if signed(sorted_list(index)) > signed(sorted_list(index+1)) then
                                            state   <=  sort;
                                            index   <=  0;
                                        else
                                            index   <=  index + 1;
                                        end if;
                                    else
                                        index       <=  0;
                                        state       <=  outputs;
                                    end if;

                    when outputs    =>  -- Serial outputs
                                        o_en    <=  '1';
                                        o_data  <=  sorted_list(index);
                                        if index < LIST_SIZE-1 then
                                            index   <=  index + 1;
                                        else
                                            index   <=  0;
                                            state   <=  idle;
                                        end if;

                    when sort       =>  -- Arrange the sorted_list
                                        if signed(sorted_list(index)) > signed(sorted_list(index+1)) then
                                            sorted_list(index)    <=  sorted_list(index+1);
                                            sorted_list(index+1)  <=  sorted_list(index);
                                        else
                                            sorted_list(index)    <=  sorted_list(index);
                                            sorted_list(index+1)  <=  sorted_list(index+1);   
                                        end if;
                                        
                                        -- Update index    
                                        if index < LIST_SIZE-2 then
                                            index   <=  index + 1;                                            
                                        else
                                            index   <=  0;
                                            state   <=  check;
                                        end if;
                end case;
            end if;
        end if;
    end process;

end Behavioral;