function H = imageorth(vol, cfg)
% H = imageorth(vol, cfg)
% shows orthgonal slices of a given volume
%
% *default:
%  cfg.position=[50 800 1200 800];
%  cfg.color='k';
%  cfg.marker='+g';
%  cfg.xyz=round(mean(find3(vol)));
%  cfg.colormap=bone(256);
%  cfg.mask=~~vol;
%  cfg.colorbar=0; subplot index 1,2, or 3
%  cfg.caxis=[min(vol(:)), max(vol(:))];
%
% (cc)sgKIM, 2011, 2012.
% solleo@gmail.com


if nargin<2
    cfg=[];
end

if ~isfield(cfg,'color')
    cfg.color='k';
end

if ~isfield(cfg,'marker')
    cfg.marker='+g';
end

if isfield(cfg,'ijk')
  cfg.xyz=cfg.ijk;
end

if ~isfield(cfg,'xyz')
    cfg.xyz=round(mean(find3(vol)));
    if isnan(cfg.xyz)
        error('Given image contains only zeros!');
    end
end

if ~isfield(cfg,'mask')
    cfg.mask=~~vol;
end

if ~isfield(cfg,'colormap')
    cfg.colormap=bone(256);
end

if ~isfield(cfg,'colorbar')
    cfg.colorbar=0;
end

vol = double(vol);
d=size(vol);
if ~isfield(cfg,'caxis') || isempty(cfg.caxis)
    cfg.caxis=[min(vol(:)), max(vol(:))];
end
vol(vol<cfg.caxis(1)) = cfg.caxis(1);
vol(vol>cfg.caxis(2)) = cfg.caxis(2);
vol = reshape(vol, d);

xyz=cfg.xyz;

clf,set(gcf,'color',cfg.color,'colormap',cfg.colormap)
if isfield(cfg,'position')
    set(gcf,'position',cfg.position)
end

%%
H(1)=axes('position',[.0 .5 .5 .5]);
slice = squeeze( vol (:,:,xyz(3)))';
mask_slice = squeeze( cfg.mask (:,:,xyz(3)))';
imagesc(slice.*mask_slice),set(gca,'ydir','normal')
if ~isempty(cfg.marker)
    hold on,scatter(xyz(1), xyz(2), cfg.marker),hold off
end
text(5,d(2)-20,['k=',num2str(xyz(3))],'fontsize',15,'color','w')
text(d(1)-20,d(2)-20,'R','fontsize',20,'color','w')
% xlabel('x: left to RIGHT','fontsize',12)
% ylabel('y: posterior to ANTERIOR','fontsize',12)
axis tight, axis off; axis image
%daspect([cfg.daspect(1), cfg.daspect(2) cfg.daspect(3)]);
caxis(cfg.caxis)
if cfg.colorbar==1
    colorbar;
end
%%
H(2)=axes('position',[.5 .5 .5 .5]);
slice = squeeze(vol (xyz(1),:,:))';
mask_slice = squeeze( cfg.mask (xyz(1),:,:))';
imagesc(slice.*mask_slice),set(gca,'ydir','normal')
if ~isempty(cfg.marker)
    hold on,scatter(xyz(2), xyz(3), cfg.marker),hold off
end
%title(['x=',num2str(xyz(1))],'fontsize',20)
text(5,d(3)-20,['i=',num2str(xyz(1))],'fontsize',15,'color','w')
% xlabel('y: posterior to ANTERIOR','fontsize',12)
% ylabel('z: inferior to SUPERIOR','fontsize',12)
axis tight, axis off; axis image
%daspect([cfg.daspect(3), cfg.daspect(2) cfg.daspect(1)]);
caxis(cfg.caxis)
if cfg.colorbar==2
    colorbar;
end
%%
H(3)=axes('position',[.0 .0 .5 .5]);
slice = squeeze(vol (:,xyz(2),:))';
mask_slice = squeeze( cfg.mask (:,xyz(2),:))';
imagesc(slice.*mask_slice),set(gca,'ydir','normal')
if ~isempty(cfg.marker)
    hold on,scatter(xyz(1), xyz(3), cfg.marker),hold off
end
%title(['y=',num2str(xyz(2))],'fontsize',20)
text(5,d(3)-20,['j=',num2str(xyz(2))],'fontsize',15,'color','w')
%text(d(1)-20,d(2)-20,'R','fontsize',20,'color','w')
% xlabel('x: L -> R','fontsize',12)
% ylabel('z: I -> S','fontsize',12)
axis tight, axis off; axis image
%daspect([cfg.daspect(3), cfg.daspect(1) cfg.daspect(2)]);
caxis(cfg.caxis)
if cfg.colorbar==3
    colorbar;
end
%%
H(4)=axes('position',[.55 .05 .4 .4]);
[N,X]=hist(double(vol(cfg.mask)), size(cfg.colormap,1));

h_bar=bar(X,N,'facecolor',[.5 .5 1]);
if isfield(cfg,'title')
    title(cfg.title,'color','w','fontsize',15)
end
set(gca,'xcolor','w','ycolor','w','zcolor','w','color','w')

set(gcf,'colormap',cfg.colormap)
end


function xyz = find3(X,value)
% returns [x, y, z] coordiantes in the given 3D volume.
% If the value is not specified, the coordinates of any non-zero values
% will be returned.
%
% sgKIM, 2011 (cc)

if nargin < 2
    vec = find (X);
else
    vec = find (X == value);
end
 
z = ceil(vec/(size(X,1)*size(X,2)));
y = ceil((vec-((z-1)*(size(X,1)*size(X,2)))) / size(X,1));
%x = mod (vec-((z-1)*(size(X,1)*size(X,2))), size(X,1));
x = vec - ((y-1)*size(X,1) + (z-1)*size(X,1)*size(X,2));
xyz = [x, y, z];
end
