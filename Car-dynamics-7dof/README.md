# 7-dof Transverse Car Dynamics


 ![image_0.png](NOT_Sharable_OUTSIDE_TMW/README_images/image_0.png)




In this demo we derive the transverse** DYNAMIC equations of motion** of a** 7 degree of freedon(dof) **car model.  A **MODAL** analysis of the system is performed and the UNdamped MODAL frequencies and mode shapes are determined. The car model is then **simulated** in Simulink using a **Road profile** that represents a periodic placement of  **"speed humps"**.  The car's transverse response is explored for a variety of spring stiffness and damper configurations.  Finally, the response of the BRAIN derived car model is also compared to a Simscape Multibody model. The **3D CAD animations** produced by the Simscape model enhance the understanding of the vehicle's response.


  
# Owner


`Bradley Horton (bhorton@mathworks.com)`


  
# Concepts


Some key concepts that are demonstrated include:




![image_1.png](NOT_Sharable_OUTSIDE_TMW/README_images/image_1.png)




Specifically we'll look at how:



   1.  **Symbolic computing** can support and enhance the 1st principles  derivation of the system equations of motion. 
   1.  After deriving the equations of motion, you can then explore "cause and effect" by Simulating the dynamic systems in **Simulink**. 
   1.  **Simscape Multibody** is used to validate the BRAIN derived model.   
   1.  Simscape's **3D animations** also enhance the understanding of the vehicle's response. 

  
# Suggested Audience


CSEs, udergraduate students, professors, mechanical engineering, mechatronic engineering


  
# Workflow


Open, read and RUN the file **DEMO_START_HERE_PLEASE.mlx** this gives an overview of the design tasks performed by the DEMO.  It also launches a content navigator APP that helps the presenter open files for specific topics.  




![image_2.png](NOT_Sharable_OUTSIDE_TMW/README_images/image_2.png)


## DEMO_01:    Developing a Road profile model

   -  We develop a Road Profile model that represents a preiodic sequence of "speed humps". 
   -  A simulation is then performed where the Road Profile model is used to stimulate a single degree of freedom spring mass system 



![image_3.png](NOT_Sharable_OUTSIDE_TMW/README_images/image_3.png)




**The parameterised Road Profile model:**




   ![image_4.png](NOT_Sharable_OUTSIDE_TMW/README_images/image_4.png)


## DEMO_02:    Deriving and Simulating the Transverse equations of motion for a 7-dof car model

   -  **Part_1a:**   Using Newton's 2nd Law, we derive the equations of motion of a 7-dof car model - a small angle assumption is made for the PITCH and ROLL dofs. 
   -  **Part_1b:**   A MODAL analysis of the system is then performed - UNdamped modal frequencies and shapes are computed. 
   -  **Part_2:**     The 7-dof car dynamics are then simulated for a lighly DAMPED car configuration excited at it's MODAl frequencies 
   -  **Part_3:**     The 7-dof car dynamics are then simulated using a more "authentic" set of stiffness/damper values - the Road Profile model is used to stimulate the system. 
   -  In the 2 simulation scenarios described above, the response of the BRAIN derived model is compared to a corresponding Simscape Multibody model. 
   -  The 3D CAD animations produced by the Simscape model, enhance the understanding of the vehicle's simulated response.  



![image_5.png](NOT_Sharable_OUTSIDE_TMW/README_images/image_5.png)


# TODO



  
# Release that demo was last tested in


R2021a


  
# System Requirements


These demos have been developed and tested in the R2021a MATLAB release.




The Demo has the following product dependencies:



   1.  MATLAB 
   1.  Symbolic Math Toolbox 
   1.  SIMULINK 
   1.  Simscape 
   1.  Simscape Multibody 
   
![image_6.png](NOT_Sharable_OUTSIDE_TMW/README_images/image_6.png) **ATTENTION**:   A supported C-compiler is also required [https://www.mathworks.com/support/requirements/supported-compilers.html](https://www.mathworks.com/support/requirements/supported-compilers.html) *NOTE:  the FREE compilers that are listed* 

  
# Revision History


First draft 12-Aug-2021


