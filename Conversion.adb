-------------------------------------------------------------------------------
--                                                                           --
--                               Conversion                                  --
--                                                                           --
--                              Conversion.adb                               --
--                                                                           --
--                                  BODY                                     --
--                                                                           --
--                   Copyright (C) 1996 Ulrik Hørlyk Hjort                   --
--                                                                           --
--  Conversion is free software;  you can  redistribute it                   --
--  and/or modify it under terms of the  GNU General Public License          --
--  as published  by the Free Software  Foundation;  either version 2,       --
--  or (at your option) any later version.                                   --
--  Conversion is distributed in the hope that it will be                    --
--  useful, but WITHOUT ANY WARRANTY;  without even the  implied warranty    --
--  of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                  --
--  See the GNU General Public License for  more details.                    --
--  You should have  received  a copy of the GNU General                     --
--  Public License  distributed with Yolk.  If not, write  to  the  Free     --
--  Software Foundation,  51  Franklin  Street,  Fifth  Floor, Boston,       --
--  MA 02110 - 1301, USA.                                                    --
--                                                                           --
-------------------------------------------------------------------------------
with Ada.Text_IO; use Ada.Text_IO;

package body Conversion is

 ------------------------------------------
 --
 -- Print an Unsigned_32 value as Hex
 --
 ------------------------------------------
 procedure Put_Hex_Value(Val : Unsigned_32) is

    type Char_Array_T is array (Natural range <>) of Character;
    Hex_Array : constant Char_Array_T(0..15) :=
      ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');

       Length     : Positive       := 1;
       Val_Tmp    : Unsigned_32    := Val;
       Hex_String : String(1..50);

    begin
       loop
          exit When Val_Tmp  = 0;
          Hex_String(Length) :=
            Hex_Array(Natural(Val_tmp rem 16));
          Val_Tmp := Val_Tmp / 16;
          Length := Length +1;
       end loop;

       for I in reverse 1 .. Length-1 loop
          Put(Hex_String(I));
       end loop;
    end Put_Hex_Value;
 end Conversion;
