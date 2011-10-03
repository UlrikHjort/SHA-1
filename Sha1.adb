-------------------------------------------------------------------------------
--                                                                           --
--                                  Sha1                                     --
--                                                                           --
--                                Sha1.adb                                   --
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

package body Sha1 is

   ------------------------------------------
   --
   -- Circular rotation
   --
   ------------------------------------------
   function Circular_Shift(Bits : Positive; Value : Unsigned_32) Return Unsigned_32 is
   begin
      return (Unsigned_32(Interfaces.Shift_Left(Interfaces.Unsigned_32(Value),Bits)) and 16#FFFFFFFF#) or
              Unsigned_32(Interfaces.Shift_Right(Interfaces.Unsigned_32(Value),(32-Bits)));
   end Circular_Shift;


   -------------------------------------------------
   --
   -- Process a 512 bit part of the message stored
   -- in Context.Message_Block
   --
   -------------------------------------------------
   procedure Process_Message_Block(Context : in out Context_T) is

      K : constant Unsigned_32_Array_T (1 .. 4) := (16#5A827999#,
                                                    16#6ED9EBA1#,
                                                    16#8F1BBCDC#,
                                                    16#CA62C1D6#);

      A,B,C,D,E, Tmp : Unsigned_32                := 0;
      W              : Unsigned_32_Array_T(1..80) := (others=> 0);


   begin
      for T in 0 .. 15 loop
         W(T+1) := Unsigned_32(Interfaces.Shift_Left(Interfaces.Unsigned_32(Context.Message_Block(T*4+1)), 24)) or
                   Unsigned_32(Interfaces.Shift_Left(Interfaces.Unsigned_32(Context.Message_Block(T*4+2)), 16)) or
                   Unsigned_32(Interfaces.Shift_Left(Interfaces.Unsigned_32(Context.Message_Block(T*4+3)), 8)) or
                   Unsigned_32(Context.Message_Block(T*4+4));
      end loop;

      for T in 17 .. 80 loop
         W(T) := Circular_Shift(1, W(T-3) xor W(T-8) xor W(T-14) xor W(T-16));
      end loop;

      A := Context.Message_Digest(1);
      B := Context.Message_Digest(2);
      C := Context.Message_Digest(3);
      D := Context.Message_Digest(4);
      E := Context.Message_Digest(5);

      for T in 1 .. 20 loop
         Tmp := Circular_Shift(5,A) + ((B and C) or ((not B) and D)) + E + W(T) + K(1);
         Tmp := Tmp and 16#FFFFFFFF#;
         E := D;
         D := C;
         C := Circular_Shift(30,B);
         B := A;
         A := Tmp;
      end loop;

      for T in 21 .. 40 loop
         Tmp := Circular_Shift(5,A) + (B xor C xor D) + E + W(T) +K(2);
         Tmp := Tmp and 16#FFFFFFFF#;
         E := D;
         D := C;
         C := Circular_Shift(30,B);
         B := A;
         A := Tmp;
      end loop;

      for T in 41 .. 60 loop
         Tmp := Circular_Shift(5,A) + ((B and C) or (B and D) or (C and D)) + E + W(T) + K(3);
         Tmp := Tmp and 16#FFFFFFFF#;
         E := D;
         D := C;
         C := Circular_Shift(30,B);
         B := A;
         A := Tmp;
      end loop;

      for T in 61 .. 80 loop
         Tmp := Circular_Shift(5,A) + (B xor C xor D) + E + W(T) + K(4);
         Tmp := Tmp and 16#FFFFFFFF#;
         E := D;
         D := C;
         C := Circular_Shift(30,B);
         B := A;
         A := Tmp;
      end loop;

      Context.Message_Digest(1) := (Context.Message_Digest(1) + A) and 16#FFFFFFFF#;
      Context.Message_Digest(2) := (Context.Message_Digest(2) + B) and 16#FFFFFFFF#;
      Context.Message_Digest(3) := (Context.Message_Digest(3) + C) and 16#FFFFFFFF#;
      Context.Message_Digest(4) := (Context.Message_Digest(4) + D) and 16#FFFFFFFF#;
      Context.Message_Digest(5) := (Context.Message_Digest(5) + E) and 16#FFFFFFFF#;

      Context.Message_Block_Index := 1;
   end Process_Message_Block;


   -----------------------------------------------
   --
   -- Padding the message to a multiple of 512
   --
   -----------------------------------------------
   procedure Pad_Message(Context : in out Context_T) is
      use Interfaces;
   begin

      if Context.Message_Block_Index > 56 then
         Context.Message_Block(Context.Message_Block_Index) := 16#80#;
         Context.Message_Block_Index := Context.Message_Block_Index +1;

         loop
            exit when Context.Message_Block_Index > 64;
            Context.Message_Block(Context.Message_Block_Index) := 16#00#;
            Context.Message_Block_Index := Context.Message_Block_Index +1;
         end loop;

         Process_Message_Block(Context);

         loop
            exit when Context.Message_Block_Index >  56;
            Context.Message_Block(Context.Message_Block_Index) := 16#00#;
            Context.Message_Block_Index := Context.Message_Block_Index +1;
         end loop;
      else
         Context.Message_Block(Context.Message_Block_Index) := 16#80#;
         Context.Message_Block_Index := Context.Message_Block_Index +1;

         loop
            exit when Context.Message_Block_Index >  56;
            Context.Message_Block(Context.Message_Block_Index) := 16#00#;
            Context.Message_Block_Index := Context.Message_Block_Index +1;
         end loop;
      end if;

      Context.Message_Block(57) := Unsigned_8(Shift_Right(Interfaces.Unsigned_32(Context.Length_High),24)) and 16#FF#;
      Context.Message_Block(58) := Unsigned_8(Shift_Right(Interfaces.Unsigned_32(Context.Length_High),16)) and 16#FF#;
      Context.Message_Block(59) := Unsigned_8(Shift_Right(Interfaces.Unsigned_32(Context.Length_High),8))  and 16#FF#;
      Context.Message_Block(60) := Unsigned_8(Context.Length_High and 16#FF#);


      Context.Message_Block(61) := Unsigned_8(Shift_Right(Interfaces.Unsigned_32(Context.Length_Low),24)) and 16#FF#;
      Context.Message_Block(62) := Unsigned_8(Shift_Right(Interfaces.Unsigned_32(Context.Length_Low),16)) and 16#FF#;
      Context.Message_Block(63) := Unsigned_8(Shift_Right(Interfaces.Unsigned_32(Context.Length_Low),8))  and 16#FF#;
      Context.Message_Block(64) := Unsigned_8(Context.Length_Low and 16#FF#);

      Process_Message_Block(Context);
   end Pad_Message;


   ---------------------------------------------
   --
   -- Reset and initialize buffers and indexes
   --
   ---------------------------------------------
   procedure Init (Context : in out Context_T) is

   begin
      Context.Length_Low          := 0;
      Context.Length_High         := 0;
      Context.Message_Block_Index := 1;

      Context.Message_Digest(1) := 16#67452301#;
      Context.Message_Digest(2) := 16#EFCDAB89#;
      Context.Message_Digest(3) := 16#98BADCFE#;
      Context.Message_Digest(4) := 16#10325476#;
      Context.Message_Digest(5) := 16#C3D2E1F0#;

      Context.Computed  := False;
      Context.Corrupted := False;
   end Init;



   --------------------------------------------------------
   --
   -- Calculate and returns the 160 bit message digest in
   -- Context.Message_Digest.
   --
   -- Returns True in Result_Ok on success otherwise False
   --
   --------------------------------------------------------
   procedure Result(Context : in out Context_T; Result_Ok : out Boolean) is

   begin
      Result_Ok := True;

      if Context.Corrupted then
         Result_Ok := False;
      end if;

      if not Context.computed then
         Pad_Message(Context);
         Context.Computed := True;
      end if;
   end Result;



   -----------------------------------------------
   --
   -- Takes a message as an unsigned_8 array and
   -- update the SHA-1 context
   --
   -----------------------------------------------
   procedure Input(Context : in out Context_T;
                   Message : in     Unsigned_8_Array_T) is

      use Interfaces;
      Message_Index : Positive := 1;
      Length : Unsigned_32 := Message'Length;

   begin
      if Length > 0 then
         if (not(Context.Computed and Context.Corrupted)) then
            loop
               exit when (Length = 0) or Context.Corrupted;
               Length := Length -1;

               Context.Message_Block(Context.Message_Block_Index) := Message(Message_Index) and 16#FF#;
               Context.Message_Block_Index := Context.Message_Block_Index +1;

               Context.Length_Low := Context.Length_Low +8;
               -- Force 32 bits
               Context.Length_Low := Context.Length_Low and 16#FFFFFFFF#;

               if Context.Length_Low = 0 then
                  Context.Length_High := Context.Length_High +1;
                  -- Force 32 bits
                  Context.Length_High := Context.Length_High and 16#FFFFFFFF#;
                  if Context.Length_High = 0 then
                     Context.Corrupted := True;
                  end if;
               end if;

               if Context.Message_Block_Index = 65 then
                  Process_Message_Block(Context);
               end if;

              Message_Index := Message_Index +1;
            end loop;
         else
            Context.Corrupted := True;
         end if;
      end if;
   End Input;
End Sha1;


