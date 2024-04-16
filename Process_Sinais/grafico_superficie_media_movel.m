% Gráfico de superfície de H(z)
% no caso para um filtro de media móvel de 2 passos
% y[n] = 0,5 \, x[n] +0,5 \, x[n-1]
% H(z)=\dfrac{0,5\,z + 0,5}{z}

z_real_vals = [-2:0.02:2];
z_imag_vals = [-2:0.02:2];
for m = 1: length(z_real_vals)
    for n = 1: length(z_imag_vals)
        z = z_real_vals(m)+z_imag_vals(n)*j;
        H_z(n,m) = (0.5*z + 0.5)/z;
    end
end
mesh (z_real_vals, z_imag_vals, 20*log10(abs(H_z)))
xlabel('Re\{z\}')
ylabel('Im\{z\}')
zlabel('|H(z)|')