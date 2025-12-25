%------------------------
%        INPUTS
%------------------------

filename = "openProp_STUFF";
notes = "Initial propeller design for IGES file";

%Prop mesh resolution ---> greater number = greater file size but more
%resolution
Mp = 20;
Np = 20;

%prop definitions  
Z = 12; % num of blades
D = 0.09; % Diameter in m
R = D/2; % radius of prop in m

%prop twist
theta_hub = 25;  % degrees at hub
theta_tip = 10;  %degrees at tip
VARING = linspace(theta_hub, theta_tip, Mp); %Variation of twist along prop

% Flight requirements
N = 30000; % RPM
Thrust = 15; % N of thrust in CRUISE 
Vs = 20; % m/s aircraft speed

% Advance ratio
Js = Vs/((N/60)*D); 


rho = 1.225; %air density at cruise level kg/m^3


% Duct parameters
TAU = 0.9; % so prop produces tau% of the thrust and duct the remaining %
Rduct = D/2; % duct radius in m
Rduct_oR = Rduct/R; %duct radius ratio
Cduct = 0.7*D; %length of duct
CDd = 0.02;
Cduct_oR = Cduct/D; % duct length ratio
Xduct_oR = 0; %duct axial location

Gd = (Rduct*2)/D; %duct diamater ratio



% Aerofoil chosen's characteristics
Meanline = char("NACA a=0.8"); %defines the camber line
Thickness = char("NACA 65A010"); %max thickness

%CL calcs
alpha = VARING; %its just alpha but for theta distribution
CL = 2*pi* deg2rad(alpha); %Gives CL, LLT => 2pi*alpha

TANBIC = tand(VARING);
TANBC = TANBIC;

BetaIC = atand(TANBIC);
BetaC = atand(TANBC);


% Hub constraints
Dhub = 0.15*D; % in m of diameter for radius of hub
Rhub = Dhub/2;  %hub radius in m
Rhub_oR = Dhub/D; %nom dim num for blade cutoff loc
Lhub = 0.15*D; %length of the hub

XR = linspace(Rhub_oR, 1, Mp); %defines radial pos for t0oc0 to use
t0oc0 = linspace(0.16, 0.05, Mp); % max thickness/chord at that radial pos
XCoD = linspace(0.12, 0.04, Mp);  % chord / diameter


XCD = 0.012 * ones(1, Mp);
XVA = ones(1, Mp); % vel distribution with 1 equaling freestream
XVT = zeros(1, Mp); % some inflow



RC = linspace(Rhub_oR, 1, Mp);  % radial positions
RV = ones(1, Mp);               % or XVA




%-----------------------------------------------------------------
%             Now to define pt inputs as per examples
%-----------------------------------------------------------------

% ---------------------------------------------------------
% Pack variables into input struct for OpenProp
% ---------------------------------------------------------
input.Z        = Z;          % number of blades
input.D        = D;          % prop diameter [m]
input.R        = R;          % prop radius [m]
input.N        = N;          % prop RPM
input.Thrust   = Thrust;     % thrust in cruise [N]
input.Vs       = Vs;         % aircraft speed [m/s]
input.Js = Js;



input.Mp       = Mp;         % number of radial panels
input.Np       = Np;         % points along chord
input.rho      = rho;        % air density [kg/m^3]
input.VARING = VARING;


input.TAU      = TAU;        % propeller thrust ratio
input.Rduct    = Rduct;      % duct radius [m]
input.Cduct    = Cduct;      % duct chord [m]
input.CDd      = CDd;        % duct drag coefficient
input.Cduct_oR = Cduct_oR;
input.Xduct_oR = Xduct_oR;
input.Gd = Gd;

input.CL = CL;
input.TANBIC = TANBIC;
input.TANBC = TANBIC;
input.BetaIC = BetaIC;
input.BetaC = BetaC;


% Aerofoil properties
input.Meanline  = Meanline;  % camber line type
input.Thickness = Thickness; % thickness type

% Hub constraints
input.Dhub      = Dhub;      % hub diameter [m]
input.Rhub      = Rhub;      % hub radius [m]
input.Rhub_oR   = Rhub_oR;   % non-dimensional hub radius
input.Rduct_oR = Rduct_oR;
input.Lhub = Lhub;


% Blade geometry distributions
input.XR     = XR;       % radial positions (r/R)
input.RC = RC; %new open prop needs RC not XR

input.t0oc0  = t0oc0;    % thickness/chord at each XR

input.XCoD   = XCoD;     % chord/diameter at each XR
input.G = XCoD(:); %new openprop again => needs it as a column vector so : transposes it

input.XCD    = XCD;      % section drag coefficient

input.XVA    = XVA;      %radial velocity disturb
input.RV = RV; %new openprop problem


input.XVT    = XVT;      % tangential inflow velocity ratio


input.Make_Rhino_flag = 1;
input.filename = "Propeller_design_rhino";


% ---------------------------- Pack up propeller/turbine data structure, pt
pt.filename = filename; % (string) propeller/turbine name
pt.date     = date;     % (string) date created
pt.notes    = notes;    % (string or cell matrix)   notes
pt.input    = input;    % (struct) input parameters
pt.design   = [];       % (struct) design conditions
pt.geometry = [];       % (struct) design geometry
pt.states   = [];       % (struct) off-design state analysis

% --------------------------------------------------------- Save input data
save OPinput pt input

