global ref
ref = zeros(100);
for i=1:1:100
    ref(i) = sin(i/5);
end
ref = ref';


theta = zeros(100);
theta = theta';

Q = zeros(3,3);
R = [-10 1 -10; 1 -10 -10; -10 -10 10];
States = [1,2,3]';
Actions = [1,2,3]';
Action_values = [-0.05,0.05,0]';
gamma = 0.8;
alpha = 0.8;
curr_s = 0;
next_s = 0;
curr_a = 0;
next_a = 0;
trial = 1;
episode = 0;
total_delta_e = 0;

q = zeros(1,10);
error = 0;
tau = 0.2;
time = 0;
iterations = 0;

while episode<100
    tic
    for i = 1:1:100

        if trial ==1
            InitialState = datasample(States,1);
            InitialAction = datasample(Actions,1);
            curr_s = InitialState;
            curr_a = InitialAction;
        end
        
        delta_e = Actions(curr_a);
        total_delta_e = total_delta_e + delta_e;
        [next_s,e,tn] =  get_state(total_delta_e,theta(i),time,ref(i));
        time = time+tau;
        theta = tn;
        
        
        %% Find Action
        
        eps=rand(1); 
        if(eps<0.1)
            next_a=randi([1,3]); 
        else
            for j=1:3
                T(j)= Q(next_s,j);
            end
            [num] = max(T(:));
            [x y] = ind2sub(size(T),find(T==num));
            [countx,county]=size(y);
            if(county>1)
                c=rand(1);
                if(c>0.5)
                next_a=y(1);
                else
                next_a=y(2);
                end
            else
                next_a=y;
            end
        end
        %% 
        
        Q(curr_s,curr_a) = Q(curr_s,curr_a) + alpha*(R(curr_s,curr_a) + gamma*Q(next_s,next_a) - Q(curr_s,curr_a))
        curr_s = next_s;
        trial = trial +1;
        iterations = iterations+1;
    end
        episode = episode +1;
        trial = 1;
        time = 0;
    end



function [state,error,theta_new] = get_state(delta,angle,t,setpoint)
        angle = 0;
        q = 0.02*delta + cos(0.8937*t)/(exp(t)^0.3715) - 1133*sin(0.8937*t)/(17875.31*exp(t)^0.37155) - 0.09375*delta*sin(0.8937*t)/exp(t)^(0.3715);
        theta_new = angle + t*q;
        error = theta_new - setpoint;
        if error < 0.1 && error > -0.1
            state = 3;
        elseif error < -0.1;
            state = 1;
        elseif error > 0.1
            state = 2;
        end       
end
        
 