-------------------------------------------------------------------------------
--                                                                           --
--                                  Sha1                                     --
--                                                                           --
--                             Sha1_Test.adb                                 --
--                                                                           --
--                                  BODY                                     --
--                                                                           --
--                   Copyright (C) 1997 Ulrik Hørlyk Hjort                   --
--                                                                           --
--  Sha1 is free software;  you can  redistribute it                         --
--  and/or modify it under terms of the  GNU General Public License          --
--  as published  by the Free Software  Foundation;  either version 2,       --
--  or (at your option) any later version.                                   --
--  Sha1 is distributed in the hope that it will be                          --
--  useful, but WITHOUT ANY WARRANTY;  without even the  implied warranty    --
--  of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                  --
--  See the GNU General Public License for  more details.                    --
--  You should have  received  a copy of the GNU General                     --
--  Public License  distributed with Yolk.  If not, write  to  the  Free     --
--  Software Foundation,  51  Franklin  Street,  Fifth  Floor, Boston,       --
--  MA 02110 - 1301, USA.                                                    --
--                                                                           --
-------------------------------------------------------------------------------
with Sha1; use Sha1;
with Conversion; use Conversion;
with Ada.Text_IO; use Ada.Text_IO;

procedure Sha1_Test is
procedure Test(Message_str : String; Expected : String) is

   Message : Unsigned_8_Array_T (Message_Str'First .. Message_Str'Last);

   Context   : Context_T;
   Result_Ok : Boolean     := False;

begin
   Put_Line("Message test : " & Message_Str);
   Put_Line("Expected Output:  " & Expected);

   -- Copy Message String to byte buffer:
   for I in Message_Str'First .. Message_Str'Last loop
      Message(I) := Character'Pos (Message_Str(I));
   end loop;

   Init(Context);

      Input(Context, Message);

   Result(Context, Result_Ok);

   if not Result_Ok then
      Put_Line("Calculation Error (Somewhere!)");
   else
   Put("Generated output: ");
   for I in Context.Message_Digest'First .. Context.Message_Digest'Last loop

      Put_Hex_Value(Context.Message_Digest(I));
   end loop;
   New_Line;
   New_Line;
   end if;
end Test;


begin
   Test("This the first test" , "1B86AD53560C95BF6A843CE334AC2D9D30486250");
   Test("a", "86F7E437FAA5A7FCE15D1DDCB9EAEAEA377667B8");
   Test("Arthur Looked Up. 'Ford!' He Said, 'there's an infinite number of monkeys outside who want to talk to us about this script for Hamlet they've worked out.",
        "BA1F6C3BDD830D4C1FCA6DEEFE3116848C608470");
end Sha1_Test;
