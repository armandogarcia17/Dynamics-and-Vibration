classdef bh_wheel_toy_CLS
% BH_WHEEL_TOY_CLS 
%   A simple class for drawing a "wheel" 
%
% Example USAGE:
%
%    OBJ = bh_wheel_toy_CLS()
%
%    figure();
%       hax(1) = axes;
%       OBJ.plot_3D(hax(1));
%--------------------------------------------------------------------------
%    [X,Y,Z] = OBJ.get_B_XYZ();
%    
%    a = 45*pi/180;
%
%  gRb = [cos(a),  -sin(a),  0;
%         sin(a),   cos(a),  0;
%              0,        0,  1; ];
%
%    new_XYZ = agRb * [X';
%                      Y';
%                      Z' ];
%
%    OBJ = OBJ.set_G_XYZ(new_XYZ(1,:)', new_XYZ(2,:)', new_XYZ(3,:)');
%-------------------------------------------------------------------------- 
%    figure();
%       hax(1) = axes;  
%       OBJ.plot_3D(hax(1));
%--------------------------------------------------------------------------
    properties
        %----------------------------
        wheel_radius  = []; % (m)
        rod_length    = []; % (m)
        %----------------------------
    end
  
    properties (SetAccess = protected)
       X_b_col = [];
       Y_b_col = [];
       Z_b_col = [];
       %------------
       X_g_col = [];
       Y_g_col = [];
       Z_g_col = [];
    end
    
    properties (SetAccess = protected, GetAccess = protected)
       X_b_rod_col   = []; 
       X_b_wheel_col = [];
       %-----------------------
       Y_b_rod_col   = []; 
       Y_b_wheel_col = [];
       %-----------------------
       Z_b_rod_col   = []; 
       Z_b_wheel_col = [];
       %-----------------------
       X_g_rod_col   = []; 
       X_g_wheel_col = [];
       %-----------------------
       Y_g_rod_col   = []; 
       Y_g_wheel_col = [];
       %-----------------------
       Z_g_rod_col   = []; 
       Z_g_wheel_col = [];
       %-----------------------
    end
    
    methods
        function OBJ = bh_wheel_toy_CLS(wheel_radius, rod_len)
            OBJ.wheel_radius = wheel_radius; 
            OBJ.rod_length   = rod_len;
            
            OBJ = PROT_define_birth_body_XYZ(OBJ);
            OBJ = set_G_XYZ(OBJ, OBJ.X_b_col, OBJ.Y_b_col, OBJ.Z_b_col);
        end
        %------------------------------------------------------------------
        function [X,Y,Z] = get_B_XYZ(OBJ)
                  X = OBJ.X_b_col;
                  Y = OBJ.Y_b_col;
                  Z = OBJ.Z_b_col;
        end
        %------------------------------------------------------------------
        function [X,Y,Z] = get_G_XYZ(OBJ)
                  X = OBJ.X_g_col;
                  Y = OBJ.Y_g_col;
                  Z = OBJ.Z_g_col;
        end
        %------------------------------------------------------------------   
        function V_3xN = get_G_XYZ_3xN(OBJ)
                  X = OBJ.X_g_col;
                  Y = OBJ.Y_g_col;
                  Z = OBJ.Z_g_col;
                  
                  V_3xN = [X';
                           Y';
                           Z'];
        end
        %------------------------------------------------------------------
        function V_3xN = get_B_XYZ_3xN(OBJ)
                  X = OBJ.X_b_col;
                  Y = OBJ.Y_b_col;
                  Z = OBJ.Z_b_col;
                  
                  V_3xN = [X';
                           Y';
                           Z'];
        end
        %------------------------------------------------------------------    
        function OBJ = set_G_XYZ(OBJ, Xg, Yg, Zg)
                 OBJ = PROT_set_G_XYZ(OBJ, Xg, Yg, Zg);
        end
        %------------------------------------------------------------------
        function hax = plot_3D(OBJ, hax)
                 hax = PROT_plot_3D(OBJ, hax);
        end
        %------------------------------------------------------------------
        function hax = plot_XY(OBJ, hax)
              hax = PROT_plot_3D(OBJ, hax);
              % set camera view
              az = 0;  el = 90; 
              view(hax, az, el);
        end
        %------------------------------------------------------------------                    
        function hax = plot_XZ(OBJ, hax)
              hax = PROT_plot_3D(OBJ, hax);
              % set camera view
              az = 180;  el = 0; 
              view(hax, az, el);
        end
        %------------------------------------------------------------------        
        function hax = plot_YZ(OBJ, hax)
              hax = PROT_plot_3D(OBJ, hax);
              % set camera view
              az = 90;  el = 0; 
              view(hax, az, el);
        end
        %------------------------------------------------------------------ 
        function [OBJ, hax] = rotate_and_animate(OBJ, arot_OBJ, hax)
            ANG_1st_FULL = arot_OBJ.ang_1st;
            ANG_2nd_FULL = arot_OBJ.ang_2nd;
            ANG_3rd_FULL = arot_OBJ.ang_3rd;

            ANG_UNITS    = char(arot_OBJ.ang_units);
            
            NUM_STEPS    = 25;

            ANG_1st_step = ANG_1st_FULL / NUM_STEPS;
            ANG_2nd_step = ANG_2nd_FULL / NUM_STEPS;
            ANG_3rd_step = ANG_3rd_FULL / NUM_STEPS;

            % animate the 1st rotation
            for kk=0:NUM_STEPS
                inc_arot_OBJ  = bh_rot_active_B2G_CLS(    ...
                                       {char(arot_OBJ.dir_1st)},...
                                       [kk*ANG_1st_step], ...
                                       ANG_UNITS);
                                   
                V_3xN   = OBJ.get_B_XYZ_3xN();       
                new_XYZ = inc_arot_OBJ.apply_active_R1(V_3xN); % apply the rotation
                OBJ     = OBJ.set_G_XYZ(new_XYZ(1,:)',new_XYZ(2,:)',new_XYZ(3,:)');
                % update the vehicle's PLOT
                cla(hax);
                OBJ.plot_3D(hax);
                pause(0.1)
            end % for kk=0:NUM_STEPS
            
            % animate the 2nd rotation
            for kk=0:NUM_STEPS
                inc_arot_OBJ  = bh_rot_active_B2G_CLS( ...
                                       {char(arot_OBJ.dir_1st), ...
                                          char(arot_OBJ.dir_2nd)}, ...
                                       [ANG_1st_FULL, kk*ANG_2nd_step], ...
                                       ANG_UNITS);
                                   
                V_3xN   =  OBJ.get_B_XYZ_3xN();       
                new_XYZ = inc_arot_OBJ.apply_active_R1R2(V_3xN); % apply the rotation
                OBJ = OBJ.set_G_XYZ(new_XYZ(1,:)',new_XYZ(2,:)',new_XYZ(3,:)');
                % update the vehicle's PLOT
                cla(hax);
                OBJ.plot_3D(hax);
                pause(0.1)
            end % for kk=
            
            % animate the 3rd rotation
            for kk=0:NUM_STEPS
                inc_arot_OBJ  = bh_rot_active_B2G_CLS(   ...
                                       {char(arot_OBJ.dir_1st), ...
                                          char(arot_OBJ.dir_2nd), ...
                                          char(arot_OBJ.dir_3rd)}, ...
                                       [ANG_1st_FULL, ANG_2nd_FULL, ...
                                          kk*ANG_3rd_step], ...
                                       ANG_UNITS);
                                   
                V_3xN   =  OBJ.get_B_XYZ_3xN();       
                new_XYZ = inc_arot_OBJ.apply_active_R1R2R3(V_3xN); % apply the rotation
                OBJ = OBJ.set_G_XYZ(new_XYZ(1,:)',new_XYZ(2,:)',new_XYZ(3,:)');
                % update the vehicle's PLOT
                cla(hax);
                OBJ.plot_3D(hax);
                pause(0.1)
            end % for kk=           
            
        end % rotate_then_plot_3D()
    end
    %_*********************************************************************
    % END METHODS(Access=public)
    %_*********************************************************************
    methods (Access = protected)
        function OBJ = PROT_define_birth_body_XYZ(OBJ)
            % rod
            XYZ_dat = [];
            XYZ_dat = [ 0,              0,   0; 
                        OBJ.rod_length, 0,   0];

            OBJ.X_b_rod_col = XYZ_dat(:,1);
            OBJ.Y_b_rod_col = XYZ_dat(:,2);
            OBJ.Z_b_rod_col = XYZ_dat(:,3);

            % wheel
            XYZ_dat = [];
            NF = 100;
            t = [linspace(0, 2*pi, NF+1)]' ;
            R = OBJ.wheel_radius;
            XYZ_dat = [OBJ.rod_length*ones(size(t)), R*cos(t), R*sin(t)];

            OBJ.X_b_wheel_col = XYZ_dat(:,1);
            OBJ.Y_b_wheel_col = XYZ_dat(:,2);
            OBJ.Z_b_wheel_col = XYZ_dat(:,3);            
             
             % define the flat list of X,Y,Z
             OBJ.X_b_col = [ 
                               OBJ.X_b_rod_col; 
                               OBJ.X_b_wheel_col;
                           ];
             OBJ.Y_b_col = [ 
                               OBJ.Y_b_rod_col; 
                               OBJ.Y_b_wheel_col;
                           ];
             OBJ.Z_b_col = [ 
                               OBJ.Z_b_rod_col; 
                               OBJ.Z_b_wheel_col;
                           ];                
        end
        %------------------------------------------------------------------ 
        function OBJ = PROT_set_G_XYZ(OBJ, Xg, Yg, Zg)
            Xg = Xg(:);
            Yg = Yg(:);
            Zg = Zg(:);
            
            tf_test_a =(length(Xg)==length(Yg)) && (length(Xg)==length(Yg));
            tf_test_b =(length(Xg)==length(OBJ.X_b_col));
            
            assert(tf_test_a, 'ERROR: your Xg,Yg,Zg have different lengths');
            assert(tf_test_b, 'ERROR: your G lengths are different to the B lengths');
            
            OBJ.X_g_col = Xg;
            OBJ.Y_g_col = Yg;
            OBJ.Z_g_col = Zg;

            OBJ.X_g_rod_col    = Xg( 1:2);
            OBJ.X_g_wheel_col  = Xg( 3:end); 
            %-----------------------
            OBJ.Y_g_rod_col    = Yg( 1:2);
            OBJ.Y_g_wheel_col  = Yg( 3:end); 
            %-----------------------
            OBJ.Z_g_rod_col    = Zg( 1:2);
            OBJ.Z_g_wheel_col  = Zg( 3:end); 
        end
        %------------------------------------------------------------------ 
        function hax = PROT_plot_3D(OBJ, hax)
             if(isempty(hax))
                hax = axes;
             end
            
             axes(hax);
             % clear the axis
             cla(hax);
             hold on
             
             % rod
             X = OBJ.X_g_rod_col;
             Y = OBJ.Y_g_rod_col;
             Z = OBJ.Z_g_rod_col;

             hL_rod = plot3(X,Y,Z, '-r', 'LineWidth',3);

             % wheel
             X = OBJ.X_g_wheel_col;
             Y = OBJ.Y_g_wheel_col;
             Z = OBJ.Z_g_wheel_col;

             hP_wheel = patch(X,Y,Z, 'b', 'FaceAlpha',0.3, ...
                              'EdgeColor', 'k', 'LineWidth', 3); 
            
             axis equal
             grid on

             xlabel('X', 'FontWeight', 'Bold');
             ylabel('Y', 'FontWeight', 'Bold');
             zlabel('Z', 'FontWeight', 'Bold');
                        
             % set camera view
             az = -10;  el = 10; 
             view(az, el)

             %axis tight
             axis equal
          
             % set limits
             N = 1.3 * max([OBJ.wheel_radius, OBJ.rod_length]);
             
             xlim([-N, N]);
             ylim([-N, N]);
             zlim([-N, N]);
             
             % draw the stand
             plot3([0 0],[0 0],[0 -N], '-g', 'LineWidth',3);
             
        end
        %------------------------------------------------------------------ 
    end %(Access = protected)
    %
end
%_#########################################################################
% END of CLASSDEF
%_#########################################################################


