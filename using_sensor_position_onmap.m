clear
close all
load xyz.mat %enter the name of your .mat file here
lat = Position.latitude;
lon = Position.longitude;
spd = Position.speed;

%---START code from MATHWORKS example---
nBins = 10;
binSpacing = (max(spd) - min(spd))/nBins; 
binRanges = min(spd):binSpacing:max(spd)-binSpacing; 

% Add an inf to binRanges to enclose the values above the last bin.
binRanges(end+1) = inf;

% |histc| determines which bin each speed value falls into.
[~, spdBins] = histc(spd, binRanges);

%code from example 2nd section--

lat = lat';
lon = lon';
spdBins = spdBins';

% Create a geographical shape vector, which stores the line segments as
% features.
s = geoshape();

for k = 1:nBins
    
    % Keep only the lat/lon values which match the current bin. Leave the 
    % rest as NaN, which are interpreted as breaks in the line segments.
    latValid = nan(1, length(lat));
    latValid(spdBins==k) = lat(spdBins==k);
    
    lonValid = nan(1, length(lon));
    lonValid(spdBins==k) = lon(spdBins==k);    

    % To make the path continuous despite being segmented into different
    % colors, the lat/lon values that occur after transitioning from the
    % current speed bin to another speed bin will need to be kept.
    transitions = [diff(spdBins) 0];
    insertionInd = find(spdBins==k & transitions~=0) + 1;

    % Preallocate space for and insert the extra lat/lon values.
    latSeg = zeros(1, length(latValid) + length(insertionInd));
    latSeg(insertionInd + (0:length(insertionInd)-1)) = lat(insertionInd);
    latSeg(~latSeg) = latValid;
    
    lonSeg = zeros(1, length(lonValid) + length(insertionInd));
    lonSeg(insertionInd + (0:length(insertionInd)-1)) = lon(insertionInd);
    lonSeg(~lonSeg) = lonValid;

    % Add the lat/lon segments to the geographic shape vector.
    s(k) = geoshape(latSeg, lonSeg);
    
end
%---END code from MATHWORKS example---

wm = webmap('Open Street Map');
initlat = lat(1,1);
initlon = lon(1,1);
finallat = lat(1,end);
finallon = lon(1,end);
namestart = 'start Point';
nameend = 'end point';
wmmarker(initlat, initlon, 'FeatureName', namestart);
wmmarker(finallat, finallon, 'FeatureName', nameend);
colors = copper(nBins);
wmline(s, 'Color', colors, 'Width', 7);

%Supportive figure for the speed-color mapping
binRanges2=binRanges(1,1:10);
binRanges2_kmh=binRanges2*3.6;
y=linspace(1,10,10);
scatter(y,binRanges2_kmh,[],colors,'filled')
xlabel('speed bins and color')
ylabel('speed(km/h)')
