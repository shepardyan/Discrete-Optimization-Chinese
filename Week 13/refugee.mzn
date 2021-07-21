int: PROBLEM_STAGE; %Identifier to be used for each instance. If you write a MiniZinc model to solve the problem, this can be ignored.

int: n;
set of int: PERSON = 1..n;
int: k;
set of int: CAMPSITE = 1..k;
int: maxsize;
array[int,1..2] of int: ML;
array[int,1..2] of int: CL;
set of int: FAMILY = index_set_1of2(ML);
set of int: DISLIKE = index_set_1of2(CL);
array[int,1..2] of PERSON: E; 
set of int: EDGE = index_set_1of2(E);

