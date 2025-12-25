addpath ./SourceCode/


% Load inputs:
openProp_Inputs


%pt.geometry = Geometry(openProp_Inputs);

pt.design = pt.input;
pt.geometry = Geometry(pt); %sets up propeller geometry (gives cords for stl)




%----------------------------------------------------------------
                           %Hub definitions
%----------------------------------------------------------------

Rhub = pt.input.Rhub;

Lhub = pt.input.Lhub;
R_hole = 0.25*Rhub; % shaft hole in m, change accordingly
L_nose = 1*Lhub;
L_pocket = 0.6*Lhub; % sets the depth of the shaft hole as a % of the hub len

nTheta = 60; %resolution of the hub (smooth cylinder, higher size as num increases)

%defining the orientation of the hub; Prevents overlapping or rotation
%about y
x_centre = 0;
xhub_back = x_centre - Lhub/2;
xhub_front = x_centre + Lhub/4;



%Setting the data from openProp's outputs
X = pt.geometry.X3D;
Y = pt.geometry.Y3D;
Z = pt.geometry.Z3D;


%closing blade tips
Vblades = []; 
Fblades = [];

%converts arrays into meshes and uses vertices to connect triangles
%(closure of root and tips)
for k = 1:size(Z, 3)
    Xb = X(:,:,k); Yb = Y(:,:,k); Zb = Z(:,:,k);
    [Fsec, Vsec] = surf2patch(Xb, Yb, Zb, 'triangles');
    [M, N] = size(Xb);
    
    %tip closing
    tip_indices = (M : M : N*M)'; 
    v_tip_center = mean(Vsec(tip_indices, :), 1);
    tip_center_idx = size(Vsec, 1) + 1;
    Vsec = [Vsec; v_tip_center];
    F_tip = [];
    for i = 1:length(tip_indices)-1
        F_tip = [F_tip; tip_indices(i), tip_indices(i+1), tip_center_idx];
    end
    F_tip = [F_tip; tip_indices(end), tip_indices(1), tip_center_idx];
    
    %root closing
    root_indices = (1 : M : (N-1)*M + 1)';
    v_root_center = mean(Vsec(root_indices, :), 1);
    root_center_idx = size(Vsec, 1) + 1;
    Vsec = [Vsec; v_root_center];
    F_root = [];
    for i = 1:length(root_indices)-1
        F_root = [F_root; root_indices(i), root_indices(i+1), root_center_idx];
    end
    F_root = [F_root; root_indices(end), root_indices(1), root_center_idx];
    F_root = fliplr(F_root); %making sure hub and blade roots are perfectly normal
    
    Fsec = [Fsec; F_tip; F_root];
    Fblades = [Fblades; Fsec + size(Vblades, 1)];
    Vblades = [Vblades; Vsec];
end

%hub creation
[TH_c, X_c] = meshgrid(linspace(0, 2*pi, nTheta), linspace(xhub_back, xhub_front, 20));
[Fo, Vo] = surf2patch(X_c, Rhub*cos(TH_c), Rhub*sin(TH_c), 'triangles');

%creating nacelle through ellipsodial curve
x_local = linspace(0, L_nose, 50);
r_nose = Rhub * sqrt(1 - (x_local ./ L_nose).^1.5);
[TH_n, X_n] = meshgrid(linspace(0, 2*pi, nTheta), xhub_front + x_local);
[Fn, Vn] = surf2patch(X_n, r_nose'.*cos(TH_n), r_nose'.*sin(TH_n), 'triangles');

%closing the back of hub
[TH_a, R_a] = meshgrid(linspace(0, 2*pi, nTheta), linspace(R_hole, Rhub, 5));
[Fa, Va] = surf2patch(repmat(xhub_back, size(TH_a)), R_a.*cos(TH_a), R_a.*sin(TH_a), 'triangles');
Fa = fliplr(Fa); %flipping geometry so back faces the -x dir

%shaft cylinder from back
[TH_s, X_s] = meshgrid(linspace(0, 2*pi, nTheta), linspace(xhub_back, xhub_back + L_pocket, 10));
[Fs, Vs] = surf2patch(X_s, R_hole*cos(TH_s), R_hole*sin(TH_s), 'triangles');
Fs = fliplr(Fs); % flipping again so it goes in -x dir

%adding a cover for the shaft cylinder
[TH_p, R_p] = meshgrid(linspace(0, 2*pi, nTheta), linspace(0, R_hole, 5));
[Fp, Vp] = surf2patch(repmat(xhub_back + L_pocket, size(TH_p)), R_p.*cos(TH_p), R_p.*sin(TH_p), 'triangles');
Fp = fliplr(Fp); % flipping again so it goes in -x dir


% Assembling all the meshes

%collecting all the parts for assembly
all_V = [Vblades; Vo; Vn; Va; Vs; Vp];
all_F = [Fblades; ...
         Fo + size(Vblades,1); ...
         Fn + size(Vblades,1) + size(Vo,1); ...
         Fa + size(Vblades,1) + size(Vo,1) + size(Vn,1); ...
         Fs + size(Vblades,1) + size(Vo,1) + size(Vn,1) + size(Va,1); ...
         Fp + size(Vblades,1) + size(Vo,1) + size(Vn,1) + size(Va,1) + size(Vs,1)];

%Finds the unique points and removes the duplicates to try to make one
%surface. !Does not work yet!
[V_unique, ~, idx] = unique(round(all_V, 5), 'rows', 'stable');
F_unique = idx(all_F);

%Triangulation to start joining vertices
TR = triangulation(F_unique, V_unique);

%Trialing a fix to enable solidworks to calculate total volume
v_center = mean(V_unique, 1);
tnorm = faceNormal(TR);
vectors_to_face = TR.Points(TR.ConnectivityList(:,1), :) - v_center;
dot_products = sum(tnorm .* vectors_to_face, 2);

%some triangles face inward, so flip them for solidWorks
F_unique(dot_products < 0, :) = F_unique(dot_products < 0, [1 3 2]);
TR_final = triangulation(F_unique, V_unique);

%saving
stlwrite(TR_final, 'propSTL_EDFTest.stl');
