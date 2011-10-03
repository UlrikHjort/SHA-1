-------------------------------------------------------------------------------
--                                                                           --
--                                  Sha1                                     --
--                                                                           --
--                                Sha1.ads                                   --
--                                                                           --
--                                  SPEC                                     --
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

-------------------------------------------------------------------------------
-- Sha1 is implemented according to the specification given in :FIPS PUB 180-1
-- http://www.itl.nist.gov/fipspubs/fip180-1.htm
-------------------------------------------------------------------------------
with Interfaces;

package Sha1 is

   type Unsigned_32 is mod (2 ** 32); -- According to the spec

   type Unsigned_32_Array_T is array(Positive range <>) of Unsigned_32;
   type Unsigned_8_Array_T is array(Positive range <>) of Interfaces.Unsigned_8;

   type Context_T is
      record
         Message_Digest      : Unsigned_32_Array_T(1..5);
         Length_Low          : Unsigned_32;
         Length_High         : Unsigned_32;
         Message_Block       : Unsigned_8_Array_T(1..64);
         Message_Block_Index : Positive;
         Computed            : Boolean;
         Corrupted           : Boolean;
      end record;



   ---------------------------------------------
   --
   -- Reset and initialize buffers and indexes
   --
   ---------------------------------------------
   procedure Init (Context : in out Context_T);


   --------------------------------------------------------
   --
   -- Calculate and returns the 160 bit message digest in
   -- Context.Message_Digest.
   --
   -- Returns True in Result_Ok on success otherwise False
   --
   --------------------------------------------------------
   procedure Result(Context : in out Context_T; Result_Ok : out Boolean);


   -----------------------------------------------
   --
   -- Takes a message as an unsigned_8 array and
   -- update the SHA-1 context
   --
   -----------------------------------------------
   procedure Input(Context : in out Context_T;
                   Message : in     Unsigned_8_Array_T);


End Sha1;

