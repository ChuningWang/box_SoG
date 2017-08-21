function b=rd_buoy(fname);
% rd_buoy - reads buoy file in FB format
%fname='c46206_2009.fb';

%     # Administrative Information Record
%
%     	 * FORMAT (2F10.4,F8.1,I4,2I2,I6,F8.1,E12.3,2X,A2,I4,2I3,I4)
%     	 * Latitude, Real F10.4 (degrees), Negative is south latitude
%     	 * Longitude, Real F10.4 (degrees), Negative is east longitude
%     	 * Depth of Water, Real F8.1 (meters)
%     	 * Year of Observation, Integer I4
%     	 * Month of Observation, Integer I2
%     	 * Day of Observation, Integer I2
%     	 * Time of Observation, Integer I5 (HHMM)
%     	 * Observation date and time are recorded in UTC.
%     	 * Length of Recording, Real F8.1 (Minutes)
%     	 * Sampling Frequency, Real E12.3 (Hz)
%     	 * Quality Code (spectra, VCAR & VTPK), 2 character field 2X,A2 - See Table II
%     	 * Number of Additional Parameters, Integer I4
%     	 * Number of Wave Heights, Integer I3
%     	 * Number of Wave Periods, Integer I3
%     	 * Number of Spectral Estimates, Integer I4
%     	 
%     # Additional Parameters Record(s) (Optional)
%
%     	 * FORMAT (5(E12.5,A4))
%     	 * Parameter 1, Real - See Table III for parameters
%     	 * Parameter Code 1, 4 character field
%     	 * Parameter n, Real
%     	 * Parameter Code n, 4 character field
%
%     WAVE HEIGHT CODES
%     lVCAR   Characteristic significant wave height (m)
%     VWH$    Characteristic significant wave height (reported by the buoy) (m)
%     VCMX    Maximum zero crossing wave height (reported by the buoy) (m)
%     SHE1    WES sea height (m)
%     SWHT    Swell height (m)
%     VAV1    Average heave from the non-synoptic part of WRIPS buoy data (m)
%     VCMX    Maximum zero crossing wave height (m)
%     VMNL    Depth of the deepest trough (m)
%     VMXL    Height of the highest crest (m)
%     VMX1    Maximum zero crossing wave height from the non-synoptic part of WRIPS buoy data (m)
%     VST1    Maximum wave steepness
%     WAVE PERIOD CODES
%     VTPK    Wave spectrum peak period (s)
%     VTP$    Wave spectrum peak period (reported by the buoy) (s)
%     SEP1    WES sea period (s)
%     SWPR    Swell period (s)
%     VTD1    Dominant period (s)
%     VTZA    Average zero crossing wave period (s)
%     VZA1    Average zero crossing period from the non-synoptic part of WRIPS buoy data (s)
%     SPECTRAL CODES
%     BAND    Bandwidth of spectral estimates
%     FREQ    Frequency of spectral estimates
%     VCXX    Autospectrum of north-south tilt (C22)
%     VCXY    Cospectrum of north-south and east-west tilt (C23)
%     VCYY    Autospectrum of east-west tilt (C33)
%     VCZX    Cospectrum of heave and north-south tilt (C12)
%     VCZY    Cospectrum of heave and east-west tilt (C13)
%     VQXY    Quadspectrum of north-south and east-west tilt (Q23)
%     VQZX    Quadspectrum of heave and north-south tilt (Q12)
%     VQZY    Quadspectrum of heave and east-west tilt (Q13)
%     VSDN    Spectral density (equivalent to C11)
%     VSMB    The ratio of spectral moments 0 and 1 (m0/m1)
%     METEOROLOGICAL & OCEANOGRAPHIC CODES
%     WDIR    Direction from which the wind is blowing (¡)
%     WSPD    Horizontal wind speed (m/s)
%     WSS$    Horizontal scalar wind speed (m/s)
%     GSPD    Gust wind speed (m/s)
%     ATMS    Atmospheric pressure at sea level (mb)
%     DRYT    Dry bulb temperature (¡C)
%     SSTP    Sea surface temperature (¡C)
%     SLEV    Observed sea level
%     SST1    Average sea temperature from the non-synoptic part of WRIPS buoy data (¡C)
%     SSTP    Sea surface temperature (¡C)
%     DIRECTION and POSITION CODES
%     LTG$    GPS latitude (reported by the buoy) (¡)
%     LNG$    GPS longitude (reported by the buoy) (¡)
%     MAGN    Magnetic variation from true north (¡)
%     SED1    WES sea direction (¡)
%     SWDR    Direction from which swell is coming (¡ relative to true north)
%     VPED    WAVE SPECTRUM PEAK ENERGY DIRECTION(¡)
%     VSPR    Wave directional spread from cross spectra
%     OTHER CODES
%     ADNB    Number of fourier transform blocks in analysis
%     ADST    DIWAR receiver signal strength
%     ADSV    DIWAR receiver signal strength variance
%     AST1    Internal temperature from the non-synoptic part of WRIPS buoy data
%     AST2    Internal temperature from the synoptic part of WRIPS buoy data
%     NBD1    The number of bad samples in a surface elevation time series
%     RECD    The record number of the tape containing the raw data
%     SIDE    The side number of the tape containing the raw data
%     TAPE    The tape number of the tape containing the raw data
%     WOI$    The WAVEOB indicator group 00IaImIp from code section 0 of the code.=fgetl(fid);



 
fid=fopen(fname);


