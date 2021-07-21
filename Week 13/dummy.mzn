int: PROBLEM_STAGE; %Identifier to be used for each instance. Do not change.

int: n;
set of int: PERSON = 1..n;
int: k;
int: maxsize;
array[int,1..2] of int: ML;
array[int,1..2] of int: CL;
array[int,1..2] of PERSON: E; 
solve satisfy;    % dummy solve

output [

%%
%% Substitute the string bellow to output your solution depending on the file
%% used. You can leave the line "% Your solution for refugee_XX" for your guidance
%% Use ++ between strings to concatenate them.
%% Remember your output must be in MiniZinc format, since it will be read
%% by a MiniZinc model to grade it.
%%

  if PROBLEM_STAGE == 1 then
  "%Your solution for refugee_1\n" ++
  
  "x = [1, 1, 1, 2, 2, 2, 2, 2, 2, 1, 3];\n" ++
  "obj = 174;\n"
        
  elseif PROBLEM_STAGE == 2 then
  "%Your solution for refugee_2\n" ++
  
  "x = [1, 1, 1, 2, 2, 2, 2, 2, 2, 1, 3];\n" ++
  "obj = 174;\n"
        
  elseif PROBLEM_STAGE == 3 then
  "%Your solution for refugee_3\n" ++
  
  "x = [1, 1, 1, 2, 2, 2, 2, 2, 2, 1, 3];\n" ++
  "obj = 174;\n"
        
  elseif PROBLEM_STAGE == 4 then
  "%Your solution for refugee_4\n" ++
  
  "x = [1, 1, 1, 2, 2, 2, 2, 2, 2, 1, 3];\n" ++
  "obj = 174;\n"
        
  elseif PROBLEM_STAGE == 5 then
  "%Your solution for refugee_5\n" ++
  
  "x = [1, 1, 1, 2, 2, 2, 2, 2, 2, 1, 3];\n" ++
  "obj = 174;\n"
        
  elseif PROBLEM_STAGE == 6 then
  "%Your solution for refugee_6\n" ++
  
  "x = [1, 1, 1, 2, 2, 2, 2, 2, 2, 1, 3];\n" ++
  "obj = 174;\n"
        
  elseif PROBLEM_STAGE == 7 then
  "%Your solution for refugee_7\n" ++
  
  "x = [1, 1, 1, 2, 2, 2, 2, 2, 2, 1, 3];\n" ++
  "obj = 174;\n"
        
  elseif PROBLEM_STAGE == 8 then
  "%Your solution for refugee_8\n" ++
  
  "x = [1, 1, 1, 2, 2, 2, 2, 2, 2, 1, 3];\n" ++
  "obj = 174;\n"
        
  elseif PROBLEM_STAGE == 9 then
  "%Your solution for refugee_9\n" ++
  
  "x = [1, 1, 1, 2, 2, 2, 2, 2, 2, 1, 3];\n" ++
  "obj = 174;\n"
        
  elseif PROBLEM_STAGE == 10 then
  "%Your solution for refugee_10\n" ++
  
  "x = [1, 1, 1, 2, 2, 2, 2, 2, 2, 1, 3];\n" ++
  "obj = 174;\n"
        
  elseif PROBLEM_STAGE == 11 then
  "%Your solution for refugee_11\n" ++
  
  "x = [1, 1, 1, 2, 2, 2, 2, 2, 2, 1, 3];\n" ++
  "obj = 174;\n"
        
  elseif PROBLEM_STAGE == 12 then
  "%Your solution for refugee_12\n" ++
  
  "x = [1, 1, 1, 2, 2, 2, 2, 2, 2, 1, 3];\n" ++
  "obj = 174;\n"
        
  
  else 
  "ERROR: Did you modify the PROBLEM_STAGE in any .dzn file?"
  endif
];