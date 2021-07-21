int: PROBLEM_STAGE;
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
int: m = card(EDGE);
solve satisfy;    % dummy solve
output ["\(n)\n\(k)\n\(maxsize)\n\(m)\n"] ++
       [ show(E[i,j]) ++ " " | i in EDGE, j in 1..2 ] ++ ["\n"] ++
       [ "\(card(FAMILY))\n" ] ++
       [ show(ML[i,j]) ++ " " | i in FAMILY, j in 1..2 ] ++ ["\n"] ++
       [ "\(card(DISLIKE))\n" ] ++
       [ show(CL[i,j]) ++ " " | i in DISLIKE, j in 1..2 ];    
