classdef bh_rolling_wheel_toy_CLS
    properties
        %----------------------------
        wheel_radius         = []; % (m)
        hax                  = [];
        tf_show_ground_trail = true;
        %----------------------------
    end
  
    properties (SetAccess = protected)
       hS_rim   = [];
       hP_wheel = [];
       hL_bff   = [];
       %------------
       X_g_birth_wheel = [];
       Y_g_birth_wheel = [];
       Z_g_birth_wheel = [];
       
       X_g_birth_rim   = [];
       Y_g_birth_rim   = [];
       Z_g_birth_rim   = [];
       
       X_g_birth_bff   = [];
       Y_g_birth_bff   = [];
       Z_g_birth_bff   = [];
      
    
    end
    
    %_*********************************************************************
    methods
        function OBJ = bh_rolling_wheel_toy_CLS(wheel_radius, hax)
            OBJ.wheel_radius = wheel_radius; 
            OBJ.hax          = hax;
            OBJ = PROT_define_birth_body_XYZ(OBJ);
        end
        %------------------------------------------------------------------
        function OBJ = plot(OBJ, angs_list, CG_XYZ)
           
           if(~ishghandle(OBJ.hax))
              % do nothing 
              return
           end
           
           Xw_G = OBJ.X_g_birth_wheel;
           Yw_G = OBJ.Y_g_birth_wheel;
           Zw_G = OBJ.Z_g_birth_wheel; 
           
           Xr_G = OBJ.X_g_birth_rim;
           Yr_G = OBJ.Y_g_birth_rim;
           Zr_G = OBJ.Z_g_birth_rim; 
           
           Xf_G = OBJ.X_g_birth_bff;
           Yf_G = OBJ.Y_g_birth_bff;
           Zf_G = OBJ.Z_g_birth_bff; 
           
            
           % rotate the BIRTH co-ordinates
           passive_rot_OBJ = bh_rot_passive_G2B_CLS({'D1Z', 'D2Y', 'D3X'}, angs_list, 'RADIANS');
           R               = passive_rot_OBJ.get_R;
            
           new_XYZw_G = inv(R)* [Xw_G(:)'; Yw_G(:)';  Zw_G(:)';];
           new_XYZr_G = inv(R)* [Xr_G(:)'; Yr_G(:)';  Zr_G(:)';];
           new_XYZf_G = inv(R)* [Xf_G(:)'; Yf_G(:)';  Zf_G(:)';];
           
           % translate
           new_XYZw_G = new_XYZw_G + CG_XYZ(:); % VECTOR expansion
           new_XYZr_G = new_XYZr_G + CG_XYZ(:); % VECTOR expansion
           new_XYZf_G = new_XYZf_G + CG_XYZ(:); % VECTOR expansion
           
           % now update the existing HG objects
           set(OBJ.hS_rim, ...
               'XData', new_XYZr_G(1,:), ...
               'YData', new_XYZr_G(2,:), ...
               'ZData', new_XYZr_G(3,:)     );
           
           set(OBJ.hP_wheel, ...
               'XData', new_XYZw_G(1,:), ...
               'YData', new_XYZw_G(2,:), ...
               'ZData', new_XYZw_G(3,:)     );
           
           set(OBJ.hL_bff, ...
               'XData', new_XYZf_G(1,:), ...
               'YData', new_XYZf_G(2,:), ...
               'ZData', new_XYZf_G(3,:)     );
           
           % now develop the contact point ground trace
           passive_rot_OBJ = bh_rot_passive_G2B_CLS({'D1Z', 'D2Y'}, angs_list(1:2), 'RADIANS');
           R               = passive_rot_OBJ.get_R;           
           
           contact_point_XYZr_E = inv(R)* [0;0;(-OBJ.wheel_radius)];
           contact_point_XYZr_E = contact_point_XYZr_E + CG_XYZ(:);
           
           % OK now let's draw it
           hL   = findobj(OBJ.hax, 'Type','animatedline', 'Tag', 'BH_ANIM_LINE_TAG');
           if(isempty(hL))
                hL = animatedline('Tag',       'BH_ANIM_LINE_TAG', ...
                                  'Parent',    OBJ.hax, ...
                                  'LineStyle', '-',...
                                  'LineWidth', 2,...
                                  'Color',     'cyan');
                              
             % act on specific requests
             if(false == OBJ.tf_show_ground_trail)
                hL.Visible = 'off';
             end
                              
           end
            
           % now update the line
           addpoints(hL, contact_point_XYZr_E(1), ...
                         contact_point_XYZr_E(2), ...
                         contact_point_XYZr_E(3)  );           
           
        end
        %------------------------------------------------------------------
        function OBJ = plot_birth(OBJ)
             if(~ishghandle(OBJ.hax))
                % do nothing 
                return
             end
            
             axes(OBJ.hax);
             % clear the axis
             cla(OBJ.hax);
             hold(OBJ.hax, "on");
             set(OBJ.hax, 'Color', [1,1,1]*0.75)   
                
             % rim
             X = OBJ.X_g_birth_rim;
             Y = OBJ.Y_g_birth_rim;
             Z = OBJ.Z_g_birth_rim;
             my_rgb_mat = jet(length(X));
        
             hS_rim     = scatter3(X,Y,Z, 40, my_rgb_mat, 'filled');
             
             % wheel
             X = OBJ.X_g_birth_wheel;
             Y = OBJ.Y_g_birth_wheel;
             Z = OBJ.Z_g_birth_wheel;

             hP_wheel = patch(X,Y,Z, 'b', 'FaceAlpha',0.3, ...
                              'EdgeColor', 'k', 'LineWidth', 1); 
                          
             % the body fixed Cg frame 
             hL_bff = plot3( OBJ.X_g_birth_bff, OBJ.Y_g_birth_bff, OBJ.Z_g_birth_bff, ...
                             '-g', "LineWidth",2 );            
            
             % store the HG objects
             OBJ.hS_rim   = hS_rim;
             OBJ.hP_wheel = hP_wheel;
             OBJ.hL_bff   = hL_bff;    
                          
             % set camera view
             az = -10;  el = 10; 
             view(OBJ.hax,az, el)

             %axis tight
             axis(OBJ.hax, 'equal');
             grid(OBJ.hax, 'on');
        end % plot_birth()
    end % methods
    %_*********************************************************************
    % END METHODS(Access=public)
    %_*********************************************************************
    methods (Access = protected)
        function OBJ = PROT_define_birth_body_XYZ(OBJ)

            % wheel
            XYZ_dat = [];
            NF = 100;
            t = [linspace(0, 2*pi, NF+1)]' ;
            R = OBJ.wheel_radius;
            XYZ_dat = [zeros(size(t)), R*cos(t), R*sin(t)];

            OBJ.X_g_birth_wheel = XYZ_dat(:,1);
            OBJ.Y_g_birth_wheel = XYZ_dat(:,2);
            OBJ.Z_g_birth_wheel = XYZ_dat(:,3);
            
            % rim
            OBJ.X_g_birth_rim   = OBJ.X_g_birth_wheel;
            OBJ.Y_g_birth_rim   = OBJ.Y_g_birth_wheel;
            OBJ.Z_g_birth_rim   = OBJ.Z_g_birth_wheel;
            
            % the body fixed CG frame
            tmp_mat = ...
                 [0, 0, 0;
                  1, 0, 0;
                  NaN,NaN,NaN;
                  0, 0, 0;
                  0, 1, 0;
                  NaN,NaN,NaN;
                  0,0,0;
                  0, 0, 1;
                  ];
              
            tmp_mat = tmp_mat * OBJ.wheel_radius/3; 
             
            OBJ.X_g_birth_bff   = tmp_mat(:,1);
            OBJ.Y_g_birth_bff   = tmp_mat(:,2);
            OBJ.Z_g_birth_bff   = tmp_mat(:,3);
            
            xlabel("X");
            ylabel("Y");
            zlabel("Z");
        end
        %------------------------------------------------------------------ 
    end %(Access = protected)
    %
    end % classdef
%_#########################################################################
% END of CLASSDEF
%_#########################################################################


