int: T; % maximum time allowed;
set of int: TIME = 1..T;

int: E; % weight of elephant in STONES;
set of int: STONE = 0..E;

int: G; % number of guards
set of int: GUARD = 1..G;
array[GUARD] of STONE: easy;   
array[GUARD] of STONE: hard;
array[GUARD] of TIME: tired;

GUARD: p; % maximum people on pier;
GUARD: b; % maximum people on boat;

set of int: ACT = -1..E; % -1 = goto bank, 0 = wait, > 0 carry stones  
int: wait = 0;
int: to_bank = -1;
array[GUARD,TIME] of var ACT: act;        % action at time t
var TIME: end;                            % end time;
set of int: TIME0 = 0..T;
enum POS = {Bank,Boat};
array[GUARD,TIME0] of var POS: gsite;

%守卫位置
constraint forall(i in GUARD)(gsite[i,0] = Bank);
constraint forall(i in GUARD,j in TIME)(gsite[i,j] = gsite[i,j-1] + (act[i,j] > 0) - (act[i,j] == -1));
constraint forall(i in GUARD,j in TIME)(gsite[i,j-1] = Bank -> act[i,j]>=0);
constraint forall(i in GUARD,j in TIME)(gsite[i,j-1] = Boat -> act[i,j]<=0);


%搬运石头的上限
constraint forall(i in GUARD,j in TIME)(act[i,j] <= hard[i]);

%搬运过多石头需要休息
%predicate rest(var GUARD: who, var 1..T-1: time_now, var ACT: act_now) = let {var 1..T: time_end = min(time_now+tired[who],T), var 1..T: time_start = time_now+1;} in forall(a in time_start..time_end)(act[who,a]<=0);
constraint forall(i in GUARD,j in 1..T-1)(if (act[i,j] > easy[i]) then  sum(k in j+1..min(j+tired[i],T))(act[i,k])<=0 else true endif);
%constraint forall(i in GUARD,j in 1..T-1)((act[i,j] > easy[i]) -> rest(i,j,act[i,j]));

%同时移动守卫数量有限制
constraint forall(j in TIME)(sum(i in GUARD)(act[i,j] == 0) >= G-p);

%守卫向同一个方向移动
%constraint forall(j in TIME)(sum(i in GUARD)(abs(act[i,j])) == abs(sum(i in GUARD)(act[i,j])));
constraint forall(j in TIME, g1,g2 in GUARD where g1<g2)(act[g1,j]*act[g2,j]>=0);


%END后不再移动
constraint forall(i in GUARD, j in TIME)( j > end -> act[i,j] == wait);

%总搬运量
constraint sum(i in GUARD,j in TIME)(act[i,j]*(act[i,j]>=0)) == E;

%船上的守卫有限制
constraint forall(j in TIME)(sum(i in GUARD)(gsite[i,j] == Boat) <= b);

%最小化end
solve minimize end;

%样例输出
output ["act = array2d(GUARD,TIME,[\n"]++ [show_int(2,act[g,t])++ if(g==G /\ t = T) then "" else "," endif ++ if (t = T )then if (g == G) then "" else "\n" endif else " " endif | g in GUARD,t in TIME] ++ ["]);\nend = \(end);"];