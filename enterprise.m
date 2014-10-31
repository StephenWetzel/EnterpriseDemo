%Starship Enterprise
%Stephen Wetzel

clc;
clear all;
close all;

%http://en.memory-alpha.org/wiki/USS_Enterprise_(NCC-1701)
figure;

xMax = 120; %size of the plot
yMax =  40;
zMax =  50;
pauseTime = 0.05; %animation pause time

myAxes = axes('xlim', [-5 xMax], 'ylim', [-10 yMax], 'zlim', [-10 zMax]);
view(3) %3d plot
axis equal; %set axes to equal scales
xlabel('x');
ylabel('y');
zlabel('z');

%ship objects:
%nacelles are the long warp engine parts
nacelleDistance =  5; %distance from xz plane
nacelleHeight   =  5; %height above hull center (xy plane)
nacelleLength   = 10;
nacelleRadius   =  1;
nacelleShift    =  5; %shift to rear of ship
hullRadius      =  2; %lower main body
hullLength      = 10;
saucerRadius    =  6; %upper circular part
saucerThickness =  1;
saucerShift     = 16; %shift to front of ship
bridgeRadius    =  1; %bubble on top of saucer

%background objects:
starRadius      =  0.1;
moonRadius      =  7;
numStars        = 50; %this number is actually * 5

%here we define the x, y, z coordinates of base shapes:
[xNacelle, yNacelle, zNacelle] = cylinder(nacelleRadius);
zNacelle(2, :) = nacelleLength; %scale the cylinder up to proper length

[xBussard, yBussard, zBussard] = sphere; %red tips on warp engines

[xHull, yHull, zHull] = cylinder(hullRadius);
zHull(2, :) = hullLength;

[xSaucer, ySaucer, zSaucer] = cylinder(saucerRadius);
zSaucer(2, :) = saucerThickness;

[xDeflector, yDeflector, zDeflector] = sphere; %dish on front of hull
%take about half of the sphere to form a dish shape:
xDeflector =  xDeflector(9:end,:)*hullRadius;
yDeflector =  yDeflector(9:end,:)*hullRadius;
zDeflector = -zDeflector(9:end,:)*hullRadius; %negative to flip it around

[xBridge, yBridge, zBridge] = sphere;
xBridge = xBridge*hullRadius;
yBridge = yBridge*hullRadius;
zBridge = zBridge*hullRadius;


%These are manually made parallelepipeds.
%in each case we set the bottom 4+1 points first, then duplicate it for the
%upper layer, optionally applying a shift in the upper layer.

%connection from nacelle to hull:
xNacelleConnection = [0 2 2 0 0];
xNacelleConnection = [xNacelleConnection; xNacelleConnection];

yNacelleConnection = [0 0 1 1 0];
yNacelleConnection = [yNacelleConnection; yNacelleConnection - nacelleDistance];

zNacelleConnection = [0 0 0 0 0];
zNacelleConnection = [zNacelleConnection; zNacelleConnection + nacelleHeight];

%connection from hull to saucer:
xHullConnection = [0 3 3 0 0];
xHullConnection = [xHullConnection; xHullConnection+(saucerShift-hullLength)];

yHullConnection = [-.5 -.5 .5 .5 -.5];
yHullConnection = [yHullConnection; yHullConnection];

zHullConnection = [0 0 0 0 0];
zHullConnection = [zHullConnection; zHullConnection + nacelleHeight];


%background objects:
[xStar, yStar, zStar] = sphere;
xStar = xStar * starRadius;
yStar = yStar * starRadius;
zStar = zStar * starRadius;

[xMoon, yMoon, zMoon] = sphere;
xMoon = (xMoon * -moonRadius);
yMoon = (yMoon * moonRadius);
zMoon = (zMoon * moonRadius);


%this draws the shapes, as well as stores them for reference later:
shape(1)  = surface(zNacelle-nacelleShift, yNacelle+nacelleDistance, xNacelle+nacelleHeight); %base nacelle tubes, left
shape(2)  = surface(zNacelle-nacelleShift, yNacelle-nacelleDistance, xNacelle+nacelleHeight); %right

shape(3)  = surface(zBussard-nacelleShift+nacelleLength, yBussard-nacelleDistance, xBussard+nacelleHeight); %red tips, left
shape(4)  = surface(zBussard-nacelleShift+nacelleLength, yBussard+nacelleDistance, xBussard+nacelleHeight); %right

shape(5)  = patch(zNacelle(1,:)-nacelleShift, yNacelle(1,:)+nacelleDistance, xNacelle(1,:)+nacelleHeight, xNacelle(1,:)); %blue rear
shape(6)  = patch(zNacelle(1,:)-nacelleShift, yNacelle(1,:)-nacelleDistance, xNacelle(1,:)+nacelleHeight, xNacelle(1,:));

shape(7)  = surface(zHull, yHull, xHull); %main lower hull

shape(8)  = surface(xSaucer+saucerShift, ySaucer, zSaucer+nacelleHeight); %upper circular part
shape(9)  = patch(xSaucer(1, :)+saucerShift, ySaucer(1, :), zSaucer(1, :)+nacelleHeight, zSaucer(1, :)); %flat bottom of saucer
shape(10) = patch(xSaucer(1, :)+saucerShift, ySaucer(1, :), zSaucer(1, :)+nacelleHeight+saucerThickness, zSaucer(1, :)); %flat top of saucer

shape(11) = surface(zDeflector+hullLength+1, yDeflector, xDeflector); %front dish
shape(12) = patch(zHull(1,:), yHull(1,:), xHull(1,:), xHull(1,:)); %back of hull

