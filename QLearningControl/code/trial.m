GRAVITY=9.8;
MASSCART=1.0;
MASSPOLE=0.1;
TOTAL_MASS=MASSPOLE + MASSCART;
LENGTH=0.5  % actually half the pole's length 
POLEMASS_LENGTH=MASSPOLE * LENGTH;
FORCE_MAG=10.0;
TAU=0.02;  %seconds between state updates */
FOURTHIRDS=1.3333333333333;
W_INIT=0.0;
NUM_BOXES=162;
RND_SEED = 8800;
ALPHA = 0.5; %learning rate parameter 
BETA = 0.01; %magnitude of noise added to choice */
GAMMA = 0.85; %discount factor for future reinf */
q_val=zeros(NUM_BOXES,2); % state-action values */
first_time = 1;
cur_action=0; 
prev_action=0;
cur_state=0; 
prev_state=0;
one_degree=0.0174532; 
six_degrees=0.1047192;
twelve_degrees=0.2094384;
fifty_degrees=0.87266;
success=0;
trial=1;
reinf=0.0;

function state = get_box(x,x_dot,theta,theta_dot)
box=0;

if x<-0.8
    box = 0;
elseif x< 0.8
    box = 1;
else
    box = 2;
end

if x_dot<-0.5
elseif x_dot< 0.5
    box = box+3;
else
    box = box+6;
end

if theta<-0.1047192
elseif theta< -0.0174532
    box = box+9;
elseif theta<0
    box = box+18;
elseif theta<0.0174532
    box=box+27;
elseif theta<0.1047192
    box = box+36;    
else
    box = box+45;
end

if theta_dot<-0.87266
elseif theta_dot< 0.87266
    box = box+54;
else
    box = box+108;
end

box = state;
end
