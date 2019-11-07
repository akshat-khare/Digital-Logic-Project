----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/26/2016 01:21:48 AM
-- Design Name: 
-- Module Name: top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
  Port ( clk100 : in std_logic;
         cx,cy,cz    : in std_logic;
         rst    : in std_logic;
         ps2clk : inout std_logic;
         ps2data: inout std_logic;
         left   : out std_logic;
         mid    : out std_logic;
         right  : out std_logic;
         led    : out  STD_LOGIC_VECTOR (3 downto 0);
         segout : out  STD_LOGIC_VECTOR (7 downto 0));
end top;

architecture Behavioral of top is
component MouseCtl 
generic
(
   SYSCLK_FREQUENCY_HZ : integer := 100000000;
   CHECK_PERIOD_MS     : integer := 500; -- Period in miliseconds to check if the mouse is present
   TIMEOUT_PERIOD_MS   : integer := 100 -- Timeout period in miliseconds when the mouse presence is checked
);
port(
   clk         : in std_logic;
   rst         : in std_logic;
   xpos        : out std_logic_vector(11 downto 0);
   ypos        : out std_logic_vector(11 downto 0);
   zpos        : out std_logic_vector(3 downto 0);
   left        : out std_logic;
   middle      : out std_logic;
   right       : out std_logic;
   new_event   : out std_logic;
   value       : in std_logic_vector(11 downto 0);
   setx        : in std_logic;
   sety        : in std_logic;
   setmax_x    : in std_logic;
   setmax_y    : in std_logic;
   
   ps2_clk     : inout std_logic;
   ps2_data    : inout std_logic
   
);
end component;

component x47segdriver
    Port ( numin : in  STD_LOGIC_VECTOR (13 downto 0);  -- 14 bit hien thi so co 4 chu so
           dot : in  STD_LOGIC_VECTOR (2 downto 0);
           dau : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           led : out  STD_LOGIC_VECTOR (3 downto 0);
           segout : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

signal xpos,ypos: std_logic_vector(11 downto 0);
signal zpos: std_logic_vector(3 downto 0);
signal num : std_logic_vector(13 downto 0);
begin
num <= "00"&xpos when cx = '1' else
        "00"&ypos when cy = '1' else
        "0000000000"&zpos when cz = '1' else
        (others=>'0');

Inst_MouseCtl: MouseCtl PORT MAP(
                clk         => clk100,
                rst         => rst,
                xpos        => xpos,
                ypos        => ypos,
                zpos        => zpos,
                left        => left,
                middle      => mid,
                right       => right,
                new_event   => open,
                value       => x"000",
                setx        =>'0',
                sety        =>'0',
                setmax_x    =>'0',
                setmax_y    =>'0',
                
                ps2_clk     =>ps2clk,
                ps2_data    =>ps2data
                );
 
Inst_x47segdriver: x47segdriver PORT MAP(
               numin => num,
               dot => "000",
               dau => '0',
               clk => clk100,
               led => led,
               segout => segout 
               );
end Behavioral;
