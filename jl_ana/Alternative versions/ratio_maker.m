%% Ratio_maker 
%%% This is a basic function that returns the ratio of various filters on
%%% a single camera. This allows to try to fit on a single camera without 
%%% having to calculate the number of photons per counts on a camera. 

function [S_ratio]= ratio_maker(S)

S_ratio=[S(1,1)/S(1,2) S(1,1)./S(1,4) S(1,1)/S(1,5)  S(1,2)/S(1,4) S(1,2)./S(1,5)  S(1,4)/S(1,5)  ];

end