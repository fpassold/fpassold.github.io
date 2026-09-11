>> pkg load control
>> H1=tf(0.1,poly([-0.1, -1]))

Transfer function 'H1' from input 'u1' to output ...

             0.1       
 y1:  -----------------
      s^2 + 1.1 s + 0.1

Continuous-time model.
>> H2=tf(0.1,[1, 0.1])

Transfer function 'H2' from input 'u1' to output ...

        0.1  
 y1:  -------
      s + 0.1

Continuous-time model.
>> figure; sobplot(121); pzmap(H1); legend off; title('H1(s)');
error: 'sobplot' undefined near line 1, column 9
>> pole(H1)
ans =

  -1.0000
  -0.1000

>> 
>> figure; subplot(121); pzmap(H1); legend off; title('H1(s)');
>> 
>> subplot(122); pzmap(H2); legend off; title('H2(s)');
>> xlim([-2 1])
>> subplot(121); xlim([-2 -1])
>> subplot(121); xlim([-2 1])
>> subplot(121); xlim([-1.5 0.5])
>> subplot(122); xlim([-1.5 0.5])
>> print("pzmap_H1_H2_G.png", "-dpng", "-r150");  % salva figura com resulução melhor
>> 
>> figure; step(H1, H2); legend off
>> 
>> legend('H1(s)', 'H2(s)', 'Location', 'southeast');
>> 
>> print("step_H1_H2_G.png", "-dpng", "-r150");  % salva figura com resulução melhor
>> 
>> save TED2-respostas.mat
>> 
>> H3=tf(4,poly([-1 -4]))

Transfer function 'H3' from input 'u1' to output ...

            4      
 y1:  -------------
      s^2 + 5 s + 4

Continuous-time model.
>> H4=tf(4,[1 4])

Transfer function 'H4' from input 'u1' to output ...

        4  
 y1:  -----
      s + 4

Continuous-time model.
>> figure; subplot(121); pzmap(H3); legend off; title('H3(s)');
>> 
>> subplot(122); pzmap(H4); legend off; title('H4(s)');
>> xlim([-5 1])
>> subplot(121)
>> xlim([-5 1])
>> print("pzmap_H3_H4.png", "-dpng", "-r150");  % salva figura com resulução melhor
>> figure; step(H3, H4); legend off
>> legend('H3(s)', 'H4(s)', 'Location', 'southeast');
>> 
>> print("step_H3_H4.png", "-dpng", "-r150");  % salva figura com resulução melhor
>> 
>> 
>> save TED2-respostas.mat
>> 
>> H5=tf(12,poly([-3 -4]))

Transfer function 'H5' from input 'u1' to output ...

            12      
 y1:  --------------
      s^2 + 7 s + 12

Continuous-time model.
>> H6=tf(3,[1 3])

Transfer function 'H6' from input 'u1' to output ...

        3  
 y1:  -----
      s + 3

Continuous-time model.
>> figure; subplot(121); pzmap(H5); legend off; title('H5(s)');
>> 
>> subplot(122); pzmap(H6); legend off; title('H6(s)');
>> xlim([-5 1])
>> subplot(121)
>> xlim([-5 1])
>> print("pzmap_H5_H6.png", "-dpng", "-r150");  % salva figura com resulução melhor
>> figure; step(H5, H6); legend off
>> legend('H5(s)', 'H6(s)', 'Location', 'southeast');
>> 
>> print("step_H5_H6.png", "-dpng", "-r150");  % salva figura com resulução melhor
>> 
>> stepinfo(H5) # do sistema completo
ans =

  scalar structure containing the fields:

    RaiseTime = [](0x0)
    RiseTime = 0.9851
    TransientTime = 1.7180
    SettlingTime = 1.7180
    SettlingMin = 0.9000
    SettlingMax = 1.0000
    Overshoot = 0
    Undershoot = 0
    Peak = 1.0000
    PeakTime = 6
    StaticGain = 1
    InitialJump = 0

