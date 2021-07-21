% Beauty Trap
% Perform the most seductive dance

enum LEGS = {spin, leap, waltz, curtsey, prep, stand};
enum ARMS = {beckon, out, up, wrapped, neutral};
enum FACE = {smile, wink, batt, think, glow, blank};

int: maxlen;
set of int: STEP = 1..maxlen;
array[LEGS] of int: maxlegs;
array[ARMS] of int: maxarms;
array[FACE] of int: maxface;
constraint assert(maxlegs[stand] >= maxlen, "maxlegs[stand] smaller than maxlen");
constraint assert(maxarms[neutral] >= maxlen, "maxarms[neutral] smaller than maxlen");
constraint assert(maxface[blank] >= maxlen, "maxface[blank] smaller than maxlen");
array[LEGS,ARMS] of int: dance_value;
array[ARMS,FACE] of int: entice_value;
constraint assert(dance_value[stand,neutral] = 0, "incorrect dance_value array");
constraint assert(entice_value[neutral,blank] = 0, "incorrect entice_value array");
int: boredom; % how bored each step make the viewer

var STEP: len;
array[STEP] of var LEGS: legs;
array[STEP] of var ARMS: arms;
array[STEP] of var FACE: face;

%include
include "global_cardinality_low_up.mzn";

%leg constraints
constraint forall(i in 2..maxlen)(legs[i] = leap -> legs[i-1] = prep);
constraint legs[1] != leap;
constraint forall(i in 1..maxlen-1)(legs[i] = spin -> (legs[i+1] = curtsey \/ legs[i+1] = prep \/ legs[i+1] = stand));
constraint forall(i in 1..maxlen-1)(legs[i] = leap -> (legs[i+1] = spin \/ legs[i+1] = waltz \/ legs[i+1] = stand));
constraint forall(i in 1..maxlen-3)((legs[i] = waltz /\ legs[i+1] = waltz /\ legs[i+2] = waltz) -> legs[i+3] != waltz);
constraint forall(i in 1..maxlen-1)(legs[i] = curtsey -> legs[i+1] != prep);
constraint forall(i in 1..maxlen-1)(legs[i] = waltz -> legs[i+1] != curtsey);
constraint forall(i in 1..maxlen-2)(legs[i] = waltz /\ legs[i+2] = curtsey -> legs[i+1] = stand);

%hand constraints
constraint forall(i in 2..maxlen)(arms[i] = beckon -> (arms[i-1] = out \/ arms[i-1] = up));
constraint arms[1] != beckon;
constraint forall(i in 2..maxlen)(arms[i] = wrapped -> (arms[i-1] = beckon \/ arms[i-1] = neutral));
constraint forall(i in 1..maxlen-1)(arms[i] = arms[i+1] -> arms[i] = neutral);
constraint arms[1] != beckon;

%facial constraints
constraint forall(i in 1..maxlen-1)(face[i] = face[i+1] -> face[i] = blank);
constraint forall(i in 2..maxlen)(face[i] = think -> (face[i-1] != smile /\ face[i-1] != batt));

%max constraints

constraint forall(j in LEGS diff {stand})(global_cardinality_low_up([legs[i] | i in STEP],[j],[0],[maxlegs[j]]));

constraint forall(j in ARMS diff {neutral})(global_cardinality_low_up([arms[i] | i in STEP],[j],[0],[maxarms[j]]));

constraint forall(j in FACE diff {blank})(global_cardinality_low_up([face[i] | i in STEP],[j],[0],[maxface[j]]));

%value constraints
constraint forall(i in 1..len)(dance_value[legs[i],arms[i]]>=0);
constraint forall(i in 1..len)(entice_value[arms[i],face[i]]>=0);


var int: dance_score = sum(i in 1..len)(dance_value[legs[i],arms[i]]);
var int: entice_score = sum(i in 1..len)(entice_value[arms[i],face[i]]);
var int: obj = dance_score + entice_score - boredom*len;
solve maximize obj;
output ["len = \(len);\n"] ++ ["legs = ["] ++ [if (i>fix(len) /\ i<=maxlen) then show(stand) else show(legs[i]) endif ++ if i==maxlen then "];\n" else ", " endif | i in STEP] ++ ["arms = ["] ++ [if (i>fix(len) /\ i<=maxlen) then show(neutral) else show(arms[i]) endif ++ if i==maxlen then "];\n" else ", " endif | i in STEP] ++ ["face = ["] ++ [if (i>fix(len) /\ i<=maxlen) then show(blank) else show(face[i]) endif ++ if i==maxlen then "];\n" else ", " endif | i in STEP] ++ ["obj = \(obj);"];
