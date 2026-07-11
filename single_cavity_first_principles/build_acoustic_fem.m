function sys=build_acoustic_fem(cfg)
%BUILD_ACOUSTIC_FEM Assemble P1/P2 tetrahedral Helmholtz FEM in MATLAB.

here=fileparts(mfilename('fullpath'));
S=load(fullfile(here,'frozen_geometry_mesh.mat'),'mesh');mesh=S.mesh;
v0=double(mesh.vertex);tet0=double(mesh.tet);
pmlElement=false(1,size(tet0,2));
if isfield(cfg,'useFinitePML') && cfg.useFinitePML
    if ~isfield(mesh,'prism'),error('Frozen mesh does not contain PML prisms.');end
    prismTet=split_prisms(double(mesh.prism));
    tet0=[tet0,prismTet];
    pmlElement=[pmlElement,true(1,size(prismTet,2))];
end
used=unique(tet0(:));map=zeros(1,size(v0,2),'uint32');map(used)=uint32(1:numel(used));
v=v0(:,used);tet=double(map(tet0));nVertex=size(v,2);ne=size(tet,2);

[grad,vol]=tet_geometry(v,tet);
stretch=ones(1,ne);
if any(pmlElement),stretch(pmlElement)=cfg.pmlStretch;end
if cfg.femOrder==1
    conn=tet;n=nVertex;[Kbase,M]=assemble_p1(conn,grad,vol,stretch,n);
    allEdges=[];
else
    [allEdges,edgeId]=tet_edges(tet);
    conn=[tet;nVertex+edgeId];
    edgeXYZ=0.5*(v(:,allEdges(:,1))+v(:,allEdges(:,2)));
    v=[v,edgeXYZ];n=size(v,2);
    [Kbase,M]=assemble_p2(conn,grad,vol,stretch,n);
end

% The physical mesh ends at z=+-L/2; the discarded axial PML is replaced
% by a circular-waveguide radiation operator linearized at the target k.
if any(pmlElement)
    B=sparse(n,n);K=Kbase;tri=zeros(3,0);
else
    tri0=double(mesh.tri);z0=double(mesh.vertex(3,:));
    isEnd=all(abs(abs(reshape(z0(tri0),3,[]))-cfg.ductLength/2)<1e-8,1);
    tri0=tri0(:,isEnd);keep=all(map(tri0)>0,1);tri=double(map(tri0(:,keep)));
    if cfg.femOrder==1
        B=surface_mass_p1(v,tri,n);
    else
        B=surface_mass_p2(v,tri,allEdges,nVertex,n);
    end
    kt=2*pi*cfg.targetEigenfrequency/cfg.c0;
    kz=sqrt(complex(kt^2-(1.8412/cfg.ductRadius)^2));
    K=Kbase+1i*kz*B;
end
sys=struct('kind','fem','K',K,'Kbase',Kbase,'M',M,'B',B, ...
    'vertex',v,'tet',uint32(conn),'pmlElement',pmlElement,'n',n,'cfg',cfg);
if any(pmlElement),kind='finite PML';else,kind='modal radiation';end
fprintf('FEM-P%d (%s): %d DOFs, %d tetrahedra, %d radiation triangles\n', ...
    cfg.femOrder,kind,n,ne,size(tri,2));
end

function tet=split_prisms(p)
% COMSOL prism order: bottom triangle 1:3, corresponding top triangle 4:6.
pat=[1 2 3 4;2 3 4 5;3 4 5 6];
np=size(p,2);tet=zeros(4,3*np);
for k=1:3,tet(:,(k-1)*np+(1:np))=p(pat(k,:),:);end
end

function [grad,vol]=tet_geometry(v,tet)
r1=v(:,tet(1,:));r2=v(:,tet(2,:));r3=v(:,tet(3,:));r4=v(:,tet(4,:));
a=r2-r1;b=r3-r1;c=r4-r1;
bc=cross(b,c,1);ca=cross(c,a,1);ab=cross(a,b,1);detJ=sum(a.*bc,1);
if any(abs(detJ)<1e-18),error('Zero-volume tetrahedron in frozen mesh.');end
g2=bc./detJ;g3=ca./detJ;g4=ab./detJ;g1=-(g2+g3+g4);
grad=cat(3,g1,g2,g3,g4);vol=abs(detJ)/6;
end