b=struct('mtime',NaN(365*24,1),'wvh',NaN(365*24,1),'wvp',NaN(365*24,1),...
         'wdir',NaN(365*24,1),'wspd',NaN(365*24,1),...
	 'atms',NaN(365*24,1),'dryt',NaN(365*24,1),...
	 'sstp',NaN(365*24,1),...
	 'freq',NaN(1,41),'bwdth',NaN(1,41),'dens',NaN(365*24,41) );

k=0;
l=fgetl(fid);
while l(1)>-1,
  l=fgetl(fid);
  k=k+1;
  if rem(k,24*10)==0, fprintf('.'); end;
  hhmm=sscanf(l(39:42),'%d');
  b.mtime(k)=datenum(sscanf(l(30:33),'%d'),sscanf(l(34:35),'%d'),sscanf(l(36:37),'%d'),fix(hhmm/100),rem(hhmm,60),0);
  
  n_addparam=sscanf(l(67:70),'%d');
  n_wvh=sscanf(l(71:73),'%d');
  n_wvp=sscanf(l(74:76),'%d');
  n_spec=sscanf(l(77:80),'%d');
  
  for kk=1:ceil(n_addparam/5),
    l=fgetl(fid);
    l=reshape(l,16,length(l)/16)';
    for k2=1:size(l,1);
      switch l(k2,13:16),
         case 'WDIR',
	    b.wdir(k)=sscanf(l(k2,1:12),'%f');
	 case 'WSPD',
	    b.wspd(k)=sscanf(l(k2,1:12),'%f');
	 case 'ATMS',
	    b.atms(k)=sscanf(l(k2,1:12),'%f');
	 case 'DRYT',
	    b.dryt(k)=sscanf(l(k2,1:12),'%f');
	 case 'SSTP',
	    b.sstp(k)=sscanf(l(k2,1:12),'%f');
       end;
    end;   	 
  end;
  
  for kk=1:ceil( (n_wvh+n_wvp)/8 ),
    l=fgetl(fid);
    l=reshape(l,10,length(l)/10)';
    for k2=1:size(l,1);
      switch l(k2,7:10),
         case {'VCAR','VWVH$'}
	    b.wvh(k)=sscanf(l(k2,1:6),'%f');
	 case {'VTPK','VTP$'}
	    b.wvp(k)=sscanf(l(k2,1:6),'%f');
       end;
    end;   	 
  end;
  
  l2=0;
  for kk=1:ceil( n_spec/2 ),
    l=deblank(fgetl(fid));
    l=reshape(l,36,length(l)/36)';
    if n_spec==41,  % This is a hack!
      for k2=1:size(l,1);
        l2=l2+1;
        b.freq(l2)=sscanf(l(k2,1:12),'%f');
        b.bwdth(l2)=sscanf(l(k2,13:24),'%f');
        b.dens(k,l2)=sscanf(l(k2,25:36),'%f');
      end;
    elseif kk==1,
      fprintf('nspec ignored, =%d\n',n_spec);  % Warning
    end;     	 
  end;
  l=fgetl(fid);

end;

b.mtime(k+1:end)=[];
b.wvh(k+1:end)=[];
b.wvp(k+1:end)=[];
b.wdir(k+1:end)=[];
b.wspd(k+1:end)=[];
b.atms(k+1:end)=[];
b.dryt(k+1:end)=[];
b.sstp(k+1:end)=[];
b.dens(k+1:end,:)=[];

    
    
