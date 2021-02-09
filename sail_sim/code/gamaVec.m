function g = gamaVec(sails)
k = 0;
for is = 1:length(sails)
    for ix = 1:sails(is).Nx
        for iz = 1:sails(is).Nz
            k = k + 1;
            g(k) = sails(is).lattice(ix,iz).g;
        end
    end
end