>> stepinfo(H6) # tentativa de aproximação
ans =

  scalar structure containing the fields:

    RaiseTime = [](0x0)
    RiseTime = 0.7325
    TransientTime = 1.3046
    SettlingTime = 1.3046
    SettlingMin = 0.9000
    SettlingMax = 1.0000
    Overshoot = 0
    Undershoot = 0
    Peak = 1.0000
    PeakTime = 6
    StaticGain = 1
    InitialJump = 0

>> save TED2-respostas.mat
>> 
>> H7=tf(1,poly([-8, -2+8i, -2-8i]))

Transfer function 'H7' from input 'u1' to output ...

                  1             
 y1:  --------------------------
      s^3 + 12 s^2 + 100 s + 544

Continuous-time model.
>> H7=tf(544,poly([-8, -2+8i, -2-8i]))

Transfer function 'H7' from input 'u1' to output ...

                 544            
 y1:  --------------------------
      s^3 + 12 s^2 + 100 s + 544

Continuous-time model.
>> den8=poly([-2+8i, -2-8i])
den8 =

    1    4   68

>> H8=tf(68,[1 4 68])

Transfer function 'H8' from input 'u1' to output ...

            68      
 y1:  --------------
      s^2 + 4 s + 68

Continuous-time model.
>> 
>> subplot(122); pzmap(H8); legend off; title('H_8(s)');
>> 
>> close all
>> figure; subplot(122); pzmap(H8); legend off; title('H_8(s)');
>> 
>> figure; subplot(121); pzmap(H8); legend off; title('H_8(s)');
>> 
>> xlim([-9 1])
>> 
>> figure; subplot(121); pzmap(H7); legend off; title('H_7(s)');
>> 
>> xlim([-9 1])
>> xlim([-10 2])
>> subplot(122); pzmap(H8); legend off; title('H_8(s)');
>> xlim([-10 2])
>> print("pzmap_H7_H8.png", "-dpng", "-r150");  % salva figura com resulução melhor
>> print("pzmap_H7_H8.png", "-dpng", "-r150");  % salva figura com resulução melhor
>> 
>> figure; step(H7, H8); legend off
>> xlim([0 4])
>> legend('H_7(s)', 'H_8(s)', 'Location', 'southeast');
>> print("step_H7_H8.png", "-dpng", "-r150");  % salva figura com resulução melhor
>> print("step_H7_H8.png", "-dpng", "-r150");  % salva figura com resulução melhor
>> 
>> save TED2-respostas.mat
>> 
>> 
>> 
>> close all
>> 
>> pole(H7)
ans =

  -8 + 0i
  -2 + 8i
  -2 - 8i

>> pole(H8)
ans =

  -2 + 8i
  -2 - 8i

>> H9=tf(1,poly([-8+8i, -8-8i, -2]))

Transfer function 'H9' from input 'u1' to output ...

                  1             
 y1:  --------------------------
      s^3 + 18 s^2 + 160 s + 256

Continuous-time model.
>> H9=tf(256,poly([-8+8i, -8-8i, -2]))

Transfer function 'H9' from input 'u1' to output ...

                 256            
 y1:  --------------------------
      s^3 + 18 s^2 + 160 s + 256

Continuous-time model.
>> den10=poly([-8+8i, -8-8i])
den10 =

     1    16   128

>> H10=tf(128,[1 16 128])

Transfer function 'H10' from input 'u1' to output ...

            128       
 y1:  ----------------
      s^2 + 16 s + 128

Continuous-time model.
>> dcgain(H10)
ans = 1
>> 
>> figure; subplot(121); pzmap(H9); legend off; title('H_9(s)');
>> 
>> xlim([-10 2])
>> subplot(122); pzmap(H10); legend off; title('H_{10}(s)');
>> xlim([-10 2])
>> 
>> print("pzmap_H9_H10.png", "-dpng", "-r150");  % salva figura com resulução melhor
>> 
>> figure; step(H9, H10); legend off
>> 
>> legend('H_9(s)', 'H_{10}(s)', 'Location', 'southeast');
>> print("step_H9_H10.png", "-dpng", "-r150");  % salva figura com resulução melhor
>> 
>> H11=tf(1,poly([-5, -4-8i, -4+8i]))

