% Liu Bei forsees that Yuan Shiu will be defeated by Cao Cao
% He needs to find a route to safety in Jin province before the defeat
% But Cao Cao's soldiers are everywhere

int: nrow;
set of int: ROW = 1..nrow;
int: ncol;
set of int: COL = 1..ncol;

% Plains, Mountain, Forest, City, River
enum TERRAIN = { P, M, F, C, R };
array[TERRAIN] of int: delay;
int: timelimit;

array[ROW,COL] of TERRAIN: terrain;
array[ROW,COL] of int: soldier;
array[ROW,COL] of bool: Jin;

int: start_row;
int: start_col;

int: maxstep;
set of int: STEP = 1..maxstep;
set of int: STEP0 = 0..maxstep;

var STEP: steps;
array[ROW,COL] of var STEP0: visit; % which step do we visit position or 0 if not visited
array[STEP] of var ROW: site_row;
array[STEP] of var COL: site_col;


% start at start position
constraint visit[start_row,start_col] = 1;

% double-perspectives of modeling
constraint forall(i in ROW,j in COL, k in 1..steps)((site_row[k] ==i)/\(site_col[k] == j) <-> (visit[i,j] == k));

% only use steps moves
constraint sum(r in ROW, c in COL)(visit[r,c] >= 1) <= steps;
% reach Jin province
constraint Jin[site_row[steps],site_col[steps]];


% visit at most one city
include "global_cardinality_low_up.mzn";
constraint global_cardinality_low_up([terrain[site_row[k],site_col[k]] | k in STEP],[C],[0],[1]);

% cant enter Mountain
constraint forall(k in 1..steps)(terrain[site_row[k],site_col[k]] != M);

% visit only one place in every step
include "alldifferent_except_0.mzn";
constraint alldifferent_except_0(array1d(visit));

% every step
constraint forall(k in 1..steps-1)(abs(site_row[k]-site_row[k+1])+abs(site_col[k]-site_col[k+1]) == 1);

% not too much delay
constraint time <= timelimit;
var int: time = sum(r in ROW, c in COL)(delay[terrain[r,c]]*(visit[r,c] >= 1));

% minimize the number of soldiers traversed
solve minimize obj;
var int: obj = sum(r in ROW, c in COL)((visit[r,c] > 0)*soldier[r,c]);
                         

array[TERRAIN] of string: ter = [".", "#", "^", "C", "~"];
output["%"] ++ ["\(site_row)\n"];
output["%"] ++ ["\(site_col)\n"];
output 
       ["%"] ++
       [ " " ++ ter[fix(terrain[r,c])] ++ if c = ncol then "\n%" else "" endif
       | r in ROW, c in COL ]
       ++ ["\n%"] ++
       [ if soldier[r,c] > 0 then show_int(2,soldier[r,c]) else " ." endif
         ++ if c = ncol then "\n%" else "" endif
       | r in ROW, c in COL ]
       ++ ["\n"] ++
       ["%"] ++
       [ if fix(visit[r,c]) > 0 then show_int(2,visit[r,c]) else " ." endif
         ++ if c = ncol then "\n%" else "" endif
       | r in ROW, c in COL ]
       ++ ["\nvisit = array2d(ROW,COL,\(visit));\nsteps = \(steps);\ntime = \(time);\nobj = \(obj);"]
       ;


