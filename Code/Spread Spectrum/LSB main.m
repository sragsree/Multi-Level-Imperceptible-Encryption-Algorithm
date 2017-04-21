function [Stego,Stego2, Extracted] = LSBHide(Cover, Hidden, n)
%LSBHide
% [Stego, Extracted] = LSBHide(Cover, Hidden, n)
% Hide Hidden in the n least significant bits of Cover

Stego = uint8(bitor(bitand(Cover, bitcmp(2^n - 1, 8)) , bitshift(Hidden, n - 8)));
x=bitand(Cover, bitcmp(2^n - 1, 16))
y=bitshift(Hidden, n - 8)
Stego2 = uint16(bitor(bitand(Cover, bitcmp(2^n - 1, 16)) , bitshift(Hidden, n - 8)));
Extracted = uint16(bitand(65535, bitshift(Stego2, 8 - n)));
