my_numeric.L1 = 0.4;
my_numeric.L2 = 1;
my_numeric.L3 = 0.4;
my_numeric.L4 = 1;
theta_rad     = pi; %pi/2; %pi/3;

[the_z, the_num, the_den] = bh_z_calc_util(my_numeric.L1,...
                                           my_numeric.L2,...
                                           my_numeric.L3, ...
                                           my_numeric.L4, theta_rad, "CALC_Z")
