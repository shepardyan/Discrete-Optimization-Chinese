%------------------------------------------------------------------------------%
% Input Parameters
%------------------------------------------------------------------------------%
int: week_length;                        % Length of the schedule
set of int: DAY = 1..week_length;    % Set of lengths of the schedule

int: nb_workers;    % Number of the workers

int: min_daysoff;   % Minimal length of days-off blocks
int: max_daysoff;   % Maximal length of days-off blocks

int: min_work;      % Minimal length of work blocks
int: max_work;      % Maximal length of work blocks

int: nb_shifts;                            % Number of shifts
set of int: SHIFT = 1..nb_shifts;          % Set of shifts
int: OFF = nb_shifts+1;                    % off shift
set of int: SHIFT0 = 1..nb_shifts+1;       % Set of shifts + off shift
array[SHIFT] of string: shift_name;        % Name of shifts
array[SHIFT] of int:    shift_block_min;   % Minimal length of blocks
array[SHIFT] of int:    shift_block_max;   % Maximal length of blocks

array[SHIFT, DAY] of int: temp_req;    % Temporal requirements

int: nb_forbidden;                              % Number of forbidden shift sequences
set of int: FORBIDDEN = 1..nb_forbidden;                          % Set of forbidden shift sequences
array[FORBIDDEN] of int:  forbidden_before;     % The shift before in the forbidden sequence
array[FORBIDDEN] of int:  forbidden_after;      % The shift after in the forbidden sequence

int: extended_days = (nb_workers+1) * week_length;
%------------------------------------------------------------------------------%
% Decision Variables
%------------------------------------------------------------------------------%  
set of int: WEEK = 1..nb_workers+1;        
array[WEEK,DAY] of var SHIFT0: plan;
set of int: DAYS = 1..extended_days;
array[DAYS] of var SHIFT0: plan1 = array1d(plan);

%------------------------------------------------------------------------------%
% Constraints
%------------------------------------------------------------------------------%

% the n+1th week is identical to the 1st week
% captures rotating schedule
constraint forall(d in DAY)(plan[1,d] = plan[nb_workers+1,d]);

% The minimum number of shifts occur on each day of the week
include "global_cardinality_low_up.mzn";
constraint forall(d in DAY)
                 (global_cardinality_low_up([ plan[w,d] | w in 1..nb_workers], 
                                            [ sh | sh in SHIFT ], 
                                            [ temp_req[sh,d] | sh in SHIFT],
                                            [ nb_workers | sh in SHIFT]));

% No sequence of too many of the same shift
include "sliding_sum.mzn";
constraint forall(sh in SHIFT)
                 (sliding_sum(0, shift_block_max[sh], shift_block_max[sh]+1, 
                              [plan1[d] = sh | d in DAYS]));
% no sequence of too many work shifts                              
constraint sliding_sum(0, max_work, max_work+1, [plan1[d] != OFF | d in DAYS]);
% no sequence of too many off shifts
constraint sliding_sum(0, max_daysoff, max_daysoff+1, [plan1[d] = OFF | d in DAYS]);                                
             
% No sequence of too few of the same shift
constraint forall(sh in SHIFT, d in 1..extended_days-shift_block_min[sh])
                 ((plan1[d] != sh /\ plan1[d+1] = sh) -> 
                  forall(d1 in d+2..d+shift_block_min[sh])(plan1[d1] = sh));
% No sequence of too few work days
constraint forall(d in 1..extended_days - min_work)
                 ((plan1[d] = OFF /\ plan1[d+1] != OFF) ->
                  forall(d1 in d+2..d+min_work)(plan1[d1] != OFF));
% No sequence of too few off days                                     
constraint forall(d in 1..extended_days - min_daysoff)
                 ((plan1[d] != OFF /\ plan1[d+1] = OFF) ->
                  forall(d1 in d+2..d+min_daysoff)(plan1[d1] = OFF));

% No forbidden sequences
constraint forall(f in FORBIDDEN, d in 1..extended_days-1)
                 (plan1[d] = forbidden_before[f] -> 
                  plan1[d+1] != forbidden_after[f]);   
      
var int: obj = sum(w in 1..nb_workers, d in DAY)(plan[w,d] = OFF);
solve maximize obj;

%------------------------------------------------------------------------------%
% Output
%------------------------------------------------------------------------------%
output
       ["% "] ++
       [ if fix(plan[w,d]) in SHIFT then shift_name[fix(plan[w,d])] else "." endif ++
         if d = week_length then "\n% " else " " endif | w in WEEK, d in DAY]
       ++
       ["\nplan = array2d(WEEK,DAY,\(plan));\n"] ++
       ["obj = \(obj);\n"]
       ;


