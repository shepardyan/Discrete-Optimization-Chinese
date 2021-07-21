int: n; % number of court members
set of int: COURT = 1..n;
int: emperor = 1;
array[COURT] of int: rank;
array[COURT] of int: ability;

int: m; % number of horses
set of int: HORSE = 1..m;
array[HORSE] of int: beauty;
array[HORSE] of int: speed;
array[COURT,HORSE] of int: enjoy;

array[COURT] of var 0..m: horse;
array[HORSE] of var 0..n: rider;
include "alldifferent.mzn";
include "global_cardinality_low_up.mzn";
constraint forall(j in HORSE)(global_cardinality_low_up([horse[i] | i in COURT],[j],[0],[1]));
constraint forall(i in COURT where horse[i]!=0)(enjoy[i,horse[i]]>=0);
constraint forall(i in COURT, j in HORSE)(horse[i] = j <-> rider[j] = i);


constraint max([enjoy[i,horse[i]] | i in 2..n where horse[i]!=0]) < enjoy[emperor,horse[emperor]];
constraint global_cardinality_low_up([horse[i]|i in COURT],[0],[0],[max(0,n-m)]);
constraint forall(i,j in COURT where i!=j)(rank[i]>rank[j]->(beauty[horse[i]]>=beauty[horse[j]])\/(horse[j]==0));
var int:ability_satisfy = sum(i,j in HORSE where (i!=j)/\(speed[i]>speed[j]))(1-((rider[i]==0)\/(ability[rider[i]]>=ability[rider[j]])));

var int: obj = sum(i in COURT where horse[i]!=0)(enjoy[i,horse[i]])-100*ability_satisfy;


solve maximize obj;
output(["horse = \(horse);\nobj = \(obj);"]);
