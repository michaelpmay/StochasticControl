function [numSamples]=sanitizeVararginInputs(varargin)
varargin=varargin{1}; %varargin gets wrapped in more and more cells each time so you have to de-shed the outer layer. matlab is so stupid with varargin
if length(varargin)==1
  numSamples=varargin{1};
else
  numSamples=1;
end
end