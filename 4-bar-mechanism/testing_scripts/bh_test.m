my_numeric.L1 = 0.4;
my_numeric.L2 = 1.4;
my_numeric.L3 = 1.2;
my_numeric.L4 = 1;
theta_rad     = pi/3;

% my_numeric.L1 = 1.2;
% my_numeric.L2 = 1.4;
% my_numeric.L3 = 0.4;
% my_numeric.L4 = 1;
% theta_rad     = 0; %pi/3;
% my_numeric.L1 = 1;
% my_numeric.L2 = 1;
% my_numeric.L3 = 1;
% my_numeric.L4 = 1;
%theta_rad     = pi/2; %pi/3;

OBJ_kin = bh_4bar_kin_CLS(my_numeric.L1, my_numeric.L2, my_numeric.L3, my_numeric.L4, theta_rad);
OBJ_kin.plot();

%OBJ_kin.plot3();

OBJ_kin.plot_valid_theta();
OBJ_kin.plot_angles_flat();
OBJ_kin.plot_angles_round();
%OBJ_kin.animate_simple();
OBJ_kin.plot_z();
