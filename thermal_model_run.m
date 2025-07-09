function [T_1,T_2,soc,sout] = thermal_model_run(I_in,T_ini,soc_init,T_un)
% 输入为电流，初始温度，soc初始值或soc所有值（0-100），环境温度（恒定或所有值）
if T_un == 0
    T_un = T_ini*ones(length(I_in),1);
elseif length(T_un)==1
    T_un = T_un*ones(length(I_in),1);
end
T_un = [(1:1:length(T_un))',T_un];
I=[(1:1:length(T_un))',I_in];	
bat_an = zeros(length(I_in),1);
soc = zeros(length(I_in),1);
for i = 2:length(I_in)
    bat_an(i-1) = I_in(i-1)/3600;
    soc(i) = soc(i-1) + bat_an(i-1);
end
if length(soc_init)<2
    soc = [(1:1:length(T_un))',soc/34.3+soc_init/100];
else
    soc = [(1:1:length(T_un))',soc_init/100];
end
assignin("base",'soc',soc);
assignin("base",'I',I);
assignin("base",'T_un',T_un);
assignin("base",'T_ini',T_ini);
load_system("battery_func_nonTun.slx");
sout = sim("battery_func_nonTun.slx",length(I_in));
T_2 = sout.t2;
T_1 = sout.t1;
