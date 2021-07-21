% scheduling suitors
enum SUITOR;
SUITOR: LiuBei; % which suitor is LiuBei
int: n; % number of meetings
set of int: MEETING = 1..n;
array[MEETING] of SUITOR: suitor;

enum ROOM = { Red, Gold, Blue };
array[SUITOR,ROOM] of int: mintime;
array[SUITOR,ROOM] of int: maxtime;
constraint forall(s in SUITOR, r in ROOM)
                 (assert(mintime[s,r] >= 1 /\ maxtime[s,r] >= mintime[s,r], 
                  "error in mintime/maxtime at [\(s),\(r)]\n"));

array[ROOM,ROOM] of int: move;
constraint forall(r in ROOM)(assert(move[r,r] = 0,"move[\(r),\(r)] != 0\n"));

int: ndays; % number of days
set of int: DAY = 1..ndays;
int: earliest; % time for earliest meeting start
int: latest;  % time for end of latest meeting

int: lessontime; % time for kung fu lesson;
int: minsep;     % minimum time between consecutive kung fu lessons

array[ROOM] of int: usedstart;  % time others use each room each day
array[ROOM] of int: useddur;    % durations of others use

enum STAGE = {A,B,C};
STAGE: stage;

set of int: TIME = 0..24*ndays;

array[MEETING] of var TIME: start;
array[MEETING] of var TIME: dur;    % duration in false schedule
array[MEETING] of var ROOM: room;
set of int: KUNGFU = 1..n;
array[KUNGFU] of var int: kungfu;  % start time for each lesson
   % unused lessons have start times after 24*ndays
   

%Meeting Move Constriant 会面间隔与移动
constraint forall(m,n in MEETING where start[m] < start[n] )(stage != A -> start[m] + dur[m] + move[room[m],room[n]] <= start[n]);  

%Min Max Time Constraint 每场见面都不能超过一定时间
array[MEETING] of var 0..1: kungfu_arranged;
constraint forall(m in MEETING)(if stage!= C then dur[m]>= mintime[suitor[m],room[m]] /\ dur[m] <= maxtime[suitor[m],room[m]] else dur[m] - lessontime*kungfu_arranged[m] >= mintime[suitor[m],room[m]] /\ dur[m] - lessontime*kungfu_arranged[m] <= maxtime[suitor[m],room[m]] endif);
constraint forall(k in KUNGFU where kungfu[k] <= ndays*24)(
    if stage != C then true else
    forall(m in MEETING)( kungfu[k] + lessontime == start[m] + dur[m]  ->  kungfu_arranged[m] = 1)
    endif
);
constraint forall(k in KUNGFU where kungfu[k] <= ndays*24)(if stage != C then true else exists(m in MEETING)(kungfu[k] + lessontime == start[m] + dur[m]) endif);

%Sun Shangxiang Constraint 孙尚香自己作为资源的约束
include "disjunctive.mzn";
constraint disjunctive(start,dur);

%Time Constraint Everyday 每天的时间限制
array[MEETING] of var int: start_mod;
array[MEETING] of var int: start_dur_mod;
constraint forall(m in MEETING)(start_mod[m] == start[m] mod 24);
constraint forall(m in MEETING)(start_dur_mod[m] == (start[m] + dur[m]) mod 24);
constraint forall(m in MEETING)((start_mod[m] >= earliest) /\ (start_dur_mod[m] <= latest) /\ (start_dur_mod[m] >= earliest));

%Sep between Kungfus 功夫课间隔
constraint forall(k in KUNGFU)(kungfu[k] >= 0);
constraint forall(k in 1..n-1)(stage == C -> kungfu[k] + lessontime + minsep <= kungfu[k+1]);
constraint forall(k in KUNGFU)(stage != C -> kungfu[k] > 24*ndays);



%Room Resource Constraint 房间资源约束
constraint forall(m in MEETING)(disjunctive([start_mod[m],usedstart[room[m]]],[dur[m],useddur[room[m]]]));


%Objective 目标函数部分
var int: kungfu_num = sum(k in KUNGFU)(kungfu[k] < ndays*24);
var int: kungfu_liubei = sum(m in MEETING where suitor[m] == LiuBei)(kungfu_arranged[m]*lessontime);
var int: objC = sum(m in MEETING where suitor[m] == LiuBei)(dur[m]) + 100*kungfu_num - kungfu_liubei;
var int: objAB = sum(m in MEETING where suitor[m] == LiuBei)(dur[m]);
var int: obj;
constraint if stage == C then obj = objC else obj = objAB endif;
solve maximize obj;
output ["start = \(start);\ndur = \(dur);\nroom = \(room);\nkungfu = \(kungfu);\nobj = \(obj);"];