function [edges,edgeId]=tet_edges(tet)
pairs=[1 2;1 3;1 4;2 3;2 4;3 4];ne=size(tet,2);
raw=zeros(6*ne,2);
for k=1:6
    rows=(k-1)*ne+(1:ne);
    raw(rows,:)=sort(tet(pairs(k,:),:).',2);
end
[edges,~,ic]=unique(raw,'rows','sorted');
edgeId=reshape(ic,ne,6).';
end

function [K,M]=assemble_p1(conn,grad,vol,stretch,n)
ne=size(conn,2);I=zeros(16,ne);J=I;VK=I;VM=I;q=0;
for i=1:4
    for j=1:4
        q=q+1;I(q,:)=conn(i,:);J(q,:)=conn(j,:);
        gj=grad(:,:,j);
        Agj=[stretch.*gj(1,:);stretch.*gj(2,:);gj(3,:)./stretch];
        VK(q,:)=vol.*sum(grad(:,:,i).*Agj,1);
        VM(q,:)=vol.*stretch.*(1+(i==j))/20;
    end
end
K=sparse(I(:),J(:),VK(:),n,n);M=sparse(I(:),J(:),VM(:),n,n);
end

function [K,M]=assemble_p2(conn,g,vol,stretch,n)
ne=size(conn,2);Mref=p2_mass_reference(4);K=sparse(n,n);M=sparse(n,n);
alpha=0.585410196624969;beta=0.138196601125011;
L=beta*ones(4,4);L(1:5:end)=alpha;
edge=[1 2;1 3;1 4;2 3;2 4;3 4];chunk=4000;
for first=1:chunk:ne
    e=first:min(first+chunk-1,ne);nc=numel(e);Ke=zeros(100,nc);
    for q=1:4
        G=zeros(3,nc,10);
        for i=1:4,G(:,:,i)=(4*L(i,q)-1)*g(:,e,i);end
        for k=1:6
            i=edge(k,1);j=edge(k,2);
            G(:,:,4+k)=4*(L(i,q)*g(:,e,j)+L(j,q)*g(:,e,i));
        end
        r=0;
        for i=1:10
            for j=1:10
                r=r+1;Gj=G(:,:,j);se=stretch(e);
                AGj=[se.*Gj(1,:);se.*Gj(2,:);Gj(3,:)./se];
                Ke(r,:)=Ke(r,:)+0.25*vol(e).*sum(G(:,:,i).*AGj,1);
            end
        end
    end
    Me=Mref(:).*(vol(e).*stretch(e));
    ce=conn(:,e);I=repmat(ce,10,1);J=kron(ce,ones(10,1));
    K=K+sparse(I(:),J(:),Ke(:),n,n);
    M=M+sparse(I(:),J(:),Me(:),n,n);
end
end

function R=p2_mass_reference(nLambda)
% Exact barycentric integration of the ten quadratic shape products.
poly=cell(10,1);
for i=1:4
    e=zeros(1,4);e(i)=2;e1=zeros(1,4);e1(i)=1;
    poly{i}={ [2,-1],[e;e1] };
end
edge=[1 2;1 3;1 4;2 3;2 4;3 4];
for k=1:6,e=zeros(1,4);e(edge(k,:))=1;poly{4+k}={4,e};end
R=zeros(10);
for i=1:10
    for j=1:10
        ci=poly{i}{1};ei=poly{i}{2};cj=poly{j}{1};ej=poly{j}{2};
        for a=1:numel(ci)
            for b=1:numel(cj)
                R(i,j)=R(i,j)+ci(a)*cj(b)*simplex_moment( ...
                    ei(a,:)+ej(b,:),nLambda-1);
            end
        end
    end
end
end

function m=simplex_moment(exponent,dim)
m=factorial(dim)*prod(factorial(exponent))/factorial(dim+sum(exponent));
end

function B=surface_mass_p1(v,tri,n)
p1=v(:,tri(1,:));p2=v(:,tri(2,:));p3=v(:,tri(3,:));
area=0.5*sqrt(sum(cross(p2-p1,p3-p1,1).^2,1));nt=size(tri,2);
I=zeros(9,nt);J=I;V=I;q=0;
for i=1:3
    for j=1:3
        q=q+1;I(q,:)=tri(i,:);J(q,:)=tri(j,:);
        V(q,:)=area.*(1+(i==j))/12;
    end
end
B=sparse(I(:),J(:),V(:),n,n);
end

function B=surface_mass_p2(v,tri,allEdges,nVertex,n)
e12=sort(tri([1 2],:).',2);e13=sort(tri([1 3],:).',2);e23=sort(tri([2 3],:).',2);
[ok1,i12]=ismember(e12,allEdges,'rows');[ok2,i13]=ismember(e13,allEdges,'rows');
[ok3,i23]=ismember(e23,allEdges,'rows');
if ~all(ok1&ok2&ok3),error('Boundary edge not found in tetrahedral edge table.');end
conn=[tri;nVertex+i12.';nVertex+i13.';nVertex+i23.'];
p1=v(:,tri(1,:));p2=v(:,tri(2,:));p3=v(:,tri(3,:));
area=0.5*sqrt(sum(cross(p2-p1,p3-p1,1).^2,1));R=p2_triangle_mass();
I=repmat(conn,6,1);J=kron(conn,ones(6,1));V=R(:).*area;
B=sparse(I(:),J(:),V(:),n,n);
end

function R=p2_triangle_mass()
poly=cell(6,1);
for i=1:3
    e=zeros(1,3);e(i)=2;e1=zeros(1,3);e1(i)=1;
    poly{i}={[2,-1],[e;e1]};
end
edge=[1 2;1 3;2 3];
for k=1:3
    e=zeros(1,3);e(edge(k,:))=1;poly{3+k}={4,e};
end
R=zeros(6);
for i=1:6
    for j=1:6
        ci=poly{i}{1};ei=poly{i}{2};cj=poly{j}{1};ej=poly{j}{2};
        for a=1:numel(ci)
            for b=1:numel(cj)
                R(i,j)=R(i,j)+ci(a)*cj(b)*simplex_moment(ei(a,:)+ej(b,:),2);
            end
        end
    end
end
end
