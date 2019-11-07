----------------------------------------------------------------------------------
-- Engineer: Tuandzr
-- Create Date:    14:07:40 01/03/2016 
-- Module Name:    x47segdriver - Behavioral 
-- Project Name:  x4 7 seg driver
-- numin: so vao
-- dot : vi tri dau . 000,001,010,011,100
-- clk : clock vao
-- led : anode
-- segout : seg anode
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity x47segdriver is
    Port ( numin : in  STD_LOGIC_VECTOR (13 downto 0);  -- 14 bit hien thi so co 4 chu so
           dot : in  STD_LOGIC_VECTOR (2 downto 0);
           dau : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           led : out  STD_LOGIC_VECTOR (3 downto 0);
           segout : out  STD_LOGIC_VECTOR (7 downto 0));
end x47segdriver;

architecture Behavioral of x47segdriver is

-------------------
function tach(a,scs,vt: integer) return integer is
variable a1,kq,d: integer;
begin
a1:=a;
for i in scs downto vt loop
for kq in 0 to 9 loop
if kq*10**(i-1)<= a1 and a1 < (kq+1)*10**(i-1) then d:= kq; end if;
end loop;
a1 := a1 - d*10**(i-1);
end loop;
return d;
end tach;
----------------
function decoder(val: integer range 0 to 9) return std_logic_vector is
begin
case val is
	when 0 => return x"c0";
	when 1 => return x"f9";
	when 2 => return x"a4";
	when 3 => return x"b0";
	when 4 => return x"99";
	when 5 => return x"92";
	when 6 => return x"82";
	when 7 => return x"f8";
	when 8 => return x"80";
	when 9 => return x"90";
end case;
end decoder;
----------------------
signal c : integer range 1 to 4 := 1;
signal so,cham: integer :=0;
begin
so <= conv_integer(numin);
cham <= conv_integer(dot);
	
clk_generate: process(clk)
	variable count: integer := 0;
	begin
		if rising_edge(clk) then
			if count = 10000 then
				count := 0;
				if c = 4 then c <= 1; else c<=c+1; end if;
			else
				count := count + 1;
			end if;
		end if;
	end process;
	
xuat: process(c,so)
	variable fg : integer;
	begin
		if so >= 1000 then fg := 5;  --------1234
			elsif so >=100 then fg := 4; 
			elsif so >=10 then fg := 3;
			elsif so >=0 then fg := 2; end if;
			
		Case c is
			when 1 =>if c < fg or (dau = '1' and c = fg ) then led  <= "1110"; 
						elsif dau = '0' or (dau = '1' and c > fg) then led <= "1111"; 
						end if;					
			when 2 =>if c < fg or (dau = '1' and c = fg ) then led  <= "1101"; 
						elsif dau = '0' or (dau = '1' and c > fg) then led <= "1111"; 
						end if;
			when 3 =>if c < fg or (dau = '1' and c = fg ) then led  <= "1011"; 
						elsif dau = '0' or (dau = '1' and c > fg) then led <= "1111"; 
						end if;
			when 4 =>if c < fg or (dau = '1' and c = fg ) then led  <= "0111"; 
						elsif dau = '0' or (dau = '1' and c > fg) then led <= "1111"; 
						end if;
		end case;
	
		
		if ((c = fg) and (dau = '1')) then segout <= "10111111"; end if;
		if ((c = 1) and (c < fg)) then segout <= decoder(tach(so,4,1));
	elsif ((c = 2) and (c < fg)) then segout <= decoder(tach(so,4,2)); 
	elsif ((c = 3) and (c < fg)) then segout <= decoder(tach(so,4,3)); 
	elsif ((c = 4) and (c < fg)) then segout <= decoder(tach(so,4,4));
		end if;
		if c = cham then segout(7) <= '0'; end if;

	end process;


end Behavioral;

