classdef bh_pole_wheel_demo_selector_CLS
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ROOT_FOLDER = '';
        REF_FOLDER  = '';
    end
    
    methods
        function OBJ = bh_pole_wheel_demo_selector_CLS()
            p = mfilename('fullpath');
            [pathstr,~,~] = fileparts(p);
            OBJ.ROOT_FOLDER = pathstr;
            OBJ.REF_FOLDER  = pathstr;
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
        function position_all_MD_on_screen(OBJ)
            h_MD_list = find_system('type','block_diagram');
            % don't preocess library blockdiagrams
            isLib     = bdIsLibrary(h_MD_list);
            h_MD_list = h_MD_list(~isLib);
            %OK, so we should only have models (NOT libraries) left.
            for kk=1:length(h_MD_list)
                hMD = h_MD_list(kk);
                if(iscell(hMD))
                    hMD = hMD{1};
                end
                LOC_place_SLMODEL_onscreen(hMD)
            end
        end
        %------------------------------------------------------------------
        function plot_app_logo_pic(OBJ, hax)
           I = imread('bh_PIC_pole_wheel.JPG');
           image(hax,I);
           hax.Visible = 'off';
        end
        %------------------------------------------------------------------        
        function task_button_play_movie(OBJ,a_str)
            
                if(upper(a_str) == "SPHERICAL_CLIP")
                    fname = 'bh_sph_clip.mp4';
            elseif(upper(a_str) == "UNIVERSAL_CLIP")
                    fname = 'bh_uni_clip.mp4';
            else
                 error('###_ERROR:  sorry I dont recognise VIDEO selection'); 
                end
            
            % now play it using Image proc tbox function
            implay(fname);
        end
        
        %_#################################################################
        %    STANDARD EULER     T A B
        %_#################################################################
        function task_derive_eom_se(OBJ)
                 LOC_clear_base();   LOC_close_M_editor
                 edit('bh_MAIN_script_Standard_Euler.mlx');
        end
        %------------------------------------------------------------------
        function task_script_model_params(OBJ)
                 LOC_clear_base();   %LOC_close_M_editor
                 edit('bh_parameters_for_models');
        end
        %------------------------------------------------------------------        
        function task_model_se_hand(OBJ)
                 LOC_clear_base();   %LOC_close_M_editor
                 % load some parameters into the workspace
                 evalin('base', 'bh_MAIN_script_Standard_Euler')
                 
                 % open the model
                 MODEL = 'bh_wheel_dynamics_model_SEME';
                 open_system(MODEL);
                 h_MD = bdroot;
                 
                 % position model on screen
                 LOC_place_SLMODEL_onscreen(h_MD)               
        end
        %------------------------------------------------------------------ 
        function task_model_simscape(OBJ)
                 LOC_clear_base();   %LOC_close_M_editor
                 % load some parameters into the workspace
                 evalin('base', 'bh_MAIN_script_Standard_Euler')
                 
                 % open the model
                 MODEL = 'bh_wheel_dynamics_COMPARE_hand_SEME_to_simscape';
                 open_system(MODEL);
                 h_MD = bdroot;
                 
                 % position model on screen
                 LOC_place_SLMODEL_onscreen(h_MD)               
        end
        %------------------------------------------------------------------ 
        %_#################################################################
        %    MODIFIED EULER     T A B
        %_#################################################################
        function task_derive_eom_me(OBJ)
                 LOC_clear_base();   LOC_close_M_editor
                 edit('bh_MAIN_script_Modified_Euler.mlx');
        end
        %------------------------------------------------------------------
        function task_model_me_hand(OBJ)
                 LOC_clear_base();   %LOC_close_M_editor
                 % load some parameters into the workspace
                 evalin('base', 'bh_MAIN_script_Standard_Euler')
                 
                 % open the model
                 MODEL = 'bh_wheel_dynamics_COMPARE_hand_SEME_to_MEME';
                 open_system(MODEL);
                 h_MD = bdroot;
                 
                 % position model on screen
                 LOC_place_SLMODEL_onscreen(h_MD)               
        end
        %------------------------------------------------------------------ 
    end % METHODS
    
end  % CLASSDEF
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
function LOC_place_SLMODEL_onscreen(hMD)

    % what is the maxscreensize of the COMPUTER
    scr_max_pos    = get(0,'ScreenSize');
    scr_max_width  = scr_max_pos(3);
    scr_max_height = scr_max_pos(4);

    tgt_md_width  = 0.8*scr_max_width;
    tgt_md_height = 0.8*scr_max_height;

    % what is current MODEL window location
    md_Loc = get_param(hMD,'Location');

    % set the new MODEl location
    set_param(hMD,'Location',[20 20 tgt_md_width tgt_md_height]);
end
%**************************************************************************
function  LOC_place_scope_on_screen( scope_name )
    h = findall(0,'Type', 'figure', 'Name', scope_name);
    if(isempty(h))
        return
    end
    
    h(1).Position = [2 41 647 634];   
end
%**************************************************************************
function  LOC_close_all_but_root_level_of_model(THE_MODEL)
    Blocks_List = find_system(THE_MODEL);
    Blocks_To_Close = Blocks_List;

    for III=length(Blocks_List):-1:1
        if isempty(strfind(Blocks_List{III},'/'))
            Blocks_To_Close(III)=[];
        end
    end

    close_system(Blocks_To_Close)
end
%**************************************************************************

