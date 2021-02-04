function x = complementaryFilter(x_old,x, k)

x = x_old*(k-1) + k*x;