Transfer function 'H11' from input 'u1' to output ...

                  1             
 y1:  --------------------------
      s^3 + 13 s^2 + 120 s + 400

Continuous-time model.
>> H11=tf(400,poly([-5, -4-8i, -4+8i]))

Transfer function 'H11' from input 'u1' to output ...

                 400            
 y1:  --------------------------
      s^3 + 13 s^2 + 120 s + 400

Continuous-time model.
>> den12=poly([-4+8i, -4-8i])
den12 =

    1    8   80

>> H12=tf(80,[1 8 80])

Transfer function 'H12' from input 'u1' to output ...

            80      
 y1:  --------------
      s^2 + 8 s + 80

Continuous-time model.
>> dcgain(H12)
ans = 1
>> 
>> save TED2-respostas.mat
>> 
>> figure; subplot(121); pzmap(H11); legend off; title('H_{11}(s)');
>> xlim([-10 2])
>> 
>> subplot(122); pzmap(H12); legend off; title('H_{12}(s)');
>> xlim([-10 2])
>> 
>> print("pzmap_H11_H12.png", "-dpng", "-r150");  % salva figura com resulução melhor
>> 
>> figure; step(H11, H12); legend off
>> 
>> xlim([0 2])
>> legend('H_{11}(s)', 'H_{12}(s)', 'Location', 'southeast');
>> print("step_H11_H12.png", "-dpng", "-r150");  % salva figura com resulução melhor
>> 
>> 
>> save TED2-respostas.mat
>> 
>> H13=tf(1,poly([-2, -4-4i, -4+4i, -8, -10+12i, -10-12i]))

Transfer function 'H13' from input 'u1' to output ...

                                          1                                     
 y1:  --------------------------------------------------------------------------
      s^6 + 38 s^5 + 732 s^4 + 7400 s^3 + 4.07e+04 s^2 + 1.196e+05 s + 1.249e+05

Continuous-time model.
>> [z,p,k]=zpk(H13)
error: zpk: function called with too many outputs
error: called from
    zpk
>> help zpk
warning: help: Texinfo formatting filter exited abnormally; raw Texinfo source of help text follows...
'zpk' is a function from the file /Users/fernandopassold/Library/Application Support/Octave.app/9.2/pkg/control-4.2.3/zpk.m



Additional help for built-in functions and operators is
available in the online version of the manual.  Use the command
'doc <topic>' to search the manual index.

Help and information about Octave is also available on the WWW
at https://www.octave.org and via the help@octave.org
mailing list.
>> 1/dcgain(H13)
ans = 124928
>> doc zpk
>> 
>> 
>> pole(H13)
ans =

  -10 + 12i
  -10 - 12i
   -8 +  0i
   -4 +  4i
   -4 -  4i
   -2 +  0i

