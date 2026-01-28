package body Counts
  with SPARK_Mode
is

   procedure Lem_Sum_Zero (Arr : Counts_Array; Up_To : Character)
   with
     Ghost,
     Global             => null,
     Subprogram_Variant => (Decreases => Up_To),
     Pre                =>
       (for all C in Character'First .. Up_To => Arr (C) = 0),
     Post               => Sum (Arr, Up_To) = 0;

   function Is_Incr (Arr1, Arr2 : Counts_Array; Pos : Character) return Boolean
   is (for all C in Character =>
         (if C = Pos then Arr1 (C) + 1 = Arr2 (C) else Arr1 (C) = Arr2 (C)));

   procedure Lem_Incr_Eq (Arr1, Arr2 : Counts_Array; Up_To, Pos : Character)
   with
     Ghost,
     Global             => null,
     Subprogram_Variant => (Decreases => Up_To),
     Pre                =>
       Pos > Up_To
       and then Arr1 (Pos) < Length'Last
       and then Is_Incr (Arr1, Arr2, Pos),
     Post               => Sum (Arr2, Up_To) = Sum (Arr1, Up_To);

   procedure Lem_Incr_Neq (Arr1, Arr2 : Counts_Array; Up_To, Pos : Character)
   with
     Ghost,
     Global             => null,
     Subprogram_Variant => (Decreases => Up_To),
     Pre                =>
       Pos <= Up_To
       and then Arr1 (Pos) < Length'Last
       and then Is_Incr (Arr1, Arr2, Pos),
     Post               => Sum (Arr2, Up_To) = Sum (Arr1, Up_To) + 1;

   ------------------
   -- Lem_Sum_Zero --
   ------------------

   procedure Lem_Sum_Zero (Arr : Counts_Array; Up_To : Character) is
   begin
      if Up_To = Character'First then
         return;
      else
         Lem_Sum_Zero (Arr, Character'Pred (Up_To));
      end if;
   end Lem_Sum_Zero;

   -----------------
   -- Lem_Incr_Eq --
   -----------------

   procedure Lem_Incr_Eq (Arr1, Arr2 : Counts_Array; Up_To, Pos : Character) is
   begin
      if Up_To = Character'First then
         return;
      else
         Lem_Incr_Eq (Arr1, Arr2, Character'Pred (Up_To), Pos);
      end if;
   end Lem_Incr_Eq;

   ------------------
   -- Lem_Incr_Neq --
   ------------------

   procedure Lem_Incr_Neq (Arr1, Arr2 : Counts_Array; Up_To, Pos : Character)
   is
   begin
      if Up_To = Pos then
         if Up_To = Character'First then
            return;
         else
            Lem_Incr_Eq (Arr1, Arr2, Character'Pred (Up_To), Pos);
         end if;
      else
         Lem_Incr_Neq (Arr1, Arr2, Character'Pred (Up_To), Pos);
      end if;
   end Lem_Incr_Neq;

   -----------------
   -- Char_Counts --
   -----------------

   function Char_Counts (Input : Buffer) return Counts_Array is
      Counts : Counts_Array := [others => 0];
      Tmp    : Counts_Array := Counts
      with Ghost;
   begin
      Lem_Sum_Zero (Counts, Character'Last);
      for I in Input'Range loop
         pragma
           Loop_Invariant
             (for all C in Character => Counts (C) <= I - Input'First);
         pragma Loop_Invariant (Sum (Counts) = I - Input'First);
         Tmp := Counts;
         Counts (Input (I)) := Counts (Input (I)) + 1;
         Lem_Incr_Neq (Tmp, Counts, Character'Last, Input (I));
      end loop;
      return Counts;
   end Char_Counts;

end Counts;
