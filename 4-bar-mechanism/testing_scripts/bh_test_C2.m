[L1, L2, L3, L4] = bh_get_preconfigured_machine("MACHINE_C");
theta_rad = -pi/2;
OBJ_kin = bh_4bar_kin_CLS(L1,L2,L3,L4, theta_rad);
OBJ_kin.plot_circles(30);

