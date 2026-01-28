package body Counts with SPARK_Mode is

   function Char_Counts (Input : Buffer) return Counts_Array is
      Counts : Counts_Array := [others => 0];
   begin
      for I in Input'Range loop
         Counts (Input (I)) := Counts (Input (I)) + 1;
      end loop;
      return Counts;
   end Char_Counts;

end Counts;
