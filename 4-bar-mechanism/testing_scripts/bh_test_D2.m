L1 = 0.5;  L2=1; L3=L1; L4=L2;
%[L1, L2, L3, L4] = bh_get_preconfigured_machine("MACHINE_D");

theta_deg = -180:5:180;
theta = deg2rad(theta_deg);

[the_z,the_num,the_den] = bh_z_func(L1,L2,L3,L4,theta);

figure;
plot(theta_deg, the_z(1,:), '-ro');
hold on
plot(theta_deg, the_z(2,:), '-bo');
grid on