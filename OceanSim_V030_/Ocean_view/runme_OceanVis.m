function runme_OceanVis(truth_,rigs)
f=figure(911);clf
%set(f,'visible','off','position',[0 0 1000 800]);
%set(f,'visible','off','position',[0 0 500 500]);
h        = uicontrol('style','slider','units','normalized','position',[0.05 0 0.90 0.05],'value',1,'min',1,'max',length(truth_),'callback',@myCallback,'SliderStep', [1, 60]/length(truth_));
inforuta = uicontrol('style','text','units','normalized','position',[0.05 0.95 0.95 0.05],'visible','on');
hsttext  = uicontrol('style','text','position',[10 45 60 15],'visible','on');
%axes('units','pixels','position',[0 70 950 750]);
axes('units','normalized','position',[0 0.1 1 1]);

%movegui(f,'center'); 
set(f,'visible','on');

[Boat.F.hull,Boat.V.hull]  = rndread('Geometries/Hull.stl');     
[Boat.F.deck,Boat.V.deck]  = rndread('Geometries/Deck.stl');      
[Boat.F.rig, Boat.V.rig]   = rndread('Geometries/Rig_1234.stl');     
[Boat.F.Rig_sections{1}, Boat.V.Rig_sections{1}]   = rndread('Geometries/Rig_section_1.stl');     
[Boat.F.Rig_sections{2}, Boat.V.Rig_sections{2}]   = rndread('Geometries/Rig_section_2.stl');     
[Boat.F.Rig_sections{3}, Boat.V.Rig_sections{3}]   = rndread('Geometries/Rig_section_3.stl');     
[Boat.F.Rig_sections{4}, Boat.V.Rig_sections{4}]   = rndread('Geometries/Rig_section_4.stl');     
 

 truth  = truth_(1);
 roll   = truth_.roll;
 awa    = truth_.awa;
 leeway = truth_.leeway;
 twa    = truth_.twa;
 aws    = truth.aws;
 yaw    = truth.yaw;
 hoists = truth.hoists;
 sheets = truth.sheets;
 sog    = truth.sog;
 rudder = truth.rudder;


 draw_Boat(Boat, sog, roll,awa,aws,twa,leeway,sheets,hoists,rigs,rudder);
 view([-100,20]);
 lightangle(gca,145,30);
 

function myCallback(source,eventdata)
    time =max(1,round(get(h,'value')));
    set(hsttext,'visible','on','string',num2str(time))
    truth  = truth_(time);
    roll   = truth.roll;
    sheets  = truth.sheets;
    awa    = truth.awa;
    aws    = truth.aws;
    twa    = truth.twa;
    leeway = truth.leeway ;
    yaw    = truth.yaw;
    hoists = truth.hoists;
    sog    = truth.sog;
    rudder = truth.rudder;


    [AZ,EL] = view;
    draw_Boat(Boat, sog,roll,awa,aws,twa,leeway,sheets,hoists,rigs,rudder);
    view([AZ,EL]);

    txt =  sprintf('time=%.0fs,   sog=%.2fkn   cog=%.0f°,   tws=%.1fm/s,    twa=%.0f°,    aws=%.1fm/s,    awa=%.0f°,    roll=%.2f°,   yx=[%.0f,%.0f]',...
                    truth.time,ms2kn(truth.sog), rad2deg(truth.cog), truth.tws,rad2deg(truth.twa),truth.aws,rad2deg(truth.awa),rad2deg(truth.roll),truth.y,truth.x);
    set(inforuta,'visible','on','string',txt,'fontsize',12)

    
    %plot(x,y);
    %ax=gca;
end
end