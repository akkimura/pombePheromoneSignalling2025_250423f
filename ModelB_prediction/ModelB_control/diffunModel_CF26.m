% diffunModel_CF26.m
% made on Jan 28, 2022, based on diffunModel_CD27.m 
% remove s(27): Cddc42->ppSpk1
% see 220122RunFitting.xlsx
% 26 parameters

function dydt = diffunModel_CF26(~,y,r)
dydt = zeros(32,1);

s=r;

dydt(32) = 1; %y(32)=time
dydt(31) = (1/ pi) * (1/(1+((y(32) - (100+s(24)))/s(25))^2)) * (1/s(25)); % change in nitrogen state from zero to 1 at time=100 

%WT
dydt(1) = s(1)*y(31) + s(2)*(y(7)/s(12)) - s(3)*y(1); %Ste11 in WT
dydt(2) = s(4)*y(1) - s(5)*(1 + s(6)*(y(7)/s(12)))*y(2); %active Ste4/Ste6 in WT
dydt(3) = s(7)*y(2)*(1-y(3)) - s(8)*y(3); %active Ras in WT
dydt(4) = s(19)*(s(9)*y(3)*(1-y(4)/s(19)) - s(10)*(1+s(11)*(1-y(31)))*y(4)/s(19)); %active Cdc42 in WT. +Cdc42GAP (210610)
dydt(5) = s(13)*y(2)*(1+s(14)*y(3)+s(15)*y(4)/s(19))*(1-y(5))-s(16)*(1+s(26)*(1-y(31)))*y(5); %phospho-Byr1 in WT
dydt(6) = s(17)*y(1) - s(18)*y(6); % total Spk1 in WT
dydt(7) = s(20)*y(5)*(y(6)-(y(7)/s(12))) - s(21)*(y(7)/s(12)); % phospho-Spk1 in WT 

%ras1.G17V
dydt(8) = s(1)*y(31) + s(2)*(y(13)/s(12)) - s(3)*y(8); %Ste11 in ras1.G17V
dydt(9) = s(4)*y(8) - s(5)*(1+s(6)*(y(13)/s(12)))*y(9); %active Ste4/Ste6 in ras1.G17V
%s(22); %active Ras in ras1.G17V
dydt(10) = s(19)*(s(9)*s(22)*(1-y(10)/s(19)) - s(10)*(1+s(11)*(1-y(31)))*y(10)/s(19)); %active Cdc42 in ras1.G17V. +Cdc42GAP
dydt(11) = s(13)*y(9)*(1+s(14)*s(22)+s(15)*y(10)/s(19))*(1-y(11))-s(16)*(1+s(26)*(1-y(31)))*y(11); %phospho-Byr1 in ras1.G17V 
dydt(12) = s(17)*y(8) - s(18)*y(12); % total Spk1 in ras1.G17V
dydt(13) = s(20)*y(11)*(y(12)-(y(13)/s(12))) - s(21)*(y(13)/s(12)); % phospho-Spk1 in ras1.G17V 

%byr1.DD
dydt(14) = s(1)*y(31) + s(2)*(y(19)/s(12)) - s(3)*y(14); %Ste11 in byr1.DD
dydt(15) = s(4)*y(14) - s(5)*(1+s(6)*(y(19)/s(12)))*y(15); %active Ste4/Ste6 in byr1.DD
dydt(16) = s(7)*y(15)*(1-y(16)) - s(8)*y(16); %active Ras in byr1.DD
dydt(17) = s(19)*(s(9)*y(16)*(1-y(17)/s(19)) - s(10)*(1+s(11)*(1-y(31)))*y(17)/s(19)); %active Cdc42 in byr1.DD. +Cdc42GAP
%s(23); %phospho-Byr1 in byr1.DD
dydt(18) = s(17)*y(14) - s(18)*y(18); % total Spk1 in byr1.DD
dydt(19) = s(20)*s(23)*(y(18)-(y(19)/s(12))) - s(21)*(y(19)/s(12)); % phospho-Spk1 in byr1.DD 

%ras1.G17V+byr1.DD
dydt(20) = s(1)*y(31) + s(2)*(y(24)/s(12)) - s(3)*y(20); %Ste11 in ras1.G17V+byr1.DD
dydt(21) = s(4)*y(20) - s(5)*(1+s(6)*(y(24)/s(12)))*y(21); %active Ste4/Ste6 in ras1.G17V+byr1.DD
%s(22); %active Ras in ras1.G17V+byr1.DD
dydt(22) = s(19)*(s(9)*s(22)*(1-y(22)/s(19)) - s(10)*(1+s(11)*(1-y(31)))*y(22)/s(19)); %active Cdc42 in ras1.G17V+byr1.DD. +Cd
%s(23); %phospho-Byr1 in byr1.DD
dydt(23) = s(17)*y(20) - s(18)*y(23); % total Spk1 in ras1.G17V+byr1.DD
dydt(24) = s(20)*s(23)*(y(23)-(y(24)/s(12))) - s(21)*(y(24)/s(12)); % phospho-Spk1 in ras1.G17V+byr1.DD, new 210402a

%scd1-Delta
dydt(25) = s(1)*y(31) + s(2)*(y(30)/s(12)) - s(3)*y(25); %Ste11 in scd1-Delta
dydt(26) = s(4)*y(25) - s(5)*(1 + s(6)*(y(30)/s(12)))*y(26); %active Ste4/Ste6 in scd1-Delta
dydt(27) = s(7)*y(26)*(1-y(27)) - s(8)*y(27); %active Ras in scd1-Delta
% 0; % Cdc42 in scd1-Delta
dydt(28) = s(13)*y(26)*(1+s(14)*y(27))*(1-y(28))-s(16)*(1+s(26)*(1-y(31)))*y(28); %phospho-Byr1 in scd1-Delta
dydt(29) = s(17)*y(25) - s(18)*y(29); % total Spk1 in scd1-Delta
dydt(30) = s(20)*y(28)*(y(29)-(y(30)/s(12))) - s(21)*(y(30)/s(12)); % phospho-Spk1 in scd1-Delta 

end