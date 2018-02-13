GRAVITY=9.8;
MASSCART=1.0;
MASSPOLE=0.1;
TOTAL_MASS=MASSPOLE + MASSCART;
LENGTH=0.5;  % actually half the pole's length 
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
q_val=zeros(NUM_BOXES,3); % state-action values */
first_time = 1;
cur_action=0; 
prev_action=0;
cur_state=0; 
prev_state=0;
success=0;
trial=1;
reinf=0.0;
x=0;
x_dot = 0;
theta = 0;
theta_dot = 0;
tic
while success<1000000
    %% Q learning to get actions

    % predicted_value = 0; /* max_{b} Q(t, ss, b) */
    if first_time == 1
        first_time = 0;
        cur_state = 1;
        prev_state = 1;
        cur_action = 3;
        prev_action = 3;
        for i = 1:1:162
            for j = 1:1:2
                q_val(i,j) = 0;
            end
        end
    end

    prev_state = cur_state;
    prev_action = cur_action;
    cur_state = get_box(x, x_dot, theta, theta_dot);

    if prev_action ~= 3 %/* Update, but not for first action in trial */
        if cur_state == 3
            predicted_value = 0.0;
        elseif q_val(cur_state,1) <= q_val(cur_state,2)
                predicted_value = q_val(cur_state,2);
        else
            predicted_value = q_val(cur_state,1);
            q_val(prev_state,prev_action)= q_val(prev_state,prev_action) + ALPHA * (reinf + GAMMA * predicted_value - q_val(prev_state,prev_action));
        end
    end
    
     % /* Now determine best action */
    if q_val(cur_state,1) + rnd(-BETA, BETA) <= q_val(cur_state,2)
        cur_action = 2;
    else
        cur_action = 1;
    end

    action = cur_action;   
    %% Dynamics of the system
     if action == 2
        force = -FORCE_MAG;
     elseif action == 1
        force = FORCE_MAG;
    end

    temp = (force + POLEMASS_LENGTH * (theta_dot^2) * sin(theta))/ TOTAL_MASS;
    thetaacc = (GRAVITY * sin(theta) - cos(theta) * temp)/ (LENGTH * (FOURTHIRDS - MASSPOLE * cos(theta) * cos(theta)/ TOTAL_MASS));
    xacc = temp - POLEMASS_LENGTH * thetaacc * cos(theta) / TOTAL_MASS;
    % /*** Update the four state variables, using Euler's method. ***/
    x = x + (TAU * x_dot);
    x_dot = x_dot + (TAU * xacc);
    theta = theta + (TAU * theta_dot);
    theta_dot = theta_dot + (TAU * thetaacc);
    %% States
    box = get_box(x,x_dot,theta,theta_dot);
    if box==-1
        reinf=-1.0;
        predicted_value = 0.0;
        q_val(prev_state,prev_action)= q_val(prev_state,prev_action) + ALPHA * (reinf + GAMMA * predicted_value - q_val(prev_state,prev_action));
        cur_state = 1;
        prev_state = 1;
        cur_action = 3;
        prev_action = 3;
        x=rnd(-BETA,BETA);
        x_dot=rnd(-BETA,BETA);
        theta=rnd(-BETA,BETA);
        theta_dot=rnd(-BETA,BETA);
        trial = trial +1;
        success=0;
    else
        success = success + 1;
        reinf=0.0;
    end
    
end

 toc  




function random = rnd(low_bound,hi_bound)
    highest = 99999;
    random = (rand / highest) * (hi_bound - low_bound) + low_bound;
end

function state = get_box(x,x_dot,theta,theta_dot)
box=0;

if x < -2.4 || x > 2.4 || theta < -0.2094384 || theta > 0.2094384 
    box = -1; % signal failure
end
if x<-0.8
    box = 1;
elseif x< 0.8
    box = 2;
else
    box = 3;
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

state = box;
end
