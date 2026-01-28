package body Counts with SPARK_Mode is

   procedure Lem_Sum_Zero (Arr : Counts_Array; Up_To : Character)
   with
     Ghost,
     Global             => null,
     Subprogram_Variant => (Decreases => Up_To),
     Pre                =>
       (for all C in Character'First .. Up_To => Arr (C) = 0),
     Post               => Sum (Arr, Up_To) = 0;

   procedure Lem_Sum_Zero (Arr : Counts_Array; Up_To : Character) is
   begin
      if Up_To = Character'First then
         return;
      else
         Lem_Sum_Zero (Arr, Character'Pred (Up_To));
      end if;

   end Lem_Sum_Zero;

   function Char_Counts (Input : Buffer) return Counts_Array is
      Counts : Counts_Array := [others => 0];
   begin
      Lem_Sum_Zero (Counts, Character'Last);
      for I in Input'Range loop
         pragma
           Loop_Invariant
             (for all C in Character => Counts (C) <= I - Input'First);
         pragma Loop_Invariant (Sum (Counts) = I - Input'First);
         Counts (Input (I)) := Counts (Input (I)) + 1;
      end loop;
      return Counts;
   end Char_Counts;

end Counts;