shape(13) = surface(xBridge+saucerShift, yBridge, zBridge+nacelleHeight+1); %bridge, bubble on top of saucer

shape(14) = surface(xNacelleConnection+1, yNacelleConnection, zNacelleConnection); %the connectors from nacelles to hull
shape(15) = surface(xNacelleConnection+1, -yNacelleConnection, zNacelleConnection);
shape(16) = surface(xHullConnection+hullLength-5, yHullConnection, zHullConnection); %connector from hull to saucer


for ii = 1:numStars %add some white dots as stars
    %add them on the rear, bottom and right of axes so the ship doesn't fly
    %behind them
    stars(ii)            = surface(xStar+rand(1)*xMax, yStar + yMax,                zStar+rand(1)*zMax); %rear
    stars(ii+numStars)   = surface(xStar+rand(1)*xMax, yStar + yMax,                zStar+rand(1)*zMax-10); %rear
    stars(ii+2*numStars) = surface(xStar+rand(1)*xMax, yStar+rand(1)*yMax - 20,     zStar); %bottom
    stars(ii+3*numStars) = surface(xStar+rand(1)*xMax, yStar+rand(1)*yMax - 10,     zStar); %bottom
    stars(ii+4*numStars) = surface(xStar+xMax,         yStar + yStar+rand(1)*yMax,  zStar+rand(1)*zMax); %right
end

%the two moons to avoid, different sizes and locations:
moon(1) = surface((xMoon*1.2+rand(21))+110, (yMoon*1.1+rand(21)), (zMoon*1.3+rand(21))+10);
moon(2) = surface((xMoon*0.97+rand(21))-10, (yMoon*0.93+rand(21))+20, (zMoon*0.9+rand(21))+10);


%lighting and coloring:
shading interp; %pretty blending of shape colors
light('Position',[1 1 50],'Style','infinite'); %add a light source, top foreground

set(shape, 'FaceColor', [.9, .9, .9]); %color of ship, gray
set(shape, 'EdgeColor', 'none'); %no lines
set(gca, 'Color', 'k'); %axes background color
%set(gcf, 'Color', 'k'); %background color
set(stars, 'FaceColor', [1, 1, 1]); %color of stars
set(stars, 'EdgeColor', 'none'); %no lines
set(stars, 'AmbientStrength', 1); %no reflections on stars
set(moon(1), 'FaceColor', [.4,.2,.1]); %brown moon
set(moon(2), 'FaceColor', [.6,.1,.1]); %red moon
set(moon, 'FaceLighting', 'gouraud'); %smooth out edges
set(shape, 'FaceLighting', 'gouraud');

set(shape(3), 'FaceColor', [1,0,0]); %red bussard collectors
set(shape(4), 'FaceColor', [1,0,0]);

set(shape(11), 'FaceColor', [.4,0,0]); %deflector
set(shape(5), 'FaceColor', [.2,0,.8]); %rear engines
set(shape(6), 'FaceColor', [.2,0,1]); %rear engines


%we combine all the ship parts into one object, 
combinedObject = hgtransform('parent', myAxes);
set(shape, 'parent', combinedObject);


%the animation will have the following phases:
% 1. barrel roll
% 2. turn left to avoid moon (yaw)
% 3. pitch up to avoid second moon
% 4. half roll to correct orientation

%each of these numbers willl represent some change in the phases of
%animation.  They are relative to each other, so changing just the first
%should change the rest.
rollStart = 5; %do a barrel roll
rollEnd = rollStart + 36;

turnStart = rollEnd + 30; %turn left to avoid moon (yaw)
turnEnd = turnStart + 37;

pitchStart = turnEnd + 40; %pitch up to avoid second moon
pitchEnd = pitchStart + 37;

roll2Start = pitchEnd + 10; %half roll to correct orientation
roll2End = roll2Start + 37;

steps = roll2End + 10; %steps is the total numbers of steps, or the end of 
%the animation.

%set all of these to defaults
scale(1:steps)  = 1;
xRot(1:steps)   = 0; %rotation about the x axis
yRot(1:steps)   = 0; %rotation about the y axis
zRot(1:steps)   = 0; %rotation about the z axis


%these loops create the animation plan:
for ii = rollStart:rollEnd
    xRot(ii) = (ii-rollStart)*10;
end

for ii = turnStart:turnEnd
    zRot(ii) = (ii-turnStart)*5;
end

for ii = turnEnd:steps
    zRot(ii) = 180;
end

for ii = pitchStart:pitchEnd
    yRot(ii) = (ii-pitchStart)*5;
end
for ii = pitchEnd:steps
    yRot(ii) = 180;
end

for ii = roll2Start:roll2End
    xRot(ii) = (ii-roll2Start)*5;
end
for ii = roll2End:steps
    xRot(ii) = 180;
end

xTrans = 0;
yTrans = 0;
zTrans = 0;
for ii = 1:steps %do the actual animation
    xTrans = xTrans + cosd(yRot(ii)) * cosd(zRot(ii));
    yTrans = yTrans + sind(zRot(ii));
    zTrans = zTrans + sind(yRot(ii));
    
    translation = makehgtform('translate', [xTrans, yTrans, zTrans]);
    xRotation   = makehgtform('xrotate', (pi/180) * xRot(ii)); %Do a barrel roll
    yRotation   = makehgtform('yrotate', (pi/180) * yRot(ii)); %up and down pitch
    zRotation   = makehgtform('zrotate', (pi/180) * zRot(ii)); %left and right yaw
    scaling     = makehgtform('scale', scale(ii));
    
    set(combinedObject, 'matrix', translation * xRotation * yRotation * zRotation * scaling);
    
    pause(pauseTime);
end