>> H14=tf(1,poly([[-2, -4-4i, -4+4i]))
error: parse error:

  syntax error

>>> H14=tf(1,poly([[-2, -4-4i, -4+4i]))
                                     ^
>> H14=tf(1,poly([-2, -4-4i, -4+4i]))

Transfer function 'H14' from input 'u1' to output ...

                 1            
 y1:  ------------------------
      s^3 + 10 s^2 + 48 s + 64

Continuous-time model.
>> H14=tf(64,poly([-2, -4-4i, -4+4i]))

Transfer function 'H14' from input 'u1' to output ...

                 64           
 y1:  ------------------------
      s^3 + 10 s^2 + 48 s + 64

Continuous-time model.
>> dcgain(H14)
ans = 1
>> 
>> save TED2-respostas.mat
>> 
>> subplot(122); pzmap(H13); legend off; title('H_{13}(s)');
>> 
>> figure; subplot(122); pzmap(H13); legend off; title('H_{13}(s)');
>> 
>> figure; subplot(121); pzmap(H13); legend off; title('H_{13}(s)');
>> 
>> 
>> 
>> 
>> 
>> subplot(122); pzmap(H14); legend off; title('H_{14}(s)');
>> xlim([-14 2])
>> subplot(121)
>> xlim([-14 2])
>> 
>> grid minor
>> 
>> subplot(122)
>> grid minor
>> 
>> print("pzmap_H13_H14.png", "-dpng", "-r150");  % salva figura com resulução melhor
>> 
>> 
>> 
>> ylim([-14 14])
>> subplot(121)
>> ylim([-14 14])
>> ylim([-15 15])
>> subplot(122)
>> ylim([-15 15])
>> print("pzmap_H13_H14.png", "-dpng", "-r150");  % salva figura com resulução melhor
>> 
>> figure; step(H13, H14); legend off
>> H14

Transfer function 'H14' from input 'u1' to output ...

                 64           
 y1:  ------------------------
      s^3 + 10 s^2 + 48 s + 64

Continuous-time model.
>> pole(H14)
ans =

  -4 + 4i
  -4 - 4i
  -2 + 0i

>> pole(H13)
ans =

  -10 + 12i
  -10 - 12i
   -8 +  0i
   -4 +  4i
   -4 -  4i
   -2 +  0i

>> figure; step(H13, H14); legend off
>> 
>> figure; step(H13); legend off
>> hold on;
>> step(H14); legend off
>> dcgain(H14)
ans = 1
>> dcgain(H13)
ans = 8.0046e-06
>> H13

Transfer function 'H13' from input 'u1' to output ...

                                          1                                     
 y1:  --------------------------------------------------------------------------
      s^6 + 38 s^5 + 732 s^4 + 7400 s^3 + 4.07e+04 s^2 + 1.196e+05 s + 1.249e+05

Continuous-time model.
>> H13=tf(124928,poly([-2, -4-4i, -4+4i, -8, -10+12i, -10-12i]))

Transfer function 'H13' from input 'u1' to output ...

                                      1.249e+05                                 
 y1:  --------------------------------------------------------------------------
      s^6 + 38 s^5 + 732 s^4 + 7400 s^3 + 4.07e+04 s^2 + 1.196e+05 s + 1.249e+05

Continuous-time model.
>> dcgain(H13)
ans = 1
>> 
>> figure; step(H13, H14); legend off
>> stepinfo(H13)
ans =

  scalar structure containing the fields:

    RaiseTime = [](0x0)
    RiseTime = 1.1550
    TransientTime = 2.4165
    SettlingTime = 2.4165
    SettlingMin = 0.9000
    SettlingMax = 1.0000
    Overshoot = 0
    Undershoot = 0
    Peak = 1.0000
    PeakTime = 8.9900
    StaticGain = 1
    InitialJump = 0

>> stepinfo(H14)
ans =

  scalar structure containing the fields:

    RaiseTime = [](0x0)
    RiseTime = 1.1101
    TransientTime = 2.1937
    SettlingTime = 2.1937
    SettlingMin = 0.9000
    SettlingMax = 1.0000
    Overshoot = 0
    Undershoot = 0
    Peak = 1.0000
    PeakTime = 8.9725
    StaticGain = 1
    InitialJump = 0

>> legend('H_{13}(s)', 'H_{14}(s)', 'Location', 'southeast');
>> print("step_H13_H14.png", "-dpng", "-r150");  % salva figura com resulução melhor
>> 
>> xlim([0 4])
>> xlim([0 3])
>> print("step_H13_H14.png", "-dpng", "-r150");  % salva figura com resulução melhor
>> 
>> save TED2-respostas.mat
>> 
>> 
>> save TED2-respostas.mat
>> 
>> diary off
