function beepbeep
res = 22050;
len = 0.5 * res;
hz = 220;
sound( sin( hz*(2*pi*(0:len)/res) ), res);
end