package body Counts with SPARK_Mode is

   procedure Lem_Sum_Zero (Arr : Counts_Array; Up_To : Character)
   with
     Ghost,
     Global             => null,
     Subprogram_Variant => (Decreases => Up_To),
     Pre                =>
       (for all C in Character'First .. Up_To => Arr (C) = 0),
     Post               => Sum (Arr, Up_To) = 0;

   function Incr (Arr : Counts_Array; Pos : Character) return Counts_Array
   is (Arr with delta Pos => Arr (Pos) + 1)
   with
     Ghost,
     Pre  => Arr (Pos) < Length'Last,
     Post =>
       (for all C in Character =>
          (if C = Pos
           then Incr'Result (C) = Arr (C) + 1
           else Incr'Result (C) = Arr (C)));

   procedure Lem_Incr_Eq (Arr : Counts_Array; Up_To, Pos : Character)
   with
     Ghost,
     Global             => null,
     Subprogram_Variant => (Decreases => Up_To),
     Pre                => Pos > Up_To and then Arr (Pos) < Length'Last,
     Post               => Sum (Incr (Arr, Pos), Up_To) = Sum (Arr, Up_To);

   procedure Lem_Incr_Neq (Arr : Counts_Array; Up_To, Pos : Character)
   with
     Ghost,
     Global             => null,
     Subprogram_Variant => (Decreases => Up_To),
     Pre                => Pos <= Up_To and then Arr (Pos) < Length'Last,
     Post               => Sum (Incr (Arr, Pos), Up_To) = Sum (Arr, Up_To) + 1;

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

   procedure Lem_Incr_Eq (Arr : Counts_Array; Up_To, Pos : Character) is
   begin
      if Up_To = Character'First then
         return;
      else
         Lem_Incr_Eq (Arr, Character'Pred (Up_To), Pos);
      end if;
   end Lem_Incr_Eq;


   ------------------
   -- Lem_Incr_Neq --
   ------------------

   procedure Lem_Incr_Neq (Arr : Counts_Array; Up_To, Pos : Character) is
      Tmp : Counts_Array := Incr (Arr, Pos);
   begin
      if Up_To = Pos then
         if Up_To = Character'First then
            return;
         else
            Lem_Incr_Eq (Arr, Character'Pred (Up_To), Pos);
         end if;
      else
         Lem_Incr_Neq (Arr, Character'Pred (Up_To), Pos);
      end if;
   end Lem_Incr_Neq;

   -----------------
   -- Char_Counts --
   -----------------

   function Char_Counts (Input : Buffer) return Counts_Array is
      Counts : Counts_Array := [others => 0];
   begin
      Lem_Sum_Zero (Counts, Character'Last);
      for I in Input'Range loop
         pragma
           Loop_Invariant
             (for all C in Character => Counts (C) <= I - Input'First);
         pragma Loop_Invariant (Sum (Counts) = I - Input'First);
         Lem_Incr_Neq (Counts, Character'Last, Input (I));
         Counts (Input (I)) := Counts (Input (I)) + 1;
      end loop;
      return Counts;
   end Char_Counts;

end Counts;
