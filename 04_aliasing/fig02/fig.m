% circular spectrum of NFCHOA driving function of plane wave

%*****************************************************************************
% Copyright (c) 2019      Fiete Winter                                       *
%                         Institut fuer Nachrichtentechnik                   *
%                         Universitaet Rostock                               *
%                         Richard-Wagner-Strasse 31, 18119 Rostock, Germany  *
%                                                                            *
% This file is part of the supplementary material for Fiete Winter's         *
% PhD thesis                                                                 *
%                                                                            *
% You can redistribute the material and/or modify it  under the terms of the *
% GNU  General  Public  License as published by the Free Software Foundation *
% , either version 3 of the License,  or (at your option) any later version. *
%                                                                            *
% This Material is distributed in the hope that it will be useful, but       *
% WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY *
% or FITNESS FOR A PARTICULAR PURPOSE.                                       *
% See the GNU General Public License for more details.                       *
%                                                                            *
% You should  have received a copy of the GNU General Public License along   *
% with this program. If not, see <http://www.gnu.org/licenses/>.             *
%                                                                            *
% http://github.com/fietew/phd-thesis                 fiete.winter@gmail.com *
%*****************************************************************************

addpath('../../matlab');
SFS_start;

%% Parameters
conf = SFS_config;

conf.secondary_sources.geometry = 'circle';
conf.secondary_sources.center = [0 0 0];
conf.dimension = '2.5D';
conf.xref = [0 0 0]; 

%% Variables
xs = [0,-1, 0];
src = 'pw';
fvec = (50:50:3000).';
fdx = find(fvec == 2500); 
frefdx = find(fvec == 1000);  % for normalisation
L = 56;
rfactor = 8;
Lref = rfactor*L;
R = 1.5;

Dhoa = zeros(length(fvec),Lref);
Dsub = Dhoa;
Phoacirc = Dhoa;
Psubcirc = Dhoa;

X = [-1.5,1.5];
Y = [-1.5,1.5];
Z = 0;

phicirc = (0:Lref-1).'.*2.*pi./Lref;
Rcirc = 1.0;
xcirc = Rcirc*cos(phicirc);
ycirc = Rcirc*sin(phicirc);
zcirc = 0;

%% Computation
% secondary sources
conf.secondary_sources.size = 2*R;
conf.secondary_sources.number = Lref;
x0 = secondary_source_positions(conf);

% driving function for different frequency
for M = [27 300]
  conf.nfchoa.order = M;
  
  % driving signals
  for idx=1:length(fvec)
    Dhoa(idx,:) = driving_function_mono_nfchoa(x0,xs,src,fvec(idx),conf);
  end
  Dsub(:,1:rfactor:end) = rfactor*Dhoa(:,1:rfactor:end);  % subsampling
  
  % discrete CHT of driving function  
  DhoaM = fftshift(1./Lref*fft(Dhoa,[],2),2);
  DsubM = fftshift(1./Lref*fft(Dsub,[],2),2);
  
  % sound fields
  [Phoa,x,y] = sound_field_mono(X,Y,Z,x0,'ps',Dhoa(fdx,:),fvec(fdx),conf);
  Psub = sound_field_mono(X,Y,Z,x0,'ps',Dsub(fdx,:),fvec(fdx),conf);
  
  % discrete CHT of sound fields
  for idx=1:length(fvec)
    Phoacirc(idx,:)  = sound_field_mono(xcirc,ycirc,zcirc,x0,'ps',...
      Dhoa(idx,:),fvec(idx),conf);
    Psubcirc(idx,:)  = sound_field_mono(xcirc,ycirc,zcirc,x0,'ps',...
      Dsub(idx,:),fvec(idx),conf);
  end  
  PhoaM = fftshift(1./Lref*fft(Phoacirc,[],2),2);
  PsubM = fftshift(1./Lref*fft(Psubcirc,[],2),2);
 
  % index
  m = -Lref/2:Lref/2-1;
  mrefdx = find(m == 0);  % for normalisation
  
  % aliasing frequency
  x0S = x0;
  x0S(:,7) = 2.*pi.*R./L;  % sampling distance deltax0

  % local wavenumber of virtual sound field at x0
  kSx0 = local_wavenumber_vector(x0S(:,1:3), xs, src);

  % evaluation points x
  xvec = [x(:), y(:)];
  xvec(:,3) = 0;

  % aliasing frequency at x
  fS = aliasing_modal(x0S, kSx0, xvec, [0,0,0], M, conf);
  fS = reshape(fS, size(x));
  
  % gnuplot
  gp_save_matrix(sprintf('Dhoa_spec_M%d.dat',M),m,fvec,db(DhoaM./DhoaM(frefdx,mrefdx)));
  gp_save_matrix(sprintf('Dsub_spec_M%d.dat',M),m,fvec,db(DsubM./DsubM(frefdx,mrefdx))); 
  gp_save_matrix(sprintf('Phoa_spec_M%d.dat',M),m,fvec,db(PhoaM./PhoaM(frefdx,mrefdx)));
  gp_save_matrix(sprintf('Psub_spec_M%d.dat',M),m,fvec,db(PsubM./PsubM(frefdx,mrefdx))); 
  gp_save_matrix(sprintf('Phoa_M%d.dat',M),x,y,real(Phoa));
  gp_save_matrix(sprintf('Psub_M%d.dat',M),x,y,real(Psub));
  gp_save_matrix(sprintf('fS_M%d.dat',M),x,y,fS);
  gp_save_loudspeakers('array.txt', x0(1:rfactor:end,:));
  
  Rplot = M/(2*pi*fvec(fdx)/conf.c);
  phiplot = (0:360).';
  xplot = Rplot.*[cosd(phiplot), sind(phiplot)];  
  gp_save(sprintf('R_M%d.txt',M), xplot);
  
  gp_save('f.txt', [m; repmat(fvec(fdx),size(m))].');
  
  m_cutoff = min(2*pi*fvec/conf.c*R,M);
  for eta=-1:1        
    gp_save(sprintf('m_cutoff_eta%d_M%d.txt',eta,M), ...
      [fvec, eta*L-m_cutoff, eta*L+m_cutoff]);
  end
  
  gp_save('mmax.txt', [m; repmat(fvec(fdx),size(m))].');
end
