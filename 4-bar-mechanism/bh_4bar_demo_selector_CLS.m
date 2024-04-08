classdef bh_4bar_demo_selector_CLS
   
    properties
        ROOT_FOLDER = '';
        REF_FOLDER  = '';
    end
    
methods
function OBJ = bh_4bar_demo_selector_CLS()
    p = mfilename('fullpath');
    [pathstr,~,~] = fileparts(p);
    OBJ.ROOT_FOLDER = string(pathstr);
    OBJ.REF_FOLDER  = string(pathstr);
end
%------------------------------------------------------------------
function clear_base(OBJ)
    LOC_clear_base();
end
%------------------------------------------------------------------
function close_editor(OBJ)
    LOC_close_M_editor();
end
%------------------------------------------------------------------
function open_content_app(OBJ)   
    bh_4bar_demo_launcher_app();   
end
%_#########################################################################
function do_system_check(obj, app)
    LOC_do_system_check(app);
end
%------------------------------------------------------------------
%_#########################################################################
function execute_start_here(OBJ, DEMO_ID)
    DEMO_ID      = upper(string(DEMO_ID));
    % all should be UPPER case
    allowed_string_list = [ "THE 4BAR EXPLORER APP",             ...
                            "KINEMATIC_DERIVATION_CIRCLES",      ...
                            "KINEMATIC_EXAMPLE",                 ...
                            "DYNAMIC_DERIVATION_LAGCONSTRAINTS", ...
                            "DYNAMIC_EXAMPLE_SIMULATION"  ];
    % confirm our selection is a member of our allowed list
    mustBeMember(DEMO_ID, allowed_string_list)

    % make sure you're in the WORKING folder
    OBJ.cd_into_working_folder();
    
    LOC_clear_base();  LOC_close_M_editor();                  
   
    switch DEMO_ID
        case "THE 4BAR EXPLORER APP"
            bh_4bar_explore_app();
        case "KINEMATIC_DERIVATION_CIRCLES"
             edit('DEMO_01b_bh_4bar_analysis_kinematics');
        case "KINEMATIC_EXAMPLE"
            edit('DEMO_07_bh_4bar_matrix_velocity_analysis_sweep')
        case "DYNAMIC_DERIVATION_LAGCONSTRAINTS"
            edit('DEMO_02b_bh_4bar_analysis_dynamics')
        case "DYNAMIC_EXAMPLE_SIMULATION"
            edit('DEMO_03b_bh_4bar_DYN_sim')
    end % switch

end
%_#########################################################################
function execute_KIN_01_KNOB_selection(OBJ, DEMO_ID)
    DEMO_ID      = upper(string(DEMO_ID));
    
    % all should be UPPER case
    allowed_string_list = [  "NOTHING", "KINEMATIC_DERIVATION", ...
                             "KINEMATIC_DERIVATION_ALTERNATE", ...
                             "EXPLORE_SINGULARITIES", ...
                             "EXPLORE_SINGULARITIES_PART_2", ...
                             "THE_APP", ...
                             "KINEMATIC_SIMULATION_MODEL", ...
                             "VELOCITY_ANALYSIS_CASE_STUDY_01", ...
                             "VELOCITY_ANALYSIS_CASE_STUDY_02", ...
                             "VELOCITY_ANALYSIS_SWEEP"];
        
    % confirm our selection is a member of our allowed list
    mustBeMember(DEMO_ID, allowed_string_list)

    % make sure you're in the WORKING folder
    OBJ.cd_into_working_folder();
    
    LOC_clear_base();  LOC_close_M_editor();                  
   
    switch DEMO_ID
        case "NOTHING"
              return
        case "KINEMATIC_DERIVATION"
             edit('DEMO_01_bh_4bar_analysis_kinematics');
        case "KINEMATIC_DERIVATION_ALTERNATE"
             edit('DEMO_01b_bh_4bar_analysis_kinematics');
        case "EXPLORE_SINGULARITIES"
             edit('bh_explore_Singularities')
        case "EXPLORE_SINGULARITIES_PART_2"
            edit('bh_explore_Singularities_part_2');
        case "THE_APP"
              bh_4bar_explore_app();
        case "KINEMATIC_SIMULATION_MODEL"
            edit('DEMO_03a_bh_4bar_KIN_sim')
        case "VELOCITY_ANALYSIS_CASE_STUDY_01"
            edit('DEMO_05_bh_4bar_simple_velocity_analysis')
        case "VELOCITY_ANALYSIS_CASE_STUDY_02"
            edit('DEMO_06_bh_4bar_matrix_velocity_analysis')
        case "VELOCITY_ANALYSIS_SWEEP"
            edit('DEMO_07_bh_4bar_matrix_velocity_analysis_sweep')
    end % switch
