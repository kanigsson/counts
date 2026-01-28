package Counts
  with SPARK_Mode
is

   Max_Size : constant := 1024;

   type Int32 is range 0 .. 2**31 - 1;
   subtype Length is Int32 range 0 .. Max_Size;

   subtype Index is Length range 1 .. Max_Size;

   type Buffer is array (Index range <>) of Character;

   type Counts_Array is array (Character) of Length;

   function Char_Counts (Input : Buffer) return Counts_Array;

end Counts;