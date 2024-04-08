[L1, L2, L3, L4] = bh_get_preconfigured_machine("MACHINE_D");
theta_rad = -pi/2;
OBJ_kin = bh_4bar_kin_CLS(L1,L2,L3,L4, theta_rad);
OBJ_kin.plot();

OBJ_kin.plot_valid_theta();
OBJ_kin.plot_angles_flat();
OBJ_kin.plot_angles_round();
%OBJ_kin.animate_simple();