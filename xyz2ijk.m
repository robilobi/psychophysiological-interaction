% converts world-to-voxel coordinates.
%
% Inputs:
%   xyz   [1x3 vector] is world-coordinates (e.g. MNI-coord)
%   nii   the nii structure read using load_nii.m
% Output:
%   ijk   [1x3 vector] is 1-based voxel coordinates for MATLAB
%
% (cc) sgKIM, 2014. solleo@gmail.com

function ijk = xyz2ijk(xyz, nii)

T=[nii.hdr.hist.srow_x; nii.hdr.hist.srow_y; nii.hdr.hist.srow_z; 0 0 0 1];
ijk = inv(T) * [xyz 1]';
ijk(4)=[];
ijk = ijk+1;

end