end
%------------------------------------------------------------------
function execute_DYN_01_KNOB_selection(OBJ, DEMO_ID)
    DEMO_ID      = upper(string(DEMO_ID));
    
    % all should be UPPER case
    allowed_string_list = [  "NOTHING", "DYNAMIC_DERIVATION", ...
                             "DYNAMIC_DERIVATION_ALTERNATE", ...
                             "DYNAMIC_SIMULATION_MODEL", ...
                             "EXPLORE_JACOBIANS"];
        
    % confirm our selection is a member of our allowed list
    mustBeMember(DEMO_ID, allowed_string_list)

    % make sure you're in the WORKING folder
    OBJ.cd_into_working_folder();
    
    LOC_clear_base();  LOC_close_M_editor();                  
   
    switch DEMO_ID
        case "NOTHING"
              return
        case "DYNAMIC_DERIVATION"
             edit('DEMO_02_bh_4bar_analysis_dynamics')
        case "DYNAMIC_DERIVATION_ALTERNATE"  
             edit('DEMO_02b_bh_4bar_analysis_dynamics')
        case "DYNAMIC_SIMULATION_MODEL"
            edit('DEMO_03b_bh_4bar_DYN_sim')
        case "EXPLORE_JACOBIANS"
            edit('DEMO_04_explore_jacobs')
    end % switch
end
%------------------------------------------------------------------
function execute_kinematics_app_BUTTON(OBJ)
    bh_4bar_explore_app();
end
%------------------------------------------------------------------
function wk_folder = get_working_folder(OBJ)   
    wk_folder = string(OBJ.ROOT_FOLDER);
end
%------------------------------------------------------------------
function cd_into_working_folder(OBJ)
    my_pwf                  = string(pwd);   
    THE_TGT_WORKING_FOLDER  = OBJ.ROOT_FOLDER;
    
    if(my_pwf ~= THE_TGT_WORKING_FOLDER)
         cd( THE_TGT_WORKING_FOLDER );
    end
end
%------------------------------------------------------------------
function help_MN(OBJ)
    web(fullfile(docroot, 'matlab/index.html'))
end
%------------------------------------------------------------------
function help_GS(OBJ)
    web(fullfile(docroot, 'matlab/getting-started-with-matlab.html'))
end
%------------------------------------------------------------------
end % methods
%_*************************************************************************
end % classdef
%_#########################################################################
function LOC_clear_base()
   evalin('base', 'clear all; clc')  
end
%**************************************************************************
function LOC_close_M_editor
%close the M-file Editor
  evalin('base',['com.mathworks.mlservices.MatlabDesktopServices.getDesktop().closeGroup(''Editor'')']);
end
%**************************************************************************
function LOC_open_pdf_file(THE_PDF_FILE)
   if(ispc)
       open(THE_PDF_FILE);
   else
      web(THE_PDF_FILE) 
   end
end
%**************************************************************************
function LOC_do_system_check(app)
    DEFAULT_COLOR = [255 191 0]/255; % orange
    app.LAMP_SYMT.Color = DEFAULT_COLOR;
    app.LAMP_ML.Color   = DEFAULT_COLOR;            
    app.LAMP_SL.Color   = DEFAULT_COLOR;            
    app.LAMP_SC.Color   = DEFAULT_COLOR;            
    app.LAMP_SCMB.Color = DEFAULT_COLOR;

    % just pause for a second
    pause(1);

    % what products do you have
    v_S          = ver;
    prod_list_CE = {v_S.Name}';
    %prod_list_CE([31, 63, 67]) = []; % for testing only !
    % update the lamps
    my_database_CE = ...
        { 
          'Symbolic Math Toolbox',        'LAMP_SYMT';                  
          'MATLAB',                       'LAMP_ML';
          'Simulink',                     'LAMP_SL';
          'Simscape',                     'LAMP_SC';
          'Simscape Multibody',           'LAMP_SCMB';
          };
      NUM_LAMPS = size(my_database_CE,1);
      for kk=1:NUM_LAMPS
          the_prod_str  = my_database_CE{kk,1};
          the_field_str = my_database_CE{kk,2};
          tf_i_have_prod = strcmp(prod_list_CE, the_prod_str);

          if(1==nnz(tf_i_have_prod))
              app.(the_field_str).Color = 'green';
          else
              app.(the_field_str).Color = 'red';
          end
      end % for
end % function do_product_check(app)    end
%**************************************************************************

