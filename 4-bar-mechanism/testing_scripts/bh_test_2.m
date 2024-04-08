my_numeric.L1 = 0.4;
my_numeric.L2 = 2;
my_numeric.L3 = 0.4;
my_numeric.L4 = 2;
theta_rad     = pi; %pi/2; %pi/3;

OBJ_kin = bh_4bar_kin_CLS(my_numeric.L1, my_numeric.L2, my_numeric.L3, my_numeric.L4, theta_rad);
OBJ_kin.plot();

OBJ_kin.plot_valid_theta();
OBJ_kin.plot_angles_flat();
OBJ_kin.plot_angles_round();
%OBJ_kin.animate_simple();