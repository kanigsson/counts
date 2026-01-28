package Counts
  with SPARK_Mode
is

   Max_Size : constant := 1024;

   type Int32 is range 0 .. 2**31 - 1;
   subtype Length is Int32 range 0 .. Max_Size;

   subtype Index is Length range 1 .. Max_Size;

   type Buffer is array (Index range <>) of Character;

   type Counts_Array is array (Character) of Length;

   function Sum (Arr : Counts_Array; Up_To : Character) return Int32
   is (if Up_To = Character'First
       then Arr (Up_To)
       else Arr (Up_To) + Sum (Arr, Character'Pred (Up_To)))
   with
     Subprogram_Variant => (Decreases => Up_To),
     Ghost,
     Post               =>
       Sum'Result <= Length'Last * (Character'Pos (Up_To) + 1);

   function Sum (Arr : Counts_Array) return Int32
   is (Sum (Arr, Character'Last))
   with Ghost;

   function Char_Counts (Input : Buffer) return Counts_Array
   with Post => Sum (Char_Counts'Result) = Input'Length;

end Counts;