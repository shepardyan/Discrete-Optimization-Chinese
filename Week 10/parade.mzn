int: n;  % number of soldiers
set of int: SOLDIER = 1..n;
set of int: POS = 1..n;
array[SOLDIER] of int: height;
int: cols;    % number of columns of soldiers 
int: delta;   % height delta allowed

array[POS] of var SOLDIER: soldier;