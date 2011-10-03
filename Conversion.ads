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
with Sha1; use Sha1;

package Conversion is

    ------------------------------------------
    --
    -- Print an Unsigned_32 value as Hex
    --
    ------------------------------------------
   procedure Put_Hex_Value(Val : Unsigned_32);
end Conversion;
