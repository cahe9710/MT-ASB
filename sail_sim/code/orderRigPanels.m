function [panels] = orderRigPanels(wing, flap)
Nz = wing.Nz;
Nxwing = wing.Nx;
Nxflap = flap.Nx;


for iz = 1:Nz
    ipanel = 0;
    for ix = 1:Nxwing
        ipanel = ipanel+1;
        panels(ipanel,iz).nw=wing.panels(ix,iz).nw;
        panels(ipanel,iz).ne=wing.panels(ix,iz).ne;
        panels(ipanel,iz).sw=wing.panels(ix,iz).sw;
        panels(ipanel,iz).se=wing.panels(ix,iz).se;
    end
    for ix = 1:Nxflap
        ipanel = ipanel+1;
        panels(ipanel,iz).nw=flap.panels(ix,iz).nw;
        panels(ipanel,iz).ne=flap.panels(ix,iz).ne;
        panels(ipanel,iz).sw=flap.panels(ix,iz).sw;
        panels(ipanel,iz).se=flap.panels(ix,iz).se;
    end
end
