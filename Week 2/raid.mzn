% assignment 2
% select a set of raiding warrior
enum WARRIOR;
WARRIOR: dummy; 
enum CLAN; % the clan they belong too

int: l; % minimum raid party size
int: u; % maximum raid party size
int: m; % limit of hatreds
int: n = u;
array[WARRIOR] of int: strength;
array[WARRIOR] of CLAN: clan;

array[CLAN,CLAN] of 0..1: hates;
array[1..u] of int: index = [1| i in 1..u]; 
array[1..u] of var WARRIOR: raid;
constraint sum(i,j in raid where j!=i)(hates[clan[i],clan[j]]) <= 2*m;
constraint forall(i in 1..u-1)(raid[i]<=raid[i+1] - (raid[i]!=dummy));
constraint sum(i in 1..u where raid[i]!=dummy)(index[i])+forall(i in 1..u)(raid[i]==dummy)>=l;
var opt int: obj = sum(i in raid)(strength[i]);
solve maximize obj;
output ["raid = {"] ++ [if fix(raid[i]) != dummy then show(raid[i])
++ if i < n /\ fix(raid[i+1]) != dummy then ", " else "" endif
else "" endif | i in 1..n ] ++ ["};\n"]++["obj = \(obj)"];
