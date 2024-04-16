# Algoritmos similares à função `filter()` do Matlab

Ref.: https://rosettacode.org/wiki/Apply_a_digital_filter_(direct_form_II_transposed)#Python

```bash
fernandopassold@MacBook-Pro-de-Fernando Signal_Pros % pwd  
/Volumes/DADOS/Users/fpassold/Documents/UPF/Process_Sinais/Signal_Pros
fernandopassold@MacBook-Pro-de-Fernando Signal_Pros % ls filter*
filterSignal		filterSignal.c		filterSignal.py		filterSignal.rb		filterSignal.ruby
fernandopassold@MacBook-Pro-de-Fernando Signal_Pros % gcc filterSignal.c -o filterSignal
fernandopassold@MacBook-Pro-de-Fernando Signal_Pros % ./filterSignal 
Usage : ./filterSignal <name of signal data file>  [<optional output file>]
File example: signalData.txt
fernandopassold@MacBook-Pro-de-Fernando Signal_Pros % ./filterSignal signalData.txt
Filtered signal is:
[-0.152973994613, -0.435257852077, -0.136043429375, 0.697503328323, 0.656444668770, -0.435482501984, -1.089239478111, -0.537676513195, 0.517050027847, 1.052249789238, 0.961854338646, 0.695689916611, 0.424356251955, 0.196262300014, -0.027835100889, -0.211721956730, -0.174745574594, 0.069258421659, 0.385445863008, 0.651770770550]
fernandopassold@MacBook-Pro-de-Fernando Signal_Pros % ruby filterSignal.rb
-0.15297399, -0.43525783, -0.13604340,  0.69750333,  0.65644469
-0.43548245, -1.08923946, -0.53767655,  0.51704999,  1.05224975
 0.96185430,  0.69569009,  0.42435630,  0.19626223, -0.02783512
-0.21172192, -0.17474556,  0.06925841,  0.38544587,  0.65177084
fernandopassold@MacBook-Pro-de-Fernando Signal_Pros % python3 filterSignal.py
Traceback (most recent call last):
  File "/Volumes/DADOS/Users/fpassold/Documents/UPF/Process_Sinais/Signal_Pros/filterSignal.py", line 6, in <module>
    from scipy import signal
ModuleNotFoundError: No module named 'scipy'
fernandopassold@MacBook-Pro-de-Fernando Signal_Pros % 
```

---

Fernando Passold, em 30/03/2024