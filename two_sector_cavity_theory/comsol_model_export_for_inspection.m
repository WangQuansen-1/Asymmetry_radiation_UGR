function out = model
%
% comsol_model_export_for_inspection.m
%
% Model exported on Jul 12 2026, 15:31 by COMSOL 6.4.0.293.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath(['G:\' native2unicode(hex2dec({'97' '5e'}), 'unicode')  native2unicode(hex2dec({'5b' 'f9'}), 'unicode')  native2unicode(hex2dec({'79' 'f0'}), 'unicode')  native2unicode(hex2dec({'8f' '90'}), 'unicode')  native2unicode(hex2dec({'5c' '04'}), 'unicode') '\' native2unicode(hex2dec({'74' '06'}), 'unicode')  native2unicode(hex2dec({'8b' 'ba'}), 'unicode') 'codex']);

model.label([native2unicode(hex2dec({'53' 'cc'}), 'unicode')  native2unicode(hex2dec({'5c' '42'}), 'unicode')  native2unicode(hex2dec({'7e' 'd3'}), 'unicode')  native2unicode(hex2dec({'67' '84'}), 'unicode')  native2unicode(hex2dec({'97' '5e'}), 'unicode')  native2unicode(hex2dec({'5b' 'f9'}), 'unicode')  native2unicode(hex2dec({'79' 'f0'}), 'unicode')  native2unicode(hex2dec({'6d' '4b'}), 'unicode')  native2unicode(hex2dec({'8b' 'd5'}), 'unicode') '_' native2unicode(hex2dec({'4e' 'ff'}), 'unicode')  native2unicode(hex2dec({'71' '67'}), 'unicode') 'optic.mph']);

model.param.set('D', '100[mm]');
model.param.set('L', '300[mm]*2');
model.param.set('delta_th', '10[deg]');
model.param.set('zi', '0.05[m]');
model.param.set('pml', 'L/4');
model.param.set('f0', '3000[Hz]');
model.param.set('c0', '343[m/s]');
model.param.set('lbd', 'c0/f0');
model.param.group.create('par2');
model.param('par2').set('G', 'pi/L');
model.param('par2').set('m', '0');
model.param.group.create('par3');
model.param('par3').set('r1', 'r_min+(r_max-r_min)*r1n', [native2unicode(hex2dec({'59' '16'}), 'unicode')  native2unicode(hex2dec({'57' '08'}), 'unicode') '1' native2unicode(hex2dec({'76' '84'}), 'unicode')  native2unicode(hex2dec({'53' '9a'}), 'unicode')  native2unicode(hex2dec({'5e' 'a6'}), 'unicode') ]);
model.param('par3').set('th1', 'th1_min+(th1_max-th1_min)*th1_n', [native2unicode(hex2dec({'59' '16'}), 'unicode')  native2unicode(hex2dec({'57' '08'}), 'unicode') '1' native2unicode(hex2dec({'76' '84'}), 'unicode')  native2unicode(hex2dec({'62' '47'}), 'unicode')  native2unicode(hex2dec({'5f' '62'}), 'unicode')  native2unicode(hex2dec({'89' 'd2'}), 'unicode') ]);
model.param('par3').set('r2', 'r_min+(r_max-r_min)*r2n', [native2unicode(hex2dec({'59' '16'}), 'unicode')  native2unicode(hex2dec({'57' '08'}), 'unicode') '2' native2unicode(hex2dec({'76' '84'}), 'unicode')  native2unicode(hex2dec({'53' '9a'}), 'unicode')  native2unicode(hex2dec({'5e' 'a6'}), 'unicode') ]);
model.param('par3').set('th2', 'th1_min+(th1_max-th1_min)*th2_n', [native2unicode(hex2dec({'59' '16'}), 'unicode')  native2unicode(hex2dec({'57' '08'}), 'unicode') '2' native2unicode(hex2dec({'76' '84'}), 'unicode')  native2unicode(hex2dec({'62' '47'}), 'unicode')  native2unicode(hex2dec({'5f' '62'}), 'unicode')  native2unicode(hex2dec({'89' 'd2'}), 'unicode') ]);
model.param('par3').set('z1', 'z_min+(z_max-z_min)*z1_n', [native2unicode(hex2dec({'59' '16'}), 'unicode')  native2unicode(hex2dec({'57' '08'}), 'unicode') '1' native2unicode(hex2dec({'76' '84'}), 'unicode') 'z' native2unicode(hex2dec({'54' '11'}), 'unicode')  native2unicode(hex2dec({'62' 'c9'}), 'unicode')  native2unicode(hex2dec({'4f' '38'}), 'unicode') ]);
model.param('par3').set('z2', 'z_min+(z_max-z_min)*z2_n', [native2unicode(hex2dec({'59' '16'}), 'unicode')  native2unicode(hex2dec({'57' '08'}), 'unicode') '2' native2unicode(hex2dec({'76' '84'}), 'unicode') 'z' native2unicode(hex2dec({'54' '11'}), 'unicode')  native2unicode(hex2dec({'62' 'c9'}), 'unicode')  native2unicode(hex2dec({'4f' '38'}), 'unicode') ]);
model.param.group.create('par4');
model.param('par4').set('th1_max', '180[deg]');
model.param('par4').set('th1_min', '10[deg]');
model.param('par4').set('r_max', 'lbd/4');
model.param('par4').set('r_min', 'lbd/16');
model.param('par4').set('z_min', 'lbd/16');
model.param('par4').set('z_max', 'lbd/2');
model.param.group.create('par5');
model.param('par5').set('th1_n', '1');
model.param('par5').set('th2_n', '1');
model.param('par5').set('r1n', '1');
model.param('par5').set('r2n', '1');
model.param('par5').set('z1_n', '1');
model.param('par5').set('z2_n', '1');
model.param('par5').label([native2unicode(hex2dec({'7e' 'd3'}), 'unicode')  native2unicode(hex2dec({'67' '84'}), 'unicode')  native2unicode(hex2dec({'53' 'c2'}), 'unicode')  native2unicode(hex2dec({'65' '70'}), 'unicode') ]);

model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 3);

model.result.table.create('evl3', 'Table');

model.component('comp1').mesh.create('mesh1');

model.component('comp1').geom('geom1').geomRep('cadps');
model.component('comp1').geom('geom1').designBooleans(true);
model.component('comp1').geom('geom1').create('cyl1', 'Cylinder');
model.component('comp1').geom('geom1').feature('cyl1').set('r', 'D/2');
model.component('comp1').geom('geom1').feature('cyl1').set('h', 'L+pml*2');
model.component('comp1').geom('geom1').feature('cyl1').set('pos', {'0' '0' '-L/2-pml'});
model.component('comp1').geom('geom1').feature('cyl1').set('layername', {[native2unicode(hex2dec({'5c' '42'}), 'unicode') ' 1']});
model.component('comp1').geom('geom1').feature('cyl1').setIndex('layer', 'L/4', 0);
model.component('comp1').geom('geom1').feature('cyl1').set('layerside', false);
model.component('comp1').geom('geom1').feature('cyl1').set('layerbottom', true);
model.component('comp1').geom('geom1').feature('cyl1').set('layertop', true);
model.component('comp1').geom('geom1').create('wp1', 'WorkPlane');
model.component('comp1').geom('geom1').feature('wp1').set('quickz', 'zi');
model.component('comp1').geom('geom1').feature('wp1').set('unite', true);
model.component('comp1').geom('geom1').feature('wp1').geom.create('c1', 'Circle');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('c1').set('r', 'D/2');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('c1').set('angle', 'th1');
model.component('comp1').geom('geom1').feature('wp1').geom.create('c2', 'Circle');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('c2').set('r', 'r1+D/2');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('c2').set('angle', 'th1');
model.component('comp1').geom('geom1').feature('wp1').geom.create('dif1', 'Difference');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('dif1').selection('input').set({'c2'});
model.component('comp1').geom('geom1').feature('wp1').geom.feature('dif1').selection('input2').set({'c1'});
model.component('comp1').geom('geom1').create('ext1', 'Extrude');
model.component('comp1').geom('geom1').feature('ext1').setIndex('distance', 'z1', 0);
model.component('comp1').geom('geom1').feature('ext1').selection('input').set({'wp1'});
model.component('comp1').geom('geom1').create('wp2', 'WorkPlane');
model.component('comp1').geom('geom1').feature('wp2').set('quickz', 'zi+z1/2-z2/2');
model.component('comp1').geom('geom1').feature('wp2').set('unite', true);
model.component('comp1').geom('geom1').feature('wp2').geom.create('c1', 'Circle');
model.component('comp1').geom('geom1').feature('wp2').geom.feature('c1').set('r', 'r2+D/2');
model.component('comp1').geom('geom1').feature('wp2').geom.feature('c1').set('angle', 'th2');
model.component('comp1').geom('geom1').feature('wp2').geom.create('c2', 'Circle');
model.component('comp1').geom('geom1').feature('wp2').geom.feature('c2').set('r', 'D/2');
model.component('comp1').geom('geom1').feature('wp2').geom.feature('c2').set('angle', 'th2');
model.component('comp1').geom('geom1').feature('wp2').geom.create('dif1', 'Difference');
model.component('comp1').geom('geom1').feature('wp2').geom.feature('dif1').selection('input').set({'c1'});
model.component('comp1').geom('geom1').feature('wp2').geom.feature('dif1').selection('input2').set({'c2'});
model.component('comp1').geom('geom1').feature('wp2').geom.create('rot1', 'Rotate');
model.component('comp1').geom('geom1').feature('wp2').geom.feature('rot1').set('rot', 'th1+delta_th');
model.component('comp1').geom('geom1').feature('wp2').geom.feature('rot1').selection('input').set({'dif1'});
model.component('comp1').geom('geom1').create('ext2', 'Extrude');
model.component('comp1').geom('geom1').feature('ext2').setIndex('distance', 'z2', 0);
model.component('comp1').geom('geom1').feature('ext2').selection('input').set({'wp2'});
model.component('comp1').geom('geom1').create('wp3', 'WorkPlane');
model.component('comp1').geom('geom1').feature('wp3').set('quickz', 'zi');
model.component('comp1').geom('geom1').feature('wp3').set('unite', true);
model.component('comp1').geom('geom1').feature('wp3').geom.create('c1', 'Circle');
model.component('comp1').geom('geom1').feature('wp3').geom.feature('c1').set('r', 'r1+D/2');
model.component('comp1').geom('geom1').feature('wp3').geom.feature('c1').set('angle', 'th1');
model.component('comp1').geom('geom1').feature('wp3').geom.feature('c1').set('rot', '+180');
model.component('comp1').geom('geom1').feature('wp3').geom.create('c2', 'Circle');
model.component('comp1').geom('geom1').feature('wp3').geom.feature('c2').set('r', 'D/2');
model.component('comp1').geom('geom1').feature('wp3').geom.feature('c2').set('angle', 'th1');
model.component('comp1').geom('geom1').feature('wp3').geom.feature('c2').set('rot', 180);
model.component('comp1').geom('geom1').feature('wp3').geom.create('dif1', 'Difference');
model.component('comp1').geom('geom1').feature('wp3').geom.feature('dif1').selection('input').set({'c1'});
model.component('comp1').geom('geom1').feature('wp3').geom.feature('dif1').selection('input2').set({'c2'});
model.component('comp1').geom('geom1').create('ext3', 'Extrude');
model.component('comp1').geom('geom1').feature('ext3').setIndex('distance', 'z1', 0);
model.component('comp1').geom('geom1').feature('ext3').selection('input').set({'wp3'});
model.component('comp1').geom('geom1').create('wp4', 'WorkPlane');
model.component('comp1').geom('geom1').feature('wp4').set('quickz', 'zi+z1/2-z2/2');
model.component('comp1').geom('geom1').feature('wp4').set('unite', true);
model.component('comp1').geom('geom1').feature('wp4').geom.create('c1', 'Circle');
model.component('comp1').geom('geom1').feature('wp4').geom.feature('c1').set('r', 'r2+D/2');
model.component('comp1').geom('geom1').feature('wp4').geom.feature('c1').set('angle', 'th2');
model.component('comp1').geom('geom1').feature('wp4').geom.feature('c1').set('rot', 180);
model.component('comp1').geom('geom1').feature('wp4').geom.create('c2', 'Circle');
model.component('comp1').geom('geom1').feature('wp4').geom.feature('c2').set('r', 'D/2');
model.component('comp1').geom('geom1').feature('wp4').geom.feature('c2').set('angle', 'th2');
model.component('comp1').geom('geom1').feature('wp4').geom.feature('c2').set('rot', 180);
model.component('comp1').geom('geom1').feature('wp4').geom.create('dif1', 'Difference');
model.component('comp1').geom('geom1').feature('wp4').geom.feature('dif1').selection('input').set({'c1'});
model.component('comp1').geom('geom1').feature('wp4').geom.feature('dif1').selection('input2').set({'c2'});
model.component('comp1').geom('geom1').feature('wp4').geom.create('rot1', 'Rotate');
model.component('comp1').geom('geom1').feature('wp4').geom.feature('rot1').set('rot', 'th1+delta_th');
model.component('comp1').geom('geom1').feature('wp4').geom.feature('rot1').selection('input').set({'dif1'});
model.component('comp1').geom('geom1').create('ext4', 'Extrude');
model.component('comp1').geom('geom1').feature('ext4').setIndex('distance', 'z2', 0);
model.component('comp1').geom('geom1').feature('ext4').selection('input').set({'wp4'});
model.component('comp1').geom('geom1').create('rot1', 'Rotate');
model.component('comp1').geom('geom1').feature('rot1').active(false);
model.component('comp1').geom('geom1').feature('rot1').set('keep', true);
model.component('comp1').geom('geom1').feature('rot1').setIndex('rot', '180', 0);
model.component('comp1').geom('geom1').feature('rot1').selection('input').set({'ext1' 'ext2'});
model.component('comp1').geom('geom1').create('mir1', 'Mirror');
model.component('comp1').geom('geom1').feature('mir1').set('keep', true);
model.component('comp1').geom('geom1').feature('mir1').selection('input').set({'ext1' 'ext2' 'ext3' 'ext4'});
model.component('comp1').geom('geom1').create('rot2', 'Rotate');
model.component('comp1').geom('geom1').feature('rot2').active(false);
model.component('comp1').geom('geom1').feature('rot2').setIndex('rot', '10', 0);
model.component('comp1').geom('geom1').feature('rot2').selection('input').set({'mir1(2)' 'mir1(4)'});
model.component('comp1').geom('geom1').create('rot3', 'Rotate');
model.component('comp1').geom('geom1').feature('rot3').setIndex('rot', '10', 0);
model.component('comp1').geom('geom1').feature('rot3').selection('input').set({'ext1' 'ext2' 'ext3' 'ext4'});
model.component('comp1').geom('geom1').nodeGroup.create('grp1');
model.component('comp1').geom('geom1').nodeGroup('grp1').placeAfter('cyl1');
model.component('comp1').geom('geom1').nodeGroup('grp1').add('wp1');
model.component('comp1').geom('geom1').nodeGroup('grp1').add('ext1');
model.component('comp1').geom('geom1').nodeGroup('grp1').add('wp2');
model.component('comp1').geom('geom1').nodeGroup('grp1').add('ext2');
model.component('comp1').geom('geom1').nodeGroup('grp1').add('wp3');
model.component('comp1').geom('geom1').nodeGroup('grp1').add('ext3');
model.component('comp1').geom('geom1').nodeGroup('grp1').add('wp4');
model.component('comp1').geom('geom1').nodeGroup('grp1').add('ext4');
model.component('comp1').geom('geom1').nodeGroup('grp1').add('rot1');
model.component('comp1').geom('geom1').run;
model.component('comp1').geom('geom1').run('fin');

model.component('comp1').variable.create('var1');
model.component('comp1').variable('var1').set('th', 'atan2(y,x)');
model.component('comp1').variable('var1').set('r', 'sqrt(x^2+y^2)');
model.component('comp1').variable('var1').set('p10', 'besselj(1,k10*r)*exp(-1i*1*th)*exp(-1i*kz*z)');
model.component('comp1').variable('var1').set('k10', '1.8412/(D/2)');
model.component('comp1').variable('var1').set('kz', 'sqrt(k0^2-k10^2)');
model.component('comp1').variable('var1').set('k0', 'acpr.k');

model.component('comp1').material.create('mat1', 'Common');
model.component('comp1').material('mat1').propertyGroup('def').func.create('eta', 'Piecewise');
model.component('comp1').material('mat1').propertyGroup('def').func.create('Cp', 'Piecewise');
model.component('comp1').material('mat1').propertyGroup('def').func.create('rho', 'Analytic');
model.component('comp1').material('mat1').propertyGroup('def').func.create('k', 'Piecewise');
model.component('comp1').material('mat1').propertyGroup('def').func.create('cs', 'Analytic');
model.component('comp1').material('mat1').propertyGroup('def').func.create('an1', 'Analytic');
model.component('comp1').material('mat1').propertyGroup('def').func.create('an2', 'Analytic');
model.component('comp1').material('mat1').propertyGroup.create('RefractiveIndex', 'RefractiveIndex', 'Refractive index');
model.component('comp1').material('mat1').propertyGroup.create('NonlinearModel', 'NonlinearModel', 'Nonlinear model');
model.component('comp1').material('mat1').propertyGroup.create('idealGas', 'idealGas', 'Ideal gas');
model.component('comp1').material('mat1').propertyGroup('idealGas').func.create('Cp', 'Piecewise');

model.component('comp1').coordSystem.create('pml1', 'PML');
model.component('comp1').coordSystem('pml1').selection.set([7 9]);

model.component('comp1').physics.create('acpr', 'PressureAcoustics', 'geom1');
model.component('comp1').physics('acpr').create('pc1', 'PeriodicCondition', 2);
model.component('comp1').physics('acpr').feature('pc1').selection.set([25 40]);
model.component('comp1').physics('acpr').create('bpf1', 'BackgroundPressureField', 3);
model.component('comp1').physics('acpr').feature('bpf1').selection.set([8]);

model.component('comp1').mesh('mesh1').create('size1', 'Size');
model.component('comp1').mesh('mesh1').create('size2', 'Size');
model.component('comp1').mesh('mesh1').create('se1', 'SizeExpression');
model.component('comp1').mesh('mesh1').create('dis1', 'Distribution');
model.component('comp1').mesh('mesh1').create('ftet1', 'FreeTet');
model.component('comp1').mesh('mesh1').create('swe1', 'Sweep');
model.component('comp1').mesh('mesh1').feature('size1').selection.geom('geom1', 3);
model.component('comp1').mesh('mesh1').feature('size1').selection.set([1 2 3 4 5 6 8 10 11]);
model.component('comp1').mesh('mesh1').feature('size2').selection.geom('geom1', 2);
model.component('comp1').mesh('mesh1').feature('size2').selection.set([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84]);
model.component('comp1').mesh('mesh1').feature('se1').selection.geom('geom1', 3);
model.component('comp1').mesh('mesh1').feature('se1').selection.set([1 2 3 4 5 6 8 10 11]);
model.component('comp1').mesh('mesh1').feature('dis1').selection.geom('geom1', 1);
model.component('comp1').mesh('mesh1').feature('dis1').selection.set([25 43 78 90 93 105 144 152]);
model.component('comp1').mesh('mesh1').feature('ftet1').selection.geom('geom1', 3);
model.component('comp1').mesh('mesh1').feature('ftet1').selection.set([1 2 3 4 5 6 8 10 11]);
model.component('comp1').mesh('mesh1').feature('swe1').selection.geom('geom1', 3);
model.component('comp1').mesh('mesh1').feature('swe1').selection.set([7 9]);
model.component('comp1').mesh('mesh1').feature('swe1').create('dis1', 'Distribution');

model.result.table('evl3').label('Evaluation 3D');
model.result.table('evl3').comments([native2unicode(hex2dec({'4e' 'a4'}), 'unicode')  native2unicode(hex2dec({'4e' '92'}), 'unicode')  native2unicode(hex2dec({'76' '84'}), 'unicode')  native2unicode(hex2dec({'4e' '09'}), 'unicode')  native2unicode(hex2dec({'7e' 'f4'}), 'unicode')  native2unicode(hex2dec({'50' '3c'}), 'unicode') ]);

model.component('comp1').view('view2').axis.set('xmin', -0.2752538025379181);
model.component('comp1').view('view2').axis.set('xmax', 0.30325379967689514);
model.component('comp1').view('view2').axis.set('ymin', -0.17115919291973114);
model.component('comp1').view('view2').axis.set('ymax', 0.199111670255661);
model.component('comp1').view('view3').axis.set('xmin', -0.18593549728393555);
model.component('comp1').view('view3').axis.set('xmax', 0.23281165957450867);
model.component('comp1').view('view3').axis.set('ymin', -0.11056837439537048);
model.component('comp1').view('view3').axis.set('ymax', 0.15791967511177063);
model.component('comp1').view('view4').axis.set('xmin', -0.1381862759590149);
model.component('comp1').view('view4').axis.set('xmax', 0.1383642852306366);
model.component('comp1').view('view4').axis.set('ymin', -0.06820454448461533);
model.component('comp1').view('view4').axis.set('ymax', 0.08482344448566437);
model.component('comp1').view('view5').axis.set('xmin', -0.12033744156360626);
model.component('comp1').view('view5').axis.set('xmax', 0.13319844007492065);
model.component('comp1').view('view5').axis.set('ymin', -0.05607590079307556);
model.component('comp1').view('view5').axis.set('ymax', 0.08421700447797775);

model.component('comp1').material('mat1').label('Air');
model.component('comp1').material('mat1').set('family', 'air');
model.component('comp1').material('mat1').propertyGroup('def').label('Basic');
model.component('comp1').material('mat1').propertyGroup('def').func('eta').label('Piecewise');
model.component('comp1').material('mat1').propertyGroup('def').func('eta').set('arg', 'T');
model.component('comp1').material('mat1').propertyGroup('def').func('eta').set('pieces', {'200.0' '1600.0' '-8.38278E-7+8.35717342E-8*T^1-7.69429583E-11*T^2+4.6437266E-14*T^3-1.06585607E-17*T^4'});
model.component('comp1').material('mat1').propertyGroup('def').func('eta').set('argunit', 'K');
model.component('comp1').material('mat1').propertyGroup('def').func('eta').set('fununit', 'Pa*s');
model.component('comp1').material('mat1').propertyGroup('def').func('Cp').label('Piecewise 2');
model.component('comp1').material('mat1').propertyGroup('def').func('Cp').set('arg', 'T');
model.component('comp1').material('mat1').propertyGroup('def').func('Cp').set('pieces', {'200.0' '1600.0' '1047.63657-0.372589265*T^1+9.45304214E-4*T^2-6.02409443E-7*T^3+1.2858961E-10*T^4'});
model.component('comp1').material('mat1').propertyGroup('def').func('Cp').set('argunit', 'K');
model.component('comp1').material('mat1').propertyGroup('def').func('Cp').set('fununit', 'J/(kg*K)');
model.component('comp1').material('mat1').propertyGroup('def').func('rho').label('Analytic');
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('expr', 'pA*0.02897/R_const[K*mol/J]/T');
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('args', {'pA' 'T'});
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('fununit', 'kg/m^3');
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('argunit', {'Pa' 'K'});
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('plotaxis', {'off' 'on'});
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('plotfixedvalue', {'101325' '273.15'});
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('plotargs', {'pA' '101325' '101325'; 'T' '273.15' '293.15'});
model.component('comp1').material('mat1').propertyGroup('def').func('k').label('Piecewise 3');
model.component('comp1').material('mat1').propertyGroup('def').func('k').set('arg', 'T');
model.component('comp1').material('mat1').propertyGroup('def').func('k').set('pieces', {'200.0' '1600.0' '-0.00227583562+1.15480022E-4*T^1-7.90252856E-8*T^2+4.11702505E-11*T^3-7.43864331E-15*T^4'});
model.component('comp1').material('mat1').propertyGroup('def').func('k').set('argunit', 'K');
model.component('comp1').material('mat1').propertyGroup('def').func('k').set('fununit', 'W/(m*K)');
model.component('comp1').material('mat1').propertyGroup('def').func('cs').label('Analytic 2');
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('expr', 'sqrt(1.4*R_const[K*mol/J]/0.02897*T)');
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('args', {'T'});
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('fununit', 'm/s');
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('argunit', {'K'});
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('plotfixedvalue', {'273.15'});
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('plotargs', {'T' '273.15' '373.15'});
model.component('comp1').material('mat1').propertyGroup('def').func('an1').label('Analytic 1');
model.component('comp1').material('mat1').propertyGroup('def').func('an1').set('funcname', 'alpha_p');
model.component('comp1').material('mat1').propertyGroup('def').func('an1').set('expr', '-1/rho(pA,T)*d(rho(pA,T),T)');
model.component('comp1').material('mat1').propertyGroup('def').func('an1').set('args', {'pA' 'T'});
model.component('comp1').material('mat1').propertyGroup('def').func('an1').set('fununit', '1/K');
model.component('comp1').material('mat1').propertyGroup('def').func('an1').set('argunit', {'Pa' 'K'});
model.component('comp1').material('mat1').propertyGroup('def').func('an1').set('plotaxis', {'off' 'on'});
model.component('comp1').material('mat1').propertyGroup('def').func('an1').set('plotfixedvalue', {'101325' '273.15'});
model.component('comp1').material('mat1').propertyGroup('def').func('an1').set('plotargs', {'pA' '101325' '101325'; 'T' '273.15' '373.15'});
model.component('comp1').material('mat1').propertyGroup('def').func('an2').label('Analytic 2a');
model.component('comp1').material('mat1').propertyGroup('def').func('an2').set('funcname', 'muB');
model.component('comp1').material('mat1').propertyGroup('def').func('an2').set('expr', '0.6*eta(T)');
model.component('comp1').material('mat1').propertyGroup('def').func('an2').set('args', {'T'});
model.component('comp1').material('mat1').propertyGroup('def').func('an2').set('fununit', 'Pa*s');
model.component('comp1').material('mat1').propertyGroup('def').func('an2').set('argunit', {'K'});
model.component('comp1').material('mat1').propertyGroup('def').func('an2').set('plotfixedvalue', {'200'});
model.component('comp1').material('mat1').propertyGroup('def').func('an2').set('plotargs', {'T' '200' '1600'});
model.component('comp1').material('mat1').propertyGroup('def').set('thermalexpansioncoefficient', '');
model.component('comp1').material('mat1').propertyGroup('def').set('molarmass', '');
model.component('comp1').material('mat1').propertyGroup('def').set('bulkviscosity', '');
model.component('comp1').material('mat1').propertyGroup('def').set('thermalexpansioncoefficient', {'alpha_p(pA,T)' '0' '0' '0' 'alpha_p(pA,T)' '0' '0' '0' 'alpha_p(pA,T)'});
model.component('comp1').material('mat1').propertyGroup('def').set('molarmass', '0.02897[kg/mol]');
model.component('comp1').material('mat1').propertyGroup('def').set('bulkviscosity', 'muB(T)');
model.component('comp1').material('mat1').propertyGroup('def').set('relpermeability', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.component('comp1').material('mat1').propertyGroup('def').set('relpermittivity', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.component('comp1').material('mat1').propertyGroup('def').set('dynamicviscosity', 'eta(T)');
model.component('comp1').material('mat1').propertyGroup('def').set('ratioofspecificheat', '1.4');
model.component('comp1').material('mat1').propertyGroup('def').set('electricconductivity', {'0[S/m]' '0' '0' '0' '0[S/m]' '0' '0' '0' '0[S/m]'});
model.component('comp1').material('mat1').propertyGroup('def').set('heatcapacity', 'Cp(T)');
model.component('comp1').material('mat1').propertyGroup('def').set('density', 'rho(pA,T)');
model.component('comp1').material('mat1').propertyGroup('def').set('thermalconductivity', {'k(T)' '0' '0' '0' 'k(T)' '0' '0' '0' 'k(T)'});
model.component('comp1').material('mat1').propertyGroup('def').set('soundspeed', 'cs(T)');
model.component('comp1').material('mat1').propertyGroup('def').addInput('temperature');
model.component('comp1').material('mat1').propertyGroup('def').addInput('pressure');
model.component('comp1').material('mat1').propertyGroup('RefractiveIndex').label('Refractive index');
model.component('comp1').material('mat1').propertyGroup('RefractiveIndex').set('n', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.component('comp1').material('mat1').propertyGroup('NonlinearModel').label('Nonlinear model');
model.component('comp1').material('mat1').propertyGroup('NonlinearModel').set('BA', 'def.gamma-1');
model.component('comp1').material('mat1').propertyGroup('idealGas').label('Ideal gas');
model.component('comp1').material('mat1').propertyGroup('idealGas').func('Cp').label('Piecewise 2');
model.component('comp1').material('mat1').propertyGroup('idealGas').func('Cp').set('arg', 'T');
model.component('comp1').material('mat1').propertyGroup('idealGas').func('Cp').set('pieces', {'200.0' '1600.0' '1047.63657-0.372589265*T^1+9.45304214E-4*T^2-6.02409443E-7*T^3+1.2858961E-10*T^4'});
model.component('comp1').material('mat1').propertyGroup('idealGas').func('Cp').set('argunit', 'K');
model.component('comp1').material('mat1').propertyGroup('idealGas').func('Cp').set('fununit', 'J/(kg*K)');
model.component('comp1').material('mat1').propertyGroup('idealGas').set('Rs', 'R_const/Mn');
model.component('comp1').material('mat1').propertyGroup('idealGas').set('heatcapacity', 'Cp(T)');
model.component('comp1').material('mat1').propertyGroup('idealGas').set('ratioofspecificheat', '1.4');
model.component('comp1').material('mat1').propertyGroup('idealGas').set('molarmass', '0.02897[kg/mol]');
model.component('comp1').material('mat1').propertyGroup('idealGas').addInput('temperature');
model.component('comp1').material('mat1').propertyGroup('idealGas').addInput('pressure');
model.component('comp1').material('mat1').materialType('nonSolid');

model.component('comp1').coordSystem('pml1').set('PMLfactor', '3');

model.component('comp1').physics('acpr').prop('MeshControl').set('SizeControlParameter', 'Frequency');
model.component('comp1').physics('acpr').prop('MeshControl').set('PhysicsControlledMeshMaximumFrequency', '3000[Hz]');
model.component('comp1').physics('acpr').feature('pc1').set('PeriodicType', 'Floquet');
model.component('comp1').physics('acpr').feature('pc1').set('kFloquet', {'0'; '0'; 'm*G'});
model.component('comp1').physics('acpr').feature('pc1').active(false);
model.component('comp1').physics('acpr').feature('bpf1').set('p', 'p10');
model.component('comp1').physics('acpr').feature('bpf1').set('PressureFieldType', 'UserDefined');
model.component('comp1').physics('acpr').feature('bpf1').active(false);

model.component('comp1').mesh('mesh1').feature('size').set('hauto', 3);
model.component('comp1').mesh('mesh1').feature('size').set('custom', 'on');
model.component('comp1').mesh('mesh1').feature('size').set('hmax', '0.036920');
model.component('comp1').mesh('mesh1').feature('size').set('hmin', '0.0022430');
model.component('comp1').mesh('mesh1').feature('size1').set('hauto', 3);
model.component('comp1').mesh('mesh1').feature('size1').set('custom', 'on');
model.component('comp1').mesh('mesh1').feature('size1').set('hmax', '0.036920');
model.component('comp1').mesh('mesh1').feature('size1').set('hmaxactive', true);
model.component('comp1').mesh('mesh1').feature('size1').set('hmin', '9.0000E-6');
model.component('comp1').mesh('mesh1').feature('size1').set('hminactive', true);
model.component('comp1').mesh('mesh1').feature('size2').set('hauto', 3);
model.component('comp1').mesh('mesh1').feature('size2').set('custom', 'on');
model.component('comp1').mesh('mesh1').feature('size2').set('hmax', '0.011530');
model.component('comp1').mesh('mesh1').feature('size2').set('hmaxactive', true);
model.component('comp1').mesh('mesh1').feature('size2').set('hmin', '3.4590E-4');
model.component('comp1').mesh('mesh1').feature('size2').set('hminactive', true);

model.sol.create('sol1');

model.component('comp1').mesh('mesh1').feature('se1').set('evaltype', 'initialexpression');
model.component('comp1').mesh('mesh1').feature('se1').set('sizeexpr', 'subst(real(acpr.c_c),acpr.freq,acpr.freqmax)/acpr.freqmax/5');
model.component('comp1').mesh('mesh1').feature('dis1').set('type', 'predefined');
model.component('comp1').mesh('mesh1').feature('dis1').set('elemcount', 8);
model.component('comp1').mesh('mesh1').feature('swe1').feature('dis1').set('numelem', 8);

model.study.create('std1');
model.study('std1').create('eig', 'Eigenfrequency');

model.sol('sol1').attach('std1');
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').create('e1', 'Eigenvalue');
model.sol('sol1').feature('e1').create('d1', 'Direct');
model.sol('sol1').feature('e1').create('i1', 'Iterative');
model.sol('sol1').feature('e1').create('i2', 'Iterative');
model.sol('sol1').feature('e1').feature('i1').create('mg1', 'Multigrid');
model.sol('sol1').feature('e1').feature('i2').create('mg1', 'Multigrid');

model.result.create('pg1', 'PlotGroup3D');
model.result('pg1').create('surf1', 'Surface');

model.study('std1').feature('eig').set('neigs', 30);
model.study('std1').feature('eig').set('neigsactive', true);
model.study('std1').feature('eig').set('eigunit', 'kHz');
model.study('std1').feature('eig').set('shift', '3');
model.study('std1').feature('eig').set('ftplistmethod', 'manual');

model.sol('sol1').feature('st1').label([native2unicode(hex2dec({'7f' '16'}), 'unicode')  native2unicode(hex2dec({'8b' 'd1'}), 'unicode')  native2unicode(hex2dec({'65' 'b9'}), 'unicode')  native2unicode(hex2dec({'7a' '0b'}), 'unicode') ': ' native2unicode(hex2dec({'72' '79'}), 'unicode')  native2unicode(hex2dec({'5f' '81'}), 'unicode')  native2unicode(hex2dec({'98' '91'}), 'unicode')  native2unicode(hex2dec({'73' '87'}), 'unicode') ]);
model.sol('sol1').feature('v1').label([native2unicode(hex2dec({'56' 'e0'}), 'unicode')  native2unicode(hex2dec({'53' 'd8'}), 'unicode')  native2unicode(hex2dec({'91' 'cf'}), 'unicode') ' 1.1']);
model.sol('sol1').feature('e1').label([native2unicode(hex2dec({'72' '79'}), 'unicode')  native2unicode(hex2dec({'5f' '81'}), 'unicode')  native2unicode(hex2dec({'50' '3c'}), 'unicode')  native2unicode(hex2dec({'6c' '42'}), 'unicode')  native2unicode(hex2dec({'89' 'e3'}), 'unicode')  native2unicode(hex2dec({'56' '68'}), 'unicode') ' 1.1']);
model.sol('sol1').feature('e1').set('neigs', 30);
model.sol('sol1').feature('e1').set('eigunit', 'kHz');
model.sol('sol1').feature('e1').set('shift', '3');
model.sol('sol1').feature('e1').set('eigref', '100');
model.sol('sol1').feature('e1').set('filtereigexpression', {'real(freq)+1e-6>0'});
model.sol('sol1').feature('e1').set('filtereigdescription', {[native2unicode(hex2dec({'96' '3b'}), 'unicode')  native2unicode(hex2dec({'5c' '3c'}), 'unicode')  native2unicode(hex2dec({'56' 'fa'}), 'unicode')  native2unicode(hex2dec({'67' '09'}), 'unicode')  native2unicode(hex2dec({'98' '91'}), 'unicode')  native2unicode(hex2dec({'73' '87'}), 'unicode') ]});
model.sol('sol1').feature('e1').feature('dDef').label([native2unicode(hex2dec({'76' 'f4'}), 'unicode')  native2unicode(hex2dec({'63' 'a5'}), 'unicode') ' 2']);
model.sol('sol1').feature('e1').feature('aDef').label([native2unicode(hex2dec({'9a' 'd8'}), 'unicode')  native2unicode(hex2dec({'7e' 'a7'}), 'unicode') ' 1']);
model.sol('sol1').feature('e1').feature('aDef').set('cachepattern', true);
model.sol('sol1').feature('e1').feature('aDef').set('complexfun', true);
model.sol('sol1').feature('e1').feature('d1').active(true);
model.sol('sol1').feature('e1').feature('d1').label('Suggested Direct Solver (acpr)');
model.sol('sol1').feature('e1').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('e1').feature('i1').label('Suggested Iterative Solver (GMRES with GMG) (acpr)');
model.sol('sol1').feature('e1').feature('i1').feature('ilDef').label([native2unicode(hex2dec({'4e' '0d'}), 'unicode')  native2unicode(hex2dec({'5b' '8c'}), 'unicode')  native2unicode(hex2dec({'51' '68'}), 'unicode') ' LU ' native2unicode(hex2dec({'52' '06'}), 'unicode')  native2unicode(hex2dec({'89' 'e3'}), 'unicode') ' 1']);
model.sol('sol1').feature('e1').feature('i1').feature('mg1').label([native2unicode(hex2dec({'59' '1a'}), 'unicode')  native2unicode(hex2dec({'91' 'cd'}), 'unicode')  native2unicode(hex2dec({'7f' '51'}), 'unicode')  native2unicode(hex2dec({'68' '3c'}), 'unicode') ' 1.1']);
model.sol('sol1').feature('e1').feature('i1').feature('mg1').feature('pr').label([native2unicode(hex2dec({'98' '84'}), 'unicode')  native2unicode(hex2dec({'5e' '73'}), 'unicode')  native2unicode(hex2dec({'6e' 'd1'}), 'unicode')  native2unicode(hex2dec({'56' '68'}), 'unicode') ' 1']);
model.sol('sol1').feature('e1').feature('i1').feature('mg1').feature('pr').feature('soDef').label('SOR 1');
model.sol('sol1').feature('e1').feature('i1').feature('mg1').feature('po').label([native2unicode(hex2dec({'54' '0e'}), 'unicode')  native2unicode(hex2dec({'5e' '73'}), 'unicode')  native2unicode(hex2dec({'6e' 'd1'}), 'unicode')  native2unicode(hex2dec({'56' '68'}), 'unicode') ' 1']);
model.sol('sol1').feature('e1').feature('i1').feature('mg1').feature('po').feature('soDef').label('SOR 1');
model.sol('sol1').feature('e1').feature('i1').feature('mg1').feature('cs').label([native2unicode(hex2dec({'7c' '97'}), 'unicode')  native2unicode(hex2dec({'53' '16'}), 'unicode')  native2unicode(hex2dec({'6c' '42'}), 'unicode')  native2unicode(hex2dec({'89' 'e3'}), 'unicode')  native2unicode(hex2dec({'56' '68'}), 'unicode') ' 1']);
model.sol('sol1').feature('e1').feature('i1').feature('mg1').feature('cs').feature('dDef').label([native2unicode(hex2dec({'76' 'f4'}), 'unicode')  native2unicode(hex2dec({'63' 'a5'}), 'unicode') ' 1']);
model.sol('sol1').feature('e1').feature('i2').label('Suggested Iterative Solver (FGMRES with GMG) (acpr)');
model.sol('sol1').feature('e1').feature('i2').set('linsolver', 'fgmres');
model.sol('sol1').feature('e1').feature('i2').feature('ilDef').label([native2unicode(hex2dec({'4e' '0d'}), 'unicode')  native2unicode(hex2dec({'5b' '8c'}), 'unicode')  native2unicode(hex2dec({'51' '68'}), 'unicode') ' LU ' native2unicode(hex2dec({'52' '06'}), 'unicode')  native2unicode(hex2dec({'89' 'e3'}), 'unicode') ' 1']);
model.sol('sol1').feature('e1').feature('i2').feature('mg1').label([native2unicode(hex2dec({'59' '1a'}), 'unicode')  native2unicode(hex2dec({'91' 'cd'}), 'unicode')  native2unicode(hex2dec({'7f' '51'}), 'unicode')  native2unicode(hex2dec({'68' '3c'}), 'unicode') ' 1.1']);
model.sol('sol1').feature('e1').feature('i2').feature('mg1').feature('pr').label([native2unicode(hex2dec({'98' '84'}), 'unicode')  native2unicode(hex2dec({'5e' '73'}), 'unicode')  native2unicode(hex2dec({'6e' 'd1'}), 'unicode')  native2unicode(hex2dec({'56' '68'}), 'unicode') ' 1']);
model.sol('sol1').feature('e1').feature('i2').feature('mg1').feature('pr').feature('soDef').label('SOR 1');
model.sol('sol1').feature('e1').feature('i2').feature('mg1').feature('po').label([native2unicode(hex2dec({'54' '0e'}), 'unicode')  native2unicode(hex2dec({'5e' '73'}), 'unicode')  native2unicode(hex2dec({'6e' 'd1'}), 'unicode')  native2unicode(hex2dec({'56' '68'}), 'unicode') ' 1']);
model.sol('sol1').feature('e1').feature('i2').feature('mg1').feature('po').feature('soDef').label('SOR 1');
model.sol('sol1').feature('e1').feature('i2').feature('mg1').feature('cs').label([native2unicode(hex2dec({'7c' '97'}), 'unicode')  native2unicode(hex2dec({'53' '16'}), 'unicode')  native2unicode(hex2dec({'6c' '42'}), 'unicode')  native2unicode(hex2dec({'89' 'e3'}), 'unicode')  native2unicode(hex2dec({'56' '68'}), 'unicode') ' 1']);
model.sol('sol1').feature('e1').feature('i2').feature('mg1').feature('cs').feature('dDef').label([native2unicode(hex2dec({'76' 'f4'}), 'unicode')  native2unicode(hex2dec({'63' 'a5'}), 'unicode') ' 1']);

model.study('std1').runNoGen;

model.result('pg1').set('looplevel', [18]);
model.result('pg1').feature('surf1').set('resolution', 'normal');

model.label([native2unicode(hex2dec({'53' 'cc'}), 'unicode')  native2unicode(hex2dec({'5c' '42'}), 'unicode')  native2unicode(hex2dec({'7e' 'd3'}), 'unicode')  native2unicode(hex2dec({'67' '84'}), 'unicode')  native2unicode(hex2dec({'97' '5e'}), 'unicode')  native2unicode(hex2dec({'5b' 'f9'}), 'unicode')  native2unicode(hex2dec({'79' 'f0'}), 'unicode')  native2unicode(hex2dec({'6d' '4b'}), 'unicode')  native2unicode(hex2dec({'8b' 'd5'}), 'unicode') '_' native2unicode(hex2dec({'4e' 'ff'}), 'unicode')  native2unicode(hex2dec({'71' '67'}), 'unicode') 'optic.mph']);
model.component.label('Components');
model.label([native2unicode(hex2dec({'53' 'cc'}), 'unicode')  native2unicode(hex2dec({'5c' '42'}), 'unicode')  native2unicode(hex2dec({'7e' 'd3'}), 'unicode')  native2unicode(hex2dec({'67' '84'}), 'unicode')  native2unicode(hex2dec({'97' '5e'}), 'unicode')  native2unicode(hex2dec({'5b' 'f9'}), 'unicode')  native2unicode(hex2dec({'79' 'f0'}), 'unicode')  native2unicode(hex2dec({'6d' '4b'}), 'unicode')  native2unicode(hex2dec({'8b' 'd5'}), 'unicode') '_' native2unicode(hex2dec({'4e' 'ff'}), 'unicode')  native2unicode(hex2dec({'71' '67'}), 'unicode') 'optic.mph']);
model.component.label('Components');
model.label([native2unicode(hex2dec({'53' 'cc'}), 'unicode')  native2unicode(hex2dec({'5c' '42'}), 'unicode')  native2unicode(hex2dec({'7e' 'd3'}), 'unicode')  native2unicode(hex2dec({'67' '84'}), 'unicode')  native2unicode(hex2dec({'97' '5e'}), 'unicode')  native2unicode(hex2dec({'5b' 'f9'}), 'unicode')  native2unicode(hex2dec({'79' 'f0'}), 'unicode')  native2unicode(hex2dec({'6d' '4b'}), 'unicode')  native2unicode(hex2dec({'8b' 'd5'}), 'unicode') '_' native2unicode(hex2dec({'4e' 'ff'}), 'unicode')  native2unicode(hex2dec({'71' '67'}), 'unicode') 'optic.mph']);
model.component.label('Components');
model.label([native2unicode(hex2dec({'53' 'cc'}), 'unicode')  native2unicode(hex2dec({'5c' '42'}), 'unicode')  native2unicode(hex2dec({'7e' 'd3'}), 'unicode')  native2unicode(hex2dec({'67' '84'}), 'unicode')  native2unicode(hex2dec({'97' '5e'}), 'unicode')  native2unicode(hex2dec({'5b' 'f9'}), 'unicode')  native2unicode(hex2dec({'79' 'f0'}), 'unicode')  native2unicode(hex2dec({'6d' '4b'}), 'unicode')  native2unicode(hex2dec({'8b' 'd5'}), 'unicode') '_' native2unicode(hex2dec({'4e' 'ff'}), 'unicode')  native2unicode(hex2dec({'71' '67'}), 'unicode') 'optic_' native2unicode(hex2dec({'5d' 'e6'}), 'unicode')  native2unicode(hex2dec({'53' 'f3'}), 'unicode')  native2unicode(hex2dec({'62' '4b'}), 'unicode')  native2unicode(hex2dec({'60' '27'}), 'unicode')  native2unicode(hex2dec({'76' 'f8'}), 'unicode')  native2unicode(hex2dec({'54' '0c'}), 'unicode') '.mph']);
model.component.label('Components');
model.label([native2unicode(hex2dec({'53' 'cc'}), 'unicode')  native2unicode(hex2dec({'5c' '42'}), 'unicode')  native2unicode(hex2dec({'7e' 'd3'}), 'unicode')  native2unicode(hex2dec({'67' '84'}), 'unicode')  native2unicode(hex2dec({'97' '5e'}), 'unicode')  native2unicode(hex2dec({'5b' 'f9'}), 'unicode')  native2unicode(hex2dec({'79' 'f0'}), 'unicode')  native2unicode(hex2dec({'6d' '4b'}), 'unicode')  native2unicode(hex2dec({'8b' 'd5'}), 'unicode') '_' native2unicode(hex2dec({'4e' 'ff'}), 'unicode')  native2unicode(hex2dec({'71' '67'}), 'unicode') 'optic_' native2unicode(hex2dec({'5d' 'e6'}), 'unicode')  native2unicode(hex2dec({'53' 'f3'}), 'unicode')  native2unicode(hex2dec({'62' '4b'}), 'unicode')  native2unicode(hex2dec({'60' '27'}), 'unicode')  native2unicode(hex2dec({'76' 'f8'}), 'unicode')  native2unicode(hex2dec({'54' '0c'}), 'unicode') '.mph']);
model.component.label('Components');
model.label([native2unicode(hex2dec({'53' 'cc'}), 'unicode')  native2unicode(hex2dec({'5c' '42'}), 'unicode')  native2unicode(hex2dec({'7e' 'd3'}), 'unicode')  native2unicode(hex2dec({'67' '84'}), 'unicode')  native2unicode(hex2dec({'97' '5e'}), 'unicode')  native2unicode(hex2dec({'5b' 'f9'}), 'unicode')  native2unicode(hex2dec({'79' 'f0'}), 'unicode')  native2unicode(hex2dec({'6d' '4b'}), 'unicode')  native2unicode(hex2dec({'8b' 'd5'}), 'unicode') '_' native2unicode(hex2dec({'4e' 'ff'}), 'unicode')  native2unicode(hex2dec({'71' '67'}), 'unicode') 'optic_' native2unicode(hex2dec({'5d' 'e6'}), 'unicode')  native2unicode(hex2dec({'53' 'f3'}), 'unicode')  native2unicode(hex2dec({'62' '4b'}), 'unicode')  native2unicode(hex2dec({'60' '27'}), 'unicode')  native2unicode(hex2dec({'4e' '0d'}), 'unicode')  native2unicode(hex2dec({'54' '0c'}), 'unicode') '.mph']);
model.component.label('Components');
model.label([native2unicode(hex2dec({'53' 'cc'}), 'unicode')  native2unicode(hex2dec({'5c' '42'}), 'unicode')  native2unicode(hex2dec({'7e' 'd3'}), 'unicode')  native2unicode(hex2dec({'67' '84'}), 'unicode')  native2unicode(hex2dec({'97' '5e'}), 'unicode')  native2unicode(hex2dec({'5b' 'f9'}), 'unicode')  native2unicode(hex2dec({'79' 'f0'}), 'unicode')  native2unicode(hex2dec({'6d' '4b'}), 'unicode')  native2unicode(hex2dec({'8b' 'd5'}), 'unicode') '_' native2unicode(hex2dec({'4e' 'ff'}), 'unicode')  native2unicode(hex2dec({'71' '67'}), 'unicode') 'optic_' native2unicode(hex2dec({'5d' 'e6'}), 'unicode')  native2unicode(hex2dec({'53' 'f3'}), 'unicode')  native2unicode(hex2dec({'62' '4b'}), 'unicode')  native2unicode(hex2dec({'60' '27'}), 'unicode')  native2unicode(hex2dec({'4e' '0d'}), 'unicode')  native2unicode(hex2dec({'54' '0c'}), 'unicode') '.mph']);

model.result('pg2').run;

model.param('par5').setFromCase('case5');
model.param('par5').setFromCase('case5');
model.param('par5').setFromCase('case5');

model.component('comp1').geom('geom1').run;

model.study('std1').createAutoSequences('all');

model.sol('sol1').runAll;

model.result('pg2').run;
model.result('pg2').stepFirst(0);
model.result('pg2').run;
model.result('pg2').stepNext(0);
model.result('pg2').run;
model.result('pg2').stepNext(0);
model.result('pg2').run;
model.result('pg2').stepNext(0);
model.result('pg2').run;
model.result('pg2').stepNext(0);
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').feature('surf1').set('rangecolormin', -0.5);
model.result('pg2').feature('surf1').set('rangecolormax', 0.5);
model.result('pg2').run;
model.result('pg2').feature('surf1').stepNext(0);
model.result('pg2').run;
model.result('pg2').feature('surf1').stepNext(0);
model.result('pg2').run;
model.result('pg2').feature('surf1').stepNext(0);
model.result('pg2').run;
model.result('pg2').feature('surf1').stepNext(0);
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').set('looplevel', [2]);
model.result('pg2').run;
model.result('pg2').stepPrevious(0);
model.result('pg2').run;
model.result('pg2').stepNext(0);
model.result('pg2').run;

model.component('comp1').physics('acpr').feature('mps1').selection.set([7]);

model.study('std3').feature('freq').set('plist', 2.6026);
model.study('std3').createAutoSequences('all');

model.sol('sol3').runAll;

model.result('pg5').run;

model.study('std3').feature('freq').set('punit', 'Hz');
model.study('std3').feature('freq').set('plist', 2602.6);

model.component('comp1').physics('acpr').feature('mps1').set('phi', 0);
model.component('comp1').physics('acpr').feature('mps1').set('P_rms', '1e-4');

model.study('std3').createAutoSequences('all');

model.sol('sol3').runAll;

model.result('pg5').run;
model.result('pg5').run;
model.result('pg5').feature('surf1').set('rangecolormin', -50);
model.result('pg5').feature('surf1').set('rangecolormax', 0);
model.result('pg5').feature('surf1').set('rangecolormin', -10);
model.result('pg5').feature('surf1').set('rangecolormax', 10);
model.result('pg5').run;

model.component('comp1').physics('acpr').feature('mps1').selection.set([101]);

model.study('std3').createAutoSequences('all');

model.sol('sol3').runAll;

model.result('pg5').run;

model.component('comp1').physics('acpr').feature('mps1').selection.set([82]);

model.study('std3').createAutoSequences('all');

model.sol('sol3').runAll;

model.result('pg5').run;
model.result('pg5').run;

model.study('std3').feature('freq').set('plist', 2602);
model.study('std3').createAutoSequences('all');

model.sol('sol3').runAll;

model.result('pg5').run;

model.component('comp1').mesh('mesh1').automatic(true);
model.component('comp1').mesh('mesh1').autoMeshSize(1);
model.component('comp1').mesh('mesh1').run;

model.study('std3').createAutoSequences('all');

model.sol('sol3').runAll;

model.result('pg5').run;

model.param('par5').setFromCase('case6');

model.study('std1').createAutoSequences('all');

model.param('par5').setFromCase('case5');
model.param('par4').setFromCase('case5');

model.component('comp1').geom('geom1').run;

model.component('comp1').physics('acpr').feature('bpf1').active(true);

model.study.create('std5');
model.study('std5').create('freq', 'Frequency');
model.study('std5').feature('freq').setSolveFor('/physics/acpr', true);
model.study('std5').feature('freq').set('plist', 2602.6);
model.study('std5').showAutoSequences('all');

model.sol('sol5').feature('s1').feature('d1').set('linsolver', 'pardiso');

model.study('std5').createAutoSequences('all');

model.sol('sol5').runAll;

model.result.create('pg9', 'PlotGroup3D');
model.result('pg9').set('data', 'dset5');
model.result('pg9').setIndex('looplevel', 1, 0);
model.result('pg9').create('surf1', 'Surface');
model.result('pg9').feature('surf1').set('expr', {'acpr.p_t'});
model.result('pg9').feature('surf1').set('colortable', 'Wave');
model.result('pg9').feature('surf1').set('colorscalemode', 'linearsymmetric');
model.result('pg9').set('showlegendsunit', true);
model.result('pg9').label([native2unicode(hex2dec({'58' 'f0'}), 'unicode')  native2unicode(hex2dec({'53' '8b'}), 'unicode') ' (acpr) 3']);
model.result.create('pg10', 'PlotGroup3D');
model.result('pg10').set('data', 'dset5');
model.result('pg10').setIndex('looplevel', 1, 0);
model.result('pg10').create('surf1', 'Surface');
model.result('pg10').feature('surf1').set('expr', {'acpr.Lp_t'});
model.result('pg10').feature('surf1').set('colortable', 'Rainbow');
model.result('pg10').feature('surf1').set('colorscalemode', 'linear');
model.result('pg10').set('showlegendsunit', true);
model.result('pg10').label([native2unicode(hex2dec({'58' 'f0'}), 'unicode')  native2unicode(hex2dec({'53' '8b'}), 'unicode')  native2unicode(hex2dec({'7e' 'a7'}), 'unicode') ' (acpr) 1']);
model.result.create('pg11', 'PlotGroup3D');
model.result('pg11').set('data', 'dset5');
model.result('pg11').setIndex('looplevel', 1, 0);
model.result('pg11').create('iso1', 'Isosurface');
model.result('pg11').feature('iso1').set('expr', {'acpr.p_t'});
model.result('pg11').feature('iso1').set('number', '10');
model.result('pg11').feature('iso1').set('colortable', 'Wave');
model.result('pg11').feature('iso1').set('colorscalemode', 'linearsymmetric');
model.result('pg11').set('showlegendsunit', true);
model.result('pg11').label([native2unicode(hex2dec({'58' 'f0'}), 'unicode')  native2unicode(hex2dec({'53' '8b'}), 'unicode')  native2unicode(hex2dec({'ff' '0c'}), 'unicode')  native2unicode(hex2dec({'7b' '49'}), 'unicode')  native2unicode(hex2dec({'50' '3c'}), 'unicode')  native2unicode(hex2dec({'97' '62'}), 'unicode') ' (acpr) 1']);
model.result('pg9').run;
model.result('pg9').run;
model.result.remove('pg9');
model.result.remove('pg10');
model.result.remove('pg11');
model.result('pg5').run;
model.result('pg5').set('data', 'dset5');
model.result('pg5').run;
model.result('pg5').run;
model.result('pg5').feature('surf1').set('expr', 'acpr.p_b');
model.result('pg5').run;
model.result('pg5').feature('surf1').set('rangecoloractive', false);
model.result('pg5').feature('surf1').set('expr', 'acpr.p_s');
model.result('pg5').run;
model.result('pg5').feature('surf1').set('rangecoloractive', true);

model.study('std5').feature('freq').set('useadvanceddisable', true);
model.study('std5').feature('freq').set('disabledphysics', {'acpr/pr1' 'acpr/mps1'});
model.study('std5').createAutoSequences('all');

model.sol('sol5').runAll;

model.result('pg5').run;
model.result('pg5').run;
model.result('pg5').feature('surf1').set('rangecoloractive', false);

model.nodeGroup('grp2').active(false);
model.nodeGroup('grp1').active(false);

model.study('std5').createAutoSequences('all');

model.sol('sol5').runAll;

model.result('pg5').run;
model.result('pg6').run;
model.result('pg5').run;
model.result('pg5').run;
model.result('pg5').run;

model.component('comp1').variable('var1').set('p_10', 'besselj(1,k10*r)*exp(-1i*1*th)*exp(-1i*kz*z)');

model.component('comp1').physics('acpr').feature('bpf1').set('p', 'p_10');

model.study('std5').createAutoSequences('all');

model.sol('sol5').runAll;

model.result('pg5').run;
model.result('pg5').run;
model.result('pg5').feature('surf1').set('rangecoloractive', true);
model.result('pg5').feature('surf1').set('rangecolormin', -2.5);
model.result('pg5').feature('surf1').set('rangecolormax', 0.5);
model.result('pg5').feature('surf1').set('rangecolormin', -0.5);

model.label([native2unicode(hex2dec({'53' 'cc'}), 'unicode')  native2unicode(hex2dec({'5c' '42'}), 'unicode')  native2unicode(hex2dec({'7e' 'd3'}), 'unicode')  native2unicode(hex2dec({'67' '84'}), 'unicode')  native2unicode(hex2dec({'97' '5e'}), 'unicode')  native2unicode(hex2dec({'5b' 'f9'}), 'unicode')  native2unicode(hex2dec({'79' 'f0'}), 'unicode')  native2unicode(hex2dec({'6d' '4b'}), 'unicode')  native2unicode(hex2dec({'8b' 'd5'}), 'unicode') '_' native2unicode(hex2dec({'4e' 'ff'}), 'unicode')  native2unicode(hex2dec({'71' '67'}), 'unicode') 'optic_' native2unicode(hex2dec({'5d' 'e6'}), 'unicode')  native2unicode(hex2dec({'53' 'f3'}), 'unicode')  native2unicode(hex2dec({'62' '4b'}), 'unicode')  native2unicode(hex2dec({'60' '27'}), 'unicode')  native2unicode(hex2dec({'4e' '0d'}), 'unicode')  native2unicode(hex2dec({'54' '0c'}), 'unicode') '.mph']);
model.component.label('Components');
model.label([native2unicode(hex2dec({'53' 'cc'}), 'unicode')  native2unicode(hex2dec({'5c' '42'}), 'unicode')  native2unicode(hex2dec({'7e' 'd3'}), 'unicode')  native2unicode(hex2dec({'67' '84'}), 'unicode')  native2unicode(hex2dec({'97' '5e'}), 'unicode')  native2unicode(hex2dec({'5b' 'f9'}), 'unicode')  native2unicode(hex2dec({'79' 'f0'}), 'unicode')  native2unicode(hex2dec({'6d' '4b'}), 'unicode')  native2unicode(hex2dec({'8b' 'd5'}), 'unicode') '_' native2unicode(hex2dec({'4e' 'ff'}), 'unicode')  native2unicode(hex2dec({'71' '67'}), 'unicode') 'optic_' native2unicode(hex2dec({'5d' 'e6'}), 'unicode')  native2unicode(hex2dec({'53' 'f3'}), 'unicode')  native2unicode(hex2dec({'62' '4b'}), 'unicode')  native2unicode(hex2dec({'60' '27'}), 'unicode')  native2unicode(hex2dec({'76' 'f8'}), 'unicode')  native2unicode(hex2dec({'54' '0c'}), 'unicode') '.mph']);
model.component.label('Components');
model.label([native2unicode(hex2dec({'53' 'cc'}), 'unicode')  native2unicode(hex2dec({'5c' '42'}), 'unicode')  native2unicode(hex2dec({'7e' 'd3'}), 'unicode')  native2unicode(hex2dec({'67' '84'}), 'unicode')  native2unicode(hex2dec({'97' '5e'}), 'unicode')  native2unicode(hex2dec({'5b' 'f9'}), 'unicode')  native2unicode(hex2dec({'79' 'f0'}), 'unicode')  native2unicode(hex2dec({'6d' '4b'}), 'unicode')  native2unicode(hex2dec({'8b' 'd5'}), 'unicode') '_' native2unicode(hex2dec({'4e' 'ff'}), 'unicode')  native2unicode(hex2dec({'71' '67'}), 'unicode') 'optic_' native2unicode(hex2dec({'5d' 'e6'}), 'unicode')  native2unicode(hex2dec({'53' 'f3'}), 'unicode')  native2unicode(hex2dec({'62' '4b'}), 'unicode')  native2unicode(hex2dec({'60' '27'}), 'unicode')  native2unicode(hex2dec({'76' 'f8'}), 'unicode')  native2unicode(hex2dec({'54' '0c'}), 'unicode') '_CPA.mph']);

model.component('comp1').probe('point2').set('probename', 'p2');
model.component('comp1').probe('point3').set('probename', 'p3');
model.component('comp1').probe('point4').set('probename', 'p4');
model.component('comp1').probe.duplicate('point5', 'point4');
model.component('comp1').probe.duplicate('point6', 'point5');
model.component('comp1').probe.duplicate('point7', 'point6');
model.component('comp1').probe.duplicate('point8', 'point7');
model.component('comp1').probe('point5').set('probename', 'p5');
model.component('comp1').probe('point6').set('probename', 'p6');
model.component('comp1').probe('point7').set('probename', 'p7');
model.component('comp1').probe('point8').set('probename', 'p8');
model.component('comp1').probe('point5').selection.set([18]);
model.component('comp1').probe('point6').selection.set([70]);
model.component('comp1').probe('point7').selection.set([108]);
model.component('comp1').probe('point8').selection.set([58]);
model.component('comp1').probe.duplicate('point9', 'point8');
model.component('comp1').probe.duplicate('point10', 'point9');
model.component('comp1').probe.duplicate('point11', 'point10');
model.component('comp1').probe.duplicate('point12', 'point11');
model.component('comp1').probe.duplicate('point13', 'point12');
model.component('comp1').probe.duplicate('point14', 'point13');
model.component('comp1').probe.duplicate('point15', 'point14');
model.component('comp1').probe.duplicate('point16', 'point15');
model.component('comp1').probe('point9').set('probename', 'ph1');
model.component('comp1').probe('point9').selection.set([13]);
model.component('comp1').probe('point9').set('expr', 'arg(acpr.p_s)');

model.label([native2unicode(hex2dec({'53' 'cc'}), 'unicode')  native2unicode(hex2dec({'5c' '42'}), 'unicode')  native2unicode(hex2dec({'7e' 'd3'}), 'unicode')  native2unicode(hex2dec({'67' '84'}), 'unicode')  native2unicode(hex2dec({'97' '5e'}), 'unicode')  native2unicode(hex2dec({'5b' 'f9'}), 'unicode')  native2unicode(hex2dec({'79' 'f0'}), 'unicode')  native2unicode(hex2dec({'6d' '4b'}), 'unicode')  native2unicode(hex2dec({'8b' 'd5'}), 'unicode') '_' native2unicode(hex2dec({'4e' 'ff'}), 'unicode')  native2unicode(hex2dec({'71' '67'}), 'unicode') 'optic_' native2unicode(hex2dec({'5d' 'e6'}), 'unicode')  native2unicode(hex2dec({'53' 'f3'}), 'unicode')  native2unicode(hex2dec({'62' '4b'}), 'unicode')  native2unicode(hex2dec({'60' '27'}), 'unicode')  native2unicode(hex2dec({'76' 'f8'}), 'unicode')  native2unicode(hex2dec({'54' '0c'}), 'unicode') '_CPA.mph']);
model.component.label('Components');
model.label([native2unicode(hex2dec({'53' 'cc'}), 'unicode')  native2unicode(hex2dec({'5c' '42'}), 'unicode')  native2unicode(hex2dec({'7e' 'd3'}), 'unicode')  native2unicode(hex2dec({'67' '84'}), 'unicode')  native2unicode(hex2dec({'97' '5e'}), 'unicode')  native2unicode(hex2dec({'5b' 'f9'}), 'unicode')  native2unicode(hex2dec({'79' 'f0'}), 'unicode')  native2unicode(hex2dec({'6d' '4b'}), 'unicode')  native2unicode(hex2dec({'8b' 'd5'}), 'unicode') '_' native2unicode(hex2dec({'4e' 'ff'}), 'unicode')  native2unicode(hex2dec({'71' '67'}), 'unicode') 'optic_' native2unicode(hex2dec({'5d' 'e6'}), 'unicode')  native2unicode(hex2dec({'53' 'f3'}), 'unicode')  native2unicode(hex2dec({'62' '4b'}), 'unicode')  native2unicode(hex2dec({'60' '27'}), 'unicode')  native2unicode(hex2dec({'76' 'f8'}), 'unicode')  native2unicode(hex2dec({'54' '0c'}), 'unicode') '_CPA.mph']);

model.param('default').paramCase.create('case7');
model.param('default').paramCase('case7').set('rotat', '-2.1082[rad]');
model.param('par5').paramCase.create('case10');
model.param('par5').paramCase('case10').set('th1_n', '0.59403');
model.param('par5').paramCase('case10').set('r1n', '0.83175');
model.param('par5').paramCase('case10').set('z1_n', '0.15794');
model.param('par5').paramCase('case10').set('th2_n', '0.091027');
model.param('par5').paramCase('case10').set('r2n', '0.94601');
model.param('par5').paramCase('case10').set('z2_n', '0.98627');
model.param('par5').setFromCase('case6');

model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol518').runAll;

model.result('pg30').run;
model.result.numerical('gev2').set('data', 'dset14');
model.result.numerical('gev2').set('table', 'tbl16');
model.result.numerical('gev2').appendResult;

model.param('par5').setFromCase('case7');

model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol518').runAll;

model.result('pg30').run;
model.result.numerical('gev2').set('table', 'tbl16');
model.result.numerical('gev2').appendResult;

model.param('par5').setFromCase('case8');

model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol518').runAll;

model.result('pg30').run;
model.result.numerical('gev2').set('table', 'tbl16');
model.result.numerical('gev2').appendResult;

model.param('par5').setFromCase('case9');

model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol518').runAll;

model.result('pg30').run;
model.result.numerical('gev2').set('table', 'tbl16');
model.result.numerical('gev2').appendResult;

model.param('par5').setFromCase('case10');

model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol518').runAll;

model.result('pg30').run;

model.study('std7').feature('opt').set('nsolvemax', 100000);
model.study('std7').feature('opt').set('opttol', '0.000001');
model.study('std7').feature('opt').set('objectivesolution', 'auto');
model.study('std7').feature('opt').setIndex('initval', 0.59403, 0);
model.study('std7').feature('opt').setIndex('initval', 0.091027, 1);
model.study('std7').feature('opt').setIndex('initval', 0.83175, 2);
model.study('std7').feature('opt').setIndex('initval', 0.94601, 3);
model.study('std7').feature('opt').setIndex('initval', 0.15794, 4);
model.study('std7').feature('opt').setIndex('initval', 0.98627, 5);
model.study('std7').feature('opt').setIndex('initval', '-2.1082[rad]', 6);
model.study('std7').feature('opt').set('optmethod', 'ipopt');
model.study('std7').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol519').runAll;

model.result.numerical('gev2').set('table', 'tbl16');
model.result.numerical('gev2').appendResult;
model.result.numerical('gev2').set('data', 'dset16');
model.result.numerical('gev2').set('table', 'tbl16');
model.result.numerical('gev2').appendResult;

model.study('std7').feature('opt').set('optmethod', 'lm');
model.study('std7').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.study('std7').feature('opt').set('probewindow', '');

model.sol.remove('sol519');
model.sol.remove('sol520');
model.sol.remove('sol521');
model.sol.remove('sol522');
model.sol.remove('sol523');
model.sol.remove('sol524');
model.sol.remove('sol525');
model.sol.remove('sol526');
model.sol.remove('sol527');
model.sol.remove('sol528');
model.sol.remove('sol529');
model.sol.remove('sol530');
model.sol.remove('sol531');
model.sol.remove('sol532');
model.sol.remove('sol533');
model.sol.remove('sol534');
model.sol.remove('sol535');
model.sol.remove('sol536');
model.sol.remove('sol537');
model.sol.remove('sol538');
model.sol.remove('sol539');
model.sol.remove('sol540');
model.sol.remove('sol541');
model.sol.remove('sol542');
model.sol.remove('sol543');
model.sol.remove('sol544');
model.sol.remove('sol545');
model.sol.remove('sol546');
model.sol.remove('sol547');
model.sol.remove('sol548');
model.sol.remove('sol549');
model.sol.remove('sol550');
model.sol.remove('sol551');
model.sol.remove('sol552');
model.sol.remove('sol553');
model.sol.remove('sol554');
model.sol.remove('sol555');
model.sol.remove('sol556');
model.sol.remove('sol557');
model.sol.remove('sol558');
model.sol.remove('sol559');
model.sol.remove('sol560');
model.sol.remove('sol561');
model.sol.remove('sol562');
model.sol.remove('sol563');
model.sol.remove('sol564');
model.sol.remove('sol565');
model.sol.remove('sol566');
model.sol.remove('sol567');
model.sol.remove('sol568');
model.sol.remove('sol569');
model.sol.remove('sol570');
model.sol.remove('sol571');
model.sol.remove('sol572');
model.sol.remove('sol573');
model.sol.remove('sol574');
model.sol.remove('sol575');
model.sol.remove('sol576');
model.sol.remove('sol577');
model.sol.remove('sol578');
model.sol.remove('sol579');
model.sol.remove('sol580');
model.sol.remove('sol581');
model.sol.remove('sol582');
model.sol.remove('sol583');
model.sol.remove('sol584');
model.sol.remove('sol585');
model.sol.remove('sol586');
model.sol.remove('sol587');
model.sol.remove('sol588');
model.sol.remove('sol589');
model.sol.remove('sol590');
model.sol.remove('sol591');
model.sol.remove('sol592');
model.sol.remove('sol593');
model.sol.remove('sol594');
model.sol.remove('sol595');
model.sol.remove('sol596');
model.sol.remove('sol597');
model.sol.remove('sol598');
model.sol.remove('sol599');
model.sol.remove('sol600');
model.sol.remove('sol601');
model.sol.remove('sol602');
model.sol.remove('sol603');
model.sol.remove('sol604');
model.sol.remove('sol605');
model.sol.remove('sol606');
model.sol.remove('sol607');
model.sol.remove('sol608');
model.sol.remove('sol609');
model.sol.remove('sol610');
model.sol.remove('sol611');
model.sol.remove('sol612');
model.sol.remove('sol613');
model.sol.remove('sol614');
model.sol.remove('sol615');
model.sol.remove('sol616');
model.sol.remove('sol617');
model.sol.remove('sol618');
model.sol.remove('sol619');
model.sol.remove('sol620');
model.sol.remove('sol621');
model.sol.remove('sol622');
model.sol.remove('sol623');
model.sol.remove('sol624');
model.sol.remove('sol625');
model.sol.remove('sol626');
model.sol.remove('sol627');
model.sol.remove('sol628');
model.sol.remove('sol629');
model.sol.remove('sol630');
model.sol.remove('sol631');
model.sol.remove('sol632');
model.sol.remove('sol633');
model.sol.remove('sol634');
model.sol.remove('sol635');
model.sol.remove('sol636');
model.sol.remove('sol637');
model.sol.remove('sol638');
model.sol.remove('sol639');
model.sol.remove('sol640');
model.sol.remove('sol641');
model.sol.remove('sol642');
model.sol.remove('sol643');
model.sol.remove('sol644');
model.sol.remove('sol645');
model.sol.remove('sol646');
model.sol.remove('sol647');
model.sol.remove('sol648');
model.sol.remove('sol649');
model.sol.remove('sol650');
model.sol.remove('sol651');
model.sol.remove('sol652');
model.sol.remove('sol653');
model.sol.remove('sol654');
model.sol.remove('sol655');
model.sol.remove('sol656');
model.sol.remove('sol657');
model.sol.remove('sol658');
model.sol.remove('sol659');
model.sol.remove('sol660');
model.sol.remove('sol661');
model.sol.remove('sol662');
model.sol.remove('sol663');
model.sol.remove('sol664');
model.sol.remove('sol665');
model.sol.remove('sol666');
model.sol.remove('sol667');
model.sol.remove('sol668');
model.sol.remove('sol669');
model.sol.remove('sol670');
model.sol.remove('sol671');
model.sol.remove('sol672');
model.sol.remove('sol673');
model.sol.remove('sol674');
model.sol.remove('sol675');
model.sol.remove('sol676');
model.sol.remove('sol677');
model.sol.remove('sol678');
model.sol.remove('sol679');
model.sol.remove('sol680');
model.sol.remove('sol681');
model.sol.remove('sol682');
model.sol.remove('sol683');
model.sol.remove('sol684');
model.sol.remove('sol685');
model.sol.remove('sol686');
model.sol.remove('sol687');
model.sol.remove('sol688');
model.sol.remove('sol689');
model.sol.remove('sol690');
model.sol.remove('sol691');
model.sol.remove('sol692');
model.sol.remove('sol693');
model.sol.remove('sol694');
model.sol.remove('sol695');

model.study('std7').showAutoSequences('all');

model.sol.remove('sol519');

model.study('std7').feature('opt').set('optmethod', 'neldermead');
model.study('std7').feature('opt').set('objectivesolution', 'min');
model.study('std7').feature('opt').set('objtable', 'new');
model.study('std7').showAutoSequences('all');

model.sol('sol519').feature('s1').feature('d1').set('linsolver', 'pardiso');

model.study('std7').createAutoSequences('all');

model.sol.create('sol520');
model.sol('sol520').study('std7');
model.sol('sol520').label([native2unicode(hex2dec({'53' 'c2'}), 'unicode')  native2unicode(hex2dec({'65' '70'}), 'unicode')  native2unicode(hex2dec({'53' '16'}), 'unicode')  native2unicode(hex2dec({'89' 'e3'}), 'unicode') ' 1']);

model.batch('p1').feature('so1').set('psol', 'sol520');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.batch('o1').run('compute');

model.study('std7').feature('opt').set('probewindow', '');
model.study('std8').feature('freq').set('plist', 'range(2582.5,1,2622.5)');
model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol518').runAll;

model.result('pg30').run;
model.result.create('pg33', 'PlotGroup1D');
model.result('pg33').run;
model.result('pg33').create('glob1', 'Global');
model.result('pg33').feature('glob1').set('markerpos', 'datapoints');
model.result('pg33').feature('glob1').set('linewidth', 'preference');
model.result('pg33').feature('glob1').remove('unit', [0 1]);
model.result('pg33').feature('glob1').remove('descr', [0 1]);
model.result('pg33').feature('glob1').remove('expr', [0 1]);
model.result('pg33').feature('glob1').setIndex('expr', 'Alpha', 0);
model.result('pg33').run;
model.result('pg33').set('data', 'dset14');
model.result('pg33').run;

model.param('default').setFromCase('case7');

model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol518').runAll;

model.result('pg30').run;
model.result('pg33').run;
model.result('pg33').run;
model.result('pg33').feature('glob1').createTable('tbl19');

model.study('std8').feature('freq').set('plist', 2598.6);
model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol518').runAll;

model.result('pg30').run;
model.result('pg33').run;

model.param('par5').setFromCase('case4');

model.study('std8').feature('freq').set('plist', 2598.5);
model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol518').runAll;

model.result('pg30').run;
model.result('pg33').run;
model.result('pg33').run;

model.study('std7').feature('opt').setIndex('pname', 'th1_min', 1);
model.study('std7').feature('opt').setIndex('pname', 'th2_n', 0);
model.study('std7').feature('opt').remove('initval', 0);
model.study('std7').feature('opt').remove('scale', 0);
model.study('std7').feature('opt').remove('lbound', 0);
model.study('std7').feature('opt').remove('ubound', 0);
model.study('std7').feature('opt').remove('punit', 0);
model.study('std7').feature('opt').remove('pname', [0]);
model.study('std7').feature('opt').remove('initval', 0);
model.study('std7').feature('opt').remove('scale', 0);
model.study('std7').feature('opt').remove('lbound', 0);
model.study('std7').feature('opt').remove('ubound', 0);
model.study('std7').feature('opt').remove('punit', 0);
model.study('std7').feature('opt').remove('pname', [0]);
model.study('std7').feature('opt').remove('initval', 0);
model.study('std7').feature('opt').remove('scale', 0);
model.study('std7').feature('opt').remove('lbound', 0);
model.study('std7').feature('opt').remove('ubound', 0);
model.study('std7').feature('opt').remove('punit', 0);
model.study('std7').feature('opt').remove('pname', [0]);
model.study('std7').feature('opt').remove('initval', 0);
model.study('std7').feature('opt').remove('scale', 0);
model.study('std7').feature('opt').remove('lbound', 0);
model.study('std7').feature('opt').remove('ubound', 0);
model.study('std7').feature('opt').remove('punit', 0);
model.study('std7').feature('opt').remove('pname', [0]);
model.study('std7').feature('opt').remove('initval', 0);
model.study('std7').feature('opt').remove('scale', 0);
model.study('std7').feature('opt').remove('lbound', 0);
model.study('std7').feature('opt').remove('ubound', 0);
model.study('std7').feature('opt').remove('punit', 0);
model.study('std7').feature('opt').remove('pname', [0]);
model.study('std7').feature('opt').remove('initval', 0);
model.study('std7').feature('opt').remove('scale', 0);
model.study('std7').feature('opt').remove('lbound', 0);
model.study('std7').feature('opt').remove('ubound', 0);
model.study('std7').feature('opt').remove('punit', 0);
model.study('std7').feature('opt').remove('pname', [0]);
model.study('std7').feature('opt').remove('initval', 0);
model.study('std7').feature('opt').remove('scale', 0);
model.study('std7').feature('opt').remove('lbound', 0);
model.study('std7').feature('opt').remove('ubound', 0);
model.study('std7').feature('opt').remove('punit', 0);
model.study('std7').feature('opt').remove('pname', [0]);
model.study('std7').feature('opt').setIndex('pname', 'c0', 0);
model.study('std7').feature('opt').setIndex('initval', '343[m/s]', 0);
model.study('std7').feature('opt').setIndex('scale', 1, 0);
model.study('std7').feature('opt').setIndex('lbound', '', 0);
model.study('std7').feature('opt').setIndex('ubound', '', 0);
model.study('std7').feature('opt').setIndex('punit', '', 0);
model.study('std7').feature('opt').setIndex('pname', 'c0', 0);
model.study('std7').feature('opt').setIndex('initval', '343[m/s]', 0);
model.study('std7').feature('opt').setIndex('scale', 1, 0);
model.study('std7').feature('opt').setIndex('lbound', '', 0);
model.study('std7').feature('opt').setIndex('ubound', '', 0);
model.study('std7').feature('opt').setIndex('punit', '', 0);
model.study('std7').feature('opt').setIndex('pname', 'th1_n', 0);
model.study('std7').feature('opt').setIndex('pname', 'c0', 1);
model.study('std7').feature('opt').setIndex('initval', '343[m/s]', 1);
model.study('std7').feature('opt').setIndex('scale', 1, 1);
model.study('std7').feature('opt').setIndex('lbound', '', 1);
model.study('std7').feature('opt').setIndex('ubound', '', 1);
model.study('std7').feature('opt').setIndex('punit', '', 1);
model.study('std7').feature('opt').setIndex('pname', 'c0', 1);
model.study('std7').feature('opt').setIndex('initval', '343[m/s]', 1);
model.study('std7').feature('opt').setIndex('scale', 1, 1);
model.study('std7').feature('opt').setIndex('lbound', '', 1);
model.study('std7').feature('opt').setIndex('ubound', '', 1);
model.study('std7').feature('opt').setIndex('punit', '', 1);
model.study('std7').feature('opt').setIndex('pname', 'D', 2);
model.study('std7').feature('opt').setIndex('initval', '100[mm]', 2);
model.study('std7').feature('opt').setIndex('scale', 1, 2);
model.study('std7').feature('opt').setIndex('lbound', '', 2);
model.study('std7').feature('opt').setIndex('ubound', '', 2);
model.study('std7').feature('opt').setIndex('punit', '', 2);
model.study('std7').feature('opt').setIndex('pname', 'D', 2);
model.study('std7').feature('opt').setIndex('initval', '100[mm]', 2);
model.study('std7').feature('opt').setIndex('scale', 1, 2);
model.study('std7').feature('opt').setIndex('lbound', '', 2);
model.study('std7').feature('opt').setIndex('ubound', '', 2);
model.study('std7').feature('opt').setIndex('punit', '', 2);
model.study('std7').feature('opt').setIndex('pname', 'delta_th', 3);
model.study('std7').feature('opt').setIndex('initval', '10[deg]', 3);
model.study('std7').feature('opt').setIndex('scale', 1, 3);
model.study('std7').feature('opt').setIndex('lbound', '', 3);
model.study('std7').feature('opt').setIndex('ubound', '', 3);
model.study('std7').feature('opt').setIndex('punit', '', 3);
model.study('std7').feature('opt').setIndex('pname', 'delta_th', 3);
model.study('std7').feature('opt').setIndex('initval', '10[deg]', 3);
model.study('std7').feature('opt').setIndex('scale', 1, 3);
model.study('std7').feature('opt').setIndex('lbound', '', 3);
model.study('std7').feature('opt').setIndex('ubound', '', 3);
model.study('std7').feature('opt').setIndex('punit', '', 3);
model.study('std7').feature('opt').setIndex('pname', 'f0', 4);
model.study('std7').feature('opt').setIndex('initval', '3000[Hz]', 4);
model.study('std7').feature('opt').setIndex('scale', 1, 4);
model.study('std7').feature('opt').setIndex('lbound', '', 4);
model.study('std7').feature('opt').setIndex('ubound', '', 4);
model.study('std7').feature('opt').setIndex('punit', '', 4);
model.study('std7').feature('opt').setIndex('pname', 'f0', 4);
model.study('std7').feature('opt').setIndex('initval', '3000[Hz]', 4);
model.study('std7').feature('opt').setIndex('scale', 1, 4);
model.study('std7').feature('opt').setIndex('lbound', '', 4);
model.study('std7').feature('opt').setIndex('ubound', '', 4);
model.study('std7').feature('opt').setIndex('punit', '', 4);
model.study('std7').feature('opt').setIndex('pname', 'th2_n', 1);
model.study('std7').feature('opt').setIndex('pname', 'r1n', 2);
model.study('std7').feature('opt').setIndex('pname', 'r2n', 3);
model.study('std7').feature('opt').setIndex('pname', 'z2', 4);
model.study('std7').feature('opt').setIndex('pname', 'z1_n', 4);
model.study('std7').feature('opt').setIndex('pname', 'c0', 5);
model.study('std7').feature('opt').setIndex('initval', '343[m/s]', 5);
model.study('std7').feature('opt').setIndex('scale', 1, 5);
model.study('std7').feature('opt').setIndex('lbound', '', 5);
model.study('std7').feature('opt').setIndex('ubound', '', 5);
model.study('std7').feature('opt').setIndex('punit', '', 5);
model.study('std7').feature('opt').setIndex('pname', 'c0', 5);
model.study('std7').feature('opt').setIndex('initval', '343[m/s]', 5);
model.study('std7').feature('opt').setIndex('scale', 1, 5);
model.study('std7').feature('opt').setIndex('lbound', '', 5);
model.study('std7').feature('opt').setIndex('ubound', '', 5);
model.study('std7').feature('opt').setIndex('punit', '', 5);
model.study('std7').feature('opt').setIndex('pname', 'z2_n', 5);
model.study('std7').feature('opt').setIndex('lbound', 0, 0);
model.study('std7').feature('opt').setIndex('ubound', 1, 0);
model.study('std7').feature('opt').setIndex('lbound', 0, 1);
model.study('std7').feature('opt').setIndex('ubound', 1, 1);
model.study('std7').feature('opt').setIndex('lbound', 0, 2);
model.study('std7').feature('opt').setIndex('ubound', 1, 2);
model.study('std7').feature('opt').setIndex('lbound', 0, 3);
model.study('std7').feature('opt').setIndex('ubound', 1, 3);
model.study('std7').feature('opt').setIndex('lbound', 0, 4);
model.study('std7').feature('opt').setIndex('ubound', 1, 4);
model.study('std7').feature('opt').setIndex('lbound', 0, 5);
model.study('std7').feature('opt').setIndex('ubound', 1, 5);
model.study('std7').feature('opt').setIndex('pname', 'c0', 6);
model.study('std7').feature('opt').setIndex('initval', '343[m/s]', 6);
model.study('std7').feature('opt').setIndex('scale', 1, 6);
model.study('std7').feature('opt').setIndex('lbound', '', 6);
model.study('std7').feature('opt').setIndex('ubound', '', 6);
model.study('std7').feature('opt').setIndex('punit', '', 6);
model.study('std7').feature('opt').setIndex('pname', 'c0', 6);
model.study('std7').feature('opt').setIndex('initval', '343[m/s]', 6);
model.study('std7').feature('opt').setIndex('scale', 1, 6);
model.study('std7').feature('opt').setIndex('lbound', '', 6);
model.study('std7').feature('opt').setIndex('ubound', '', 6);
model.study('std7').feature('opt').setIndex('punit', '', 6);
model.study('std7').feature('opt').setIndex('pname', 'rotat', 6);
model.study('std7').feature('opt').setIndex('initval', '-121[deg]', 6);
model.study('std7').feature('opt').setIndex('lbound', '180[deg]', 6);
model.study('std7').feature('opt').setIndex('lbound', '-180[deg]', 6);
model.study('std7').feature('opt').setIndex('ubound', 0, 6);
model.study('std7').feature('opt').set('keepsol', 'auto');
model.study('std7').feature('opt').set('objtable', 'new');
model.study('std7').feature('opt').setIndex('plotgrouparr', 'pg33', 0);
model.study('std7').feature('opt').set('objectivesolution', 'auto');
model.study('std7').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.batch('o1').run('compute');

model.component('comp1').geom('geom1').run;

model.study('std7').feature('opt').set('probewindow', '');

model.result('pg33').run;
model.result('pg33').set('data', 'dset16');
model.result('pg33').run;
model.result.evaluationGroup('eg1').set('data', 'dset16');
model.result.evaluationGroup('eg1').run;
model.result.evaluationGroup('eg1').feature('gev1').set('expr', {});
model.result.evaluationGroup('eg1').feature('gev1').set('descr', {});
model.result('pg33').run;
model.result.evaluationGroup('eg1').feature('gev1').setIndex('expr', 'Alpha', 0);
model.result.evaluationGroup('eg1').run;

model.param('default').paramCase.create('case8');
model.param('default').paramCase('case8').set('rotat', '-2.1304[rad]');
model.param('par5').paramCase.create('case11');
model.param('par5').paramCase('case11').set('th1_n', '0.58451');
model.param('par5').paramCase('case11').set('r1n', '0.82516');
model.param('par5').paramCase('case11').set('z1_n', '0.17154');
model.param('par5').paramCase('case11').set('th2_n', '0.11936');
model.param('par5').paramCase('case11').set('r2n', '0.98164');
model.param('par5').paramCase('case11').set('z2_n', '0.79562');

model.study('std7').feature('opt').setIndex('initval', 0.58451, 0);
model.study('std7').feature('opt').setIndex('initval', 0.11936, 1);
model.study('std7').feature('opt').setIndex('initval', 0.82516, 2);
model.study('std7').feature('opt').setIndex('initval', 0.98164, 3);
model.study('std7').feature('opt').setIndex('initval', 0.117154, 4);
model.study('std7').feature('opt').setIndex('initval', 0.79562, 5);
model.study('std7').feature('opt').setIndex('initval', '-2.1304[rad]', 6);
model.study('std7').feature('opt').setIndex('lbound', 0.4, 0);
model.study('std7').feature('opt').setIndex('ubound', 0.4, 1);
model.study('std7').feature('opt').setIndex('lbound', 0.4, 2);
model.study('std7').feature('opt').setIndex('lbound', 0.4, 3);
model.study('std7').feature('opt').setIndex('ubound', 0.4, 4);
model.study('std7').feature('opt').setIndex('lbound', 0.5, 5);
model.study('std7').feature('opt').set('objtable', 'new');
model.study('std7').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.batch('o1').run('compute');

model.result('pg33').run;

model.study('std7').feature('opt').set('probewindow', '');

model.result('pg31').run;

model.study('std7').feature('freq').set('plist', 'range(2592.5,2,2612.5)');
model.study('std7').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.study('std7').feature('opt').set('probewindow', '');
model.study('std7').feature('opt').set('objtable', 'new');
model.study('std7').feature('opt').set('objectivesolution', 'min');
model.study('std7').feature('opt').set('useconstrtable', true);
model.study('std7').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.batch('o1').run('compute');

model.result('pg33').run;

model.study('std7').feature('opt').set('probewindow', '');

model.param('par6').label('kmn');

model.result('pg33').run;
model.result('pg33').feature('glob1').set('xdatasolnumtype', 'level1');
model.result('pg33').run;
model.result('pg33').feature('glob1').createTable('tbl26');

model.study('std7').feature('freq').set('plist', 2602.5);
model.study('std7').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.batch('o1').run('compute');

model.result('pg33').run;

model.study('std7').feature('opt').set('probewindow', '');

model.param('default').paramCase.create('case9');
model.param('default').paramCase('case9').set('rotat', '-2.1391[1]');
model.param('par5').paramCase.create('case12');
model.param('par5').paramCase('case12').set('th1_n', '0.61639');
model.param('par5').paramCase('case12').set('r1n', '0.83532');
model.param('par5').paramCase('case12').set('z1_n', '0.12633');
model.param('par5').paramCase('case12').set('th2_n', '0.16981');
model.param('par5').paramCase('case12').set('r2n', '0.93641');
model.param('par5').paramCase('case12').set('z2_n', '0.80453');
model.param('default').setFromCase('case9');
model.param('par5').setFromCase('case12');
model.param('par5').paramCase('case12').label('0.93');
model.param('default').paramCase('case1').label('0.93');

model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol518').runAll;

model.result('pg30').run;
model.result.evaluationGroup('eg1').run;
model.result.evaluationGroup('eg1').set('data', 'dset14');
model.result.evaluationGroup('eg1').run;
model.result.evaluationGroup('eg1').set('data', 'dset16');
model.result.evaluationGroup('eg1').run;

model.study('std8').feature('freq').set('plist', 2602.5);
model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol518').runAll;

model.result('pg30').run;
model.result.evaluationGroup('eg1').set('data', 'dset14');
model.result.evaluationGroup('eg1').run;

model.param('par5').paramCase('case12').label('0.93-2602.5');
model.param('default').paramCase('case9').label('0.93-2602.5');

model.result.evaluationGroup('eg1').set('data', 'dset16');
model.result.evaluationGroup('eg1').run;

model.study('std8').feature('freq').set('plist', 'range(2582.5,1,2622.5)');
model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol518').runAll;

model.result('pg30').run;
model.result('pg33').run;
model.result('pg33').run;
model.result('pg33').set('data', 'dset14');
model.result('pg33').run;

model.study('std7').feature('opt').setIndex('initval', 0.61639, 0);
model.study('std7').feature('opt').setIndex('initval', 0.16981, 1);
model.study('std7').feature('opt').setIndex('initval', 0.83532, 2);
model.study('std7').feature('opt').setIndex('initval', 0.93641, 3);
model.study('std7').feature('opt').setIndex('initval', 0.12633, 4);
model.study('std7').feature('opt').setIndex('initval', 0.80453, 5);
model.study('std7').feature('opt').remove('initval', 6);
model.study('std7').feature('opt').remove('scale', 6);
model.study('std7').feature('opt').remove('lbound', 6);
model.study('std7').feature('opt').remove('ubound', 6);
model.study('std7').feature('opt').remove('punit', 6);
model.study('std7').feature('opt').remove('pname', [6]);
model.study('std7').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.batch('o1').run('compute');

model.study('std7').feature('opt').set('probewindow', '');

model.component('comp1').geom('geom1').run;

model.study('std7').feature('opt').set('objtable', 'new');
model.study('std7').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.batch('o1').run('compute');

model.study('std7').feature('opt').set('probewindow', '');

model.result.numerical.create('gev2', 'EvalGlobal');
model.result.numerical('gev2').set('expr', {});
model.result.numerical('gev2').set('descr', {});
model.result.numerical('gev2').setIndex('expr', 'Alpha', 0);
model.result.numerical('gev2').set('data', 'dset16');
model.result.numerical('gev2').setIndex('looplevelinput', 'manual', 1);
model.result.table.create('tbl29', 'Table');
model.result.table('tbl29').comments([native2unicode(hex2dec({'51' '68'}), 'unicode')  native2unicode(hex2dec({'5c' '40'}), 'unicode')  native2unicode(hex2dec({'8b' 'a1'}), 'unicode')  native2unicode(hex2dec({'7b' '97'}), 'unicode') ' 2 {gev2}']);
model.result.numerical('gev2').set('table', 'tbl29');
model.result.numerical('gev2').setResult;

model.param('par5').paramCase.create('case13');
model.param('par5').paramCase('case13').set('th1_n', '0.61636');
model.param('par5').paramCase('case13').set('r1n', '0.83540');
model.param('par5').paramCase('case13').set('z1_n', '0.12648');
model.param('par5').paramCase('case13').set('th2_n', '0.16983');
model.param('par5').paramCase('case13').set('r2n', '0.93639');
model.param('par5').paramCase('case13').set('z2_n', '0.80397');

model.study('std7').feature('opt').setIndex('initval', 0.61636, 0);
model.study('std7').feature('opt').setIndex('initval', 0.16983, 1);
model.study('std7').feature('opt').setIndex('initval', '0.83540', 2);
model.study('std7').feature('opt').setIndex('initval', 0.93639, 3);
model.study('std7').feature('opt').setIndex('initval', 0.12648, 4);
model.study('std7').feature('opt').setIndex('initval', 0.80397, 5);

model.param.create('par7');
model.param('par7').set('dis_c2_xmax', 'lbd/2');
model.param('par7').descr('dis_c2_xmax', '');
model.param('par7').set('dis_c2_xmin', '-lbd/2.5');
model.param('par7').descr('dis_c2_xmin', '');
model.param('par7').set('dis_c2_x2n', '0.44253[1]');
model.param('par7').descr('dis_c2_x2n', '');
model.param('par7').set('dis_c2_x1n', '0.43668[1]');
model.param('par7').descr('dis_c2_x1n', '');
model.param('par7').set('dis_c2_x3n', '0.42229[1]');
model.param('par7').descr('dis_c2_x3n', '');
model.param('par7').set('dis_c2_x4n', '0.44321[1]');
model.param('par7').descr('dis_c2_x4n', '');
model.param('par7').set('dis_c2_x2', 'dis_c2_xmin+(dis_c2_xmax-dis_c2_xmin)*dis_c2_x2n');
model.param('par7').descr('dis_c2_x2', '');
model.param('par7').set('dis_c2_x1', 'dis_c2_xmin+(dis_c2_xmax-dis_c2_xmin)*dis_c2_x1n');
model.param('par7').descr('dis_c2_x1', '');
model.param('par7').set('dis_c2_x3', 'dis_c2_xmin+(dis_c2_xmax-dis_c2_xmin)*dis_c2_x3n');
model.param('par7').descr('dis_c2_x3', '');
model.param('par7').set('dis_c2_x4', 'dis_c2_xmin+(dis_c2_xmax-dis_c2_xmin)*dis_c2_x4n');
model.param('par7').descr('dis_c2_x4', '');

model.component('comp1').geom('geom1').run('fin');

model.component('comp1').view('view1').set('renderwireframe', false);

model.component('comp1').geom('geom1').run('mov1');
model.component('comp1').geom('geom1').create('mov2', 'Move');
model.component('comp1').geom('geom1').nodeGroup('grp1').remove('mov2', false);
model.component('comp1').geom('geom1').feature('mov2').selection('input').set({'ext2'});
model.component('comp1').geom('geom1').feature('mov2').set('displz', 'dis_c2_x1');
model.component('comp1').geom('geom1').feature.duplicate('mov3', 'mov2');
model.component('comp1').geom('geom1').feature.duplicate('mov4', 'mov3');
model.component('comp1').geom('geom1').feature.duplicate('mov5', 'mov4');
model.component('comp1').geom('geom1').runPre('mov3');
model.component('comp1').geom('geom1').feature('mov3').selection('input').set({'ext1'});
model.component('comp1').geom('geom1').feature('mov3').set('displz', 'dis_c2_x2');
model.component('comp1').geom('geom1').runPre('mov4');
model.component('comp1').geom('geom1').feature('mov4').selection('input').set({'ext4'});
model.component('comp1').geom('geom1').feature('mov4').set('displz', 'dis_c2_x3');
model.component('comp1').geom('geom1').runPre('mov5');
model.component('comp1').geom('geom1').feature('mov5').selection('input').set({'ext3'});
model.component('comp1').geom('geom1').feature('mov5').set('displz', 'dis_c2_x4');
model.component('comp1').geom('geom1').run('mov5');
model.component('comp1').geom('geom1').run('mir1');
model.component('comp1').geom('geom1').run('rot3');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('wp6').set('quickz', '-0.2.5');
model.component('comp1').geom('geom1').feature('wp7').set('quickz', '+0.25');
model.component('comp1').geom('geom1').feature('wp6').set('quickz', -0.25);
model.component('comp1').geom('geom1').run('wp6');
model.component('comp1').geom('geom1').run('wp7');
model.component('comp1').geom('geom1').feature.duplicate('wp8', 'wp7');
model.component('comp1').geom('geom1').feature('wp8').set('quickz', 0.1);
model.component('comp1').geom('geom1').run('wp8');
model.component('comp1').geom('geom1').feature('wp8').set('quickz', 0.2);
model.component('comp1').geom('geom1').run('wp8');
model.component('comp1').geom('geom1').run('wp8');
model.component('comp1').geom('geom1').feature.duplicate('wp9', 'wp8');
model.component('comp1').geom('geom1').feature('wp9').set('quickz', -0.2);
model.component('comp1').geom('geom1').run('wp9');
model.component('comp1').geom('geom1').run;

model.component('comp1').physics('acpr').feature('bpf2').selection.set([6 7]);
model.component('comp1').physics('acpr').feature('bpf1').selection.set([11 12]);

model.component('comp1').geom('geom1').feature('wp8').set('quickz', 0.18);
model.component('comp1').geom('geom1').feature('wp9').set('quickz', -0.18);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run;

model.study('std7').feature('opt').setIndex('pname', 'c0', 6);
model.study('std7').feature('opt').setIndex('initval', '343[m/s]', 6);
model.study('std7').feature('opt').setIndex('scale', 1, 6);
model.study('std7').feature('opt').setIndex('lbound', '', 6);
model.study('std7').feature('opt').setIndex('ubound', '', 6);
model.study('std7').feature('opt').setIndex('punit', '', 6);
model.study('std7').feature('opt').setIndex('pname', 'c0', 6);
model.study('std7').feature('opt').setIndex('initval', '343[m/s]', 6);
model.study('std7').feature('opt').setIndex('scale', 1, 6);
model.study('std7').feature('opt').setIndex('lbound', '', 6);
model.study('std7').feature('opt').setIndex('ubound', '', 6);
model.study('std7').feature('opt').setIndex('punit', '', 6);
model.study('std7').feature('opt').setIndex('pname', 'D', 7);
model.study('std7').feature('opt').setIndex('initval', '100[mm]', 7);
model.study('std7').feature('opt').setIndex('scale', 1, 7);
model.study('std7').feature('opt').setIndex('lbound', '', 7);
model.study('std7').feature('opt').setIndex('ubound', '', 7);
model.study('std7').feature('opt').setIndex('punit', '', 7);
model.study('std7').feature('opt').setIndex('pname', 'D', 7);
model.study('std7').feature('opt').setIndex('initval', '100[mm]', 7);
model.study('std7').feature('opt').setIndex('scale', 1, 7);
model.study('std7').feature('opt').setIndex('lbound', '', 7);
model.study('std7').feature('opt').setIndex('ubound', '', 7);
model.study('std7').feature('opt').setIndex('punit', '', 7);
model.study('std7').feature('opt').setIndex('pname', 'delta_th', 8);
model.study('std7').feature('opt').setIndex('initval', '10[deg]', 8);
model.study('std7').feature('opt').setIndex('scale', 1, 8);
model.study('std7').feature('opt').setIndex('lbound', '', 8);
model.study('std7').feature('opt').setIndex('ubound', '', 8);
model.study('std7').feature('opt').setIndex('punit', '', 8);
model.study('std7').feature('opt').setIndex('pname', 'delta_th', 8);
model.study('std7').feature('opt').setIndex('initval', '10[deg]', 8);
model.study('std7').feature('opt').setIndex('scale', 1, 8);
model.study('std7').feature('opt').setIndex('lbound', '', 8);
model.study('std7').feature('opt').setIndex('ubound', '', 8);
model.study('std7').feature('opt').setIndex('punit', '', 8);
model.study('std7').feature('opt').setIndex('pname', 'dis_c2_x1', 9);
model.study('std7').feature('opt').setIndex('initval', 'dis_c2_xmin+(dis_c2_xmax-dis_c2_xmin)*dis_c2_x1n', 9);
model.study('std7').feature('opt').setIndex('scale', 1, 9);
model.study('std7').feature('opt').setIndex('lbound', '', 9);
model.study('std7').feature('opt').setIndex('ubound', '', 9);
model.study('std7').feature('opt').setIndex('punit', '', 9);
model.study('std7').feature('opt').setIndex('pname', 'dis_c2_x1', 9);
model.study('std7').feature('opt').setIndex('initval', 'dis_c2_xmin+(dis_c2_xmax-dis_c2_xmin)*dis_c2_x1n', 9);
model.study('std7').feature('opt').setIndex('scale', 1, 9);
model.study('std7').feature('opt').setIndex('lbound', '', 9);
model.study('std7').feature('opt').setIndex('ubound', '', 9);
model.study('std7').feature('opt').setIndex('punit', '', 9);
model.study('std7').feature('opt').setIndex('pname', 'dis_c2_x1n', 6);
model.study('std7').feature('opt').setIndex('pname', 'dis_c2_x2n', 7);
model.study('std7').feature('opt').setIndex('pname', 'dis_c2_x3n', 8);
model.study('std7').feature('opt').setIndex('pname', 'dis_c2_x3', 9);
model.study('std7').feature('opt').setIndex('pname', 'dis_c2_x4n', 9);
model.study('std7').feature('opt').setIndex('lbound', 0, 6);
model.study('std7').feature('opt').setIndex('ubound', 1, 6);
model.study('std7').feature('opt').setIndex('lbound', 0, 7);
model.study('std7').feature('opt').setIndex('ubound', 1, 7);
model.study('std7').feature('opt').setIndex('lbound', 0, 8);
model.study('std7').feature('opt').setIndex('ubound', 1, 8);
model.study('std7').feature('opt').setIndex('lbound', 0, 9);
model.study('std7').feature('opt').setIndex('ubound', 1, 9);
model.study('std7').feature('opt').set('objtable', 'new');
model.study('std7').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.batch('o1').run('compute');

model.study('std7').feature('opt').set('probewindow', '');

model.result.numerical('gev2').set('table', 'tbl29');
model.result.numerical('gev2').appendResult;

model.param('par5').paramCase.create('case14');
model.param('par5').paramCase('case14').set('th1_n', '0.61636');
model.param('par5').paramCase('case14').set('r1n', '0.83540');
model.param('par5').paramCase('case14').set('z1_n', '0.12648');
model.param('par5').paramCase('case14').set('th2_n', '0.16983');
model.param('par5').paramCase('case14').set('r2n', '0.93639');
model.param('par5').paramCase('case14').set('z2_n', '0.80397');

model.result.table('tbl29').clearTableData;

model.component('comp1').geom('geom1').run;

model.result.numerical('gev2').set('table', 'tbl29');
model.result.numerical('gev2').setResult;

model.param('par7').paramCase.create('case1');
model.param('par7').paramCase('case1').set('dis_c2_x1n', '0.43531[1]');
model.param('par7').paramCase('case1').set('dis_c2_x3n', '0.41836[1]');
model.param('par7').paramCase('case1').set('dis_c2_x2n', '0.44359[1]');
model.param('par7').paramCase('case1').set('dis_c2_x4n', '0.44351[1]');
model.param('par5').paramCase.create('case15');
model.param('par5').paramCase('case15').set('th1_n', '0.61602');
model.param('par5').paramCase('case15').set('r1n', '0.83645');
model.param('par5').paramCase('case15').set('z1_n', '0.12706');
model.param('par5').paramCase('case15').set('th2_n', '0.20828');
model.param('par5').paramCase('case15').set('r2n', '0.93624');
model.param('par5').paramCase('case15').set('z2_n', '0.65336');
model.param('par7').setFromCase('case1');
model.param('par7').setFromCase('case1');
model.param('par7').setFromCase('case1');
model.param('par5').setFromCase('case15');

model.study('std8').feature('freq').set('plist', 2602.5);
model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol518').runAll;

model.result('pg30').run;
model.result.numerical('gev2').set('data', 'dset14');
model.result.numerical('gev2').set('table', 'tbl29');
model.result.numerical('gev2').appendResult;

model.study('std7').feature('opt').setIndex('initval', '0.', 0);
model.study('std8').feature('freq').set('plist', 'range(2582.5,2,2622.5)');
model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol518').runAll;

model.result('pg30').run;
model.result('pg33').run;

model.study('std7').feature('opt').setIndex('initval', 0.61602, 0);
model.study('std7').feature('opt').setIndex('initval', 0.20828, 1);
model.study('std7').feature('opt').setIndex('initval', 0.83645, 2);
model.study('std7').feature('opt').setIndex('initval', 0.93624, 3);
model.study('std7').feature('opt').setIndex('initval', 0.12706, 4);
model.study('std7').feature('opt').setIndex('initval', 0.65336, 5);
model.study('std7').feature('opt').setIndex('initval', 0.44359, 6);
model.study('std7').feature('opt').setIndex('initval', 0.41836, 7);
model.study('std7').feature('opt').setIndex('initval', 0.44325, 8);
model.study('std7').feature('opt').setIndex('initval', 0.43531, 6);
model.study('std7').feature('opt').setIndex('initval', 0.44359, 7);
model.study('std7').feature('opt').setIndex('initval', 0.41836, 8);
model.study('std7').feature('opt').setIndex('initval', 0.44351, 9);
model.study('std7').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.batch('o1').run('compute');

model.study('std7').feature('opt').set('probewindow', '');

model.result.numerical('gev2').set('data', 'dset16');
model.result.table.create('tbl32', 'Table');
model.result.table('tbl32').comments([native2unicode(hex2dec({'51' '68'}), 'unicode')  native2unicode(hex2dec({'5c' '40'}), 'unicode')  native2unicode(hex2dec({'8b' 'a1'}), 'unicode')  native2unicode(hex2dec({'7b' '97'}), 'unicode') ' 2 {gev2}']);
model.result.numerical('gev2').set('table', 'tbl32');
model.result.numerical('gev2').setResult;

model.param('par7').paramCase.create('case2');
model.param('par7').paramCase('case2').set('dis_c2_x1n', '0.36184[1]');
model.param('par7').paramCase('case2').set('dis_c2_x3n', '0.41964[1]');
model.param('par7').paramCase('case2').set('dis_c2_x2n', '0.44344[1]');
model.param('par7').paramCase('case2').set('dis_c2_x4n', '0.44339[1]');
model.param('par5').paramCase.create('case16');
model.param('par5').paramCase('case16').set('th1_n', '0.60864');
model.param('par5').paramCase('case16').set('r1n', '0.83730');
model.param('par5').paramCase('case16').set('z1_n', '0.12715');
model.param('par5').paramCase('case16').set('th2_n', '0.20909');
model.param('par5').paramCase('case16').set('r2n', '0.93580');
model.param('par5').paramCase('case16').set('z2_n', '0.65333');
model.param('par7').setFromCase('case2');
model.param('par5').setFromCase('case16');

model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol518').runAll;

model.result('pg30').run;
model.result.numerical('gev2').set('data', 'dset14');
model.result.table.create('tbl33', 'Table');
model.result.table('tbl33').comments([native2unicode(hex2dec({'51' '68'}), 'unicode')  native2unicode(hex2dec({'5c' '40'}), 'unicode')  native2unicode(hex2dec({'8b' 'a1'}), 'unicode')  native2unicode(hex2dec({'7b' '97'}), 'unicode') ' 2 {gev2}']);
model.result.numerical('gev2').set('table', 'tbl33');
model.result.numerical('gev2').setResult;
model.result('pg33').run;

model.label([native2unicode(hex2dec({'53' 'cc'}), 'unicode')  native2unicode(hex2dec({'5c' '42'}), 'unicode')  native2unicode(hex2dec({'7e' 'd3'}), 'unicode')  native2unicode(hex2dec({'67' '84'}), 'unicode')  native2unicode(hex2dec({'97' '5e'}), 'unicode')  native2unicode(hex2dec({'5b' 'f9'}), 'unicode')  native2unicode(hex2dec({'79' 'f0'}), 'unicode')  native2unicode(hex2dec({'6d' '4b'}), 'unicode')  native2unicode(hex2dec({'8b' 'd5'}), 'unicode') '_' native2unicode(hex2dec({'4e' 'ff'}), 'unicode')  native2unicode(hex2dec({'71' '67'}), 'unicode') 'optic_' native2unicode(hex2dec({'5d' 'e6'}), 'unicode')  native2unicode(hex2dec({'53' 'f3'}), 'unicode')  native2unicode(hex2dec({'62' '4b'}), 'unicode')  native2unicode(hex2dec({'60' '27'}), 'unicode')  native2unicode(hex2dec({'76' 'f8'}), 'unicode')  native2unicode(hex2dec({'54' '0c'}), 'unicode') '_CPA.mph']);

model.result('pg33').run;

model.param.set('D', '200[mm]');
model.param.set('L', '300[mm]*2*2');
model.param.set('f0', '1400[Hz]');

model.component('comp1').geom('geom1').run('fin');
model.component('comp1').geom('geom1').feature('wp6').set('quickz', '-0.25*2');
model.component('comp1').geom('geom1').feature('wp7').set('quickz', '+0.25*2');
model.component('comp1').geom('geom1').feature('wp8').set('quickz', '0.18*2');
model.component('comp1').geom('geom1').feature('wp9').set('quickz', '-0.18*2');
model.component('comp1').geom('geom1').run('wp9');
model.component('comp1').geom('geom1').run;
model.component('comp1').geom('geom1').run('fin');
model.component('comp1').geom('geom1').feature.create('rmd1', 'RemoveDetails');
model.component('comp1').geom('geom1').feature('rmd1').set('detailsizetype', 'absolute');
model.component('comp1').geom('geom1').feature('rmd1').set('maxabssize', '0.0018');
model.component('comp1').geom('geom1').run('rmd1');

model.component('comp1').view('view1').set('renderwireframe', true);

model.component('comp1').geom('geom1').run('rot3');
model.component('comp1').geom('geom1').run('rot3');
model.component('comp1').geom('geom1').runPre('rot3');
model.component('comp1').geom('geom1').runPre('fin');

model.component('comp1').view('view1').set('renderwireframe', false);

model.study('std1').feature('eig').set('shift', '1.5');
model.study('std1').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol1').runAll;

model.result.evaluationGroup('std4EvgFrq').run;
model.result('pg30').run;
model.result('pg30').set('data', 'dset1');
model.result('pg30').set('looplevel', [1]);
model.result('pg30').run;
model.result('pg30').stepNext(0);
model.result('pg30').run;
model.result('pg30').stepNext(0);
model.result('pg30').run;
model.result('pg30').stepNext(0);
model.result('pg30').run;
model.result('pg30').stepNext(0);
model.result('pg30').run;
model.result('pg30').stepNext(0);
model.result('pg30').run;
model.result('pg30').stepNext(0);
model.result('pg30').run;
model.result('pg30').stepNext(0);
model.result('pg30').run;
model.result('pg30').stepNext(0);
model.result('pg30').run;
model.result('pg30').stepNext(0);
model.result('pg30').run;
model.result('pg30').stepNext(0);
model.result('pg30').run;
model.result('pg30').stepNext(0);
model.result('pg30').run;
model.result('pg30').stepNext(0);
model.result('pg30').run;
model.result('pg30').stepNext(0);
model.result('pg30').run;
model.result('pg30').stepNext(0);
model.result('pg30').run;
model.result('pg30').stepNext(0);
model.result('pg30').run;
model.result('pg30').stepNext(0);
model.result('pg30').run;
model.result('pg30').stepNext(0);
model.result('pg30').run;
model.result('pg30').stepPrevious(0);
model.result('pg30').run;
model.result('pg30').stepPrevious(0);
model.result('pg30').run;
model.result('pg30').stepPrevious(0);
model.result('pg30').run;
model.result('pg30').stepPrevious(0);
model.result('pg30').run;
model.result('pg30').stepPrevious(0);
model.result('pg30').run;
model.result('pg30').stepPrevious(0);
model.result('pg30').run;
model.result('pg30').stepPrevious(0);
model.result('pg30').run;
model.result('pg30').stepPrevious(0);
model.result('pg30').run;
model.result('pg30').stepPrevious(0);
model.result('pg30').run;
model.result('pg30').stepPrevious(0);
model.result('pg30').run;
model.result('pg30').stepPrevious(0);
model.result('pg30').run;
model.result('pg30').stepPrevious(0);
model.result('pg30').run;
model.result('pg30').stepPrevious(0);
model.result('pg30').run;
model.result('pg30').stepPrevious(0);
model.result('pg30').run;
model.result('pg30').stepPrevious(0);
model.result('pg30').run;
model.result('pg30').stepPrevious(0);
model.result('pg30').run;
model.result('pg30').stepPrevious(0);
model.result('pg30').run;

model.study('std8').feature('freq').set('plist', 1300);
model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol518').runAll;

model.result('pg31').run;
model.result('pg30').run;
model.result('pg30').run;
model.result('pg30').feature('surf1').set('expr', 'acpr.p_b');
model.result('pg30').run;
model.result('pg30').run;
model.result('pg30').set('data', 'dset14');
model.result('pg30').run;

model.param('par5').set('th1_n', '0.15273');
model.param('par5').descr('th1_n', '');
model.param('par5').set('th2_n', '0.1');
model.param('par5').descr('th2_n', '');
model.param('par5').set('r1n', '0.59902');
model.param('par5').descr('r1n', '');
model.param('par5').set('r2n', '0.10098');
model.param('par5').descr('r2n', '');
model.param('par5').set('z1_n', '0.81875');
model.param('par5').descr('z1_n', '');
model.param('par5').set('z2_n', '0.1');
model.param('par5').descr('z2_n', '');
model.param('par7').set('dis_c2_x2n', '-dis_c2_xmin/(dis_c2_xmax-dis_c2_xmin)');
model.param('par7').set('dis_c2_x1n', '-dis_c2_xmin/(dis_c2_xmax-dis_c2_xmin)');
model.param('par7').set('dis_c2_x3n', '-dis_c2_xmin/(dis_c2_xmax-dis_c2_xmin)');
model.param('par7').set('dis_c2_x4n', '-dis_c2_xmin/(dis_c2_xmax-dis_c2_xmin)');

model.component('comp1').geom('geom1').run('rmd1');

model.study('std1').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol1').runAll;

model.component('comp1').physics('acpr').prop('MeshControl').set('PhysicsControlledMeshMaximumFrequency', '1500[Hz]');

model.study('std1').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.component('comp1').mesh('mesh1').run;

model.study('std1').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol1').runAll;

model.result('pg30').run;
model.result('pg30').set('data', 'dset1');
model.result('pg30').run;
model.result('pg30').feature('surf1').set('expr', 'acpr.p_t');
model.result('pg30').run;
model.result('pg30').run;
model.result('pg30').set('looplevel', [11]);
model.result('pg30').run;
model.result('pg30').set('data', 'dset14');
model.result('pg30').run;
model.result('pg30').run;
model.result('pg30').feature('surf1').set('expr', 'acpr.p_b');
model.result('pg30').run;
model.result('pg30').run;
model.result('pg30').set('data', 'dset1');
model.result('pg30').run;
model.result('pg30').run;
model.result('pg30').feature('surf1').set('expr', 'acpr.p_t');
model.result('pg30').run;
model.result('pg30').run;
model.result('pg30').set('looplevel', [11]);
model.result('pg30').run;

model.component('comp1').variable('var1').set('p_10', 'besselj(1,k10*r)*exp(-1i*-1*th)*exp(-1i*kz*z)');
model.component('comp1').variable('var1').set('p_10_1', 'besselj(1,k10*r)*exp(1i*-1*th)*exp(1i*kz*z)');

model.result('pg30').run;

model.study('std8').feature('freq').set('plist', 1483.8);
model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol518').runAll;

model.result('pg31').run;
model.result('pg30').run;
model.result('pg30').set('data', 'dset14');
model.result('pg30').run;
model.result('pg30').feature('surf1').set('expr', 'acpr.p_b');
model.result('pg30').run;
model.result('pg30').feature('surf1').set('expr', 'acpr.p_s');
model.result('pg30').run;

model.param('default').paramCase('case9').label('0.93-2602.5 100mm');
model.param('par7').paramCase('case2').label([native2unicode(hex2dec({'5b' '9e'}), 'unicode')  native2unicode(hex2dec({'4f' '8b'}), 'unicode') ' 2 100mm']);
model.param('default').paramCase.remove('case1');
model.param('default').paramCase.remove('case2');
model.param('default').paramCase.remove('case3');
model.param('default').paramCase.remove('case4');
model.param('default').paramCase.remove('case5');
model.param('default').paramCase.remove('case6');
model.param('default').paramCase.remove('case7');
model.param('default').paramCase.remove('case8');
model.param('default').paramCase.remove('case9');
model.param('par2').paramCase.remove('case1');
model.param('par2').paramCase.remove('case2');
model.param('par2').paramCase.remove('case3');
model.param('par2').paramCase.remove('case4');
model.param('par3').paramCase.remove('case1');
model.param('par3').paramCase.remove('case2');
model.param('par3').paramCase.remove('case3');
model.param('par3').paramCase.remove('case4');
model.param('par4').paramCase.remove('case1');
model.param('par4').paramCase.remove('case2');
model.param('par4').paramCase.remove('case3');
model.param('par4').paramCase.remove('case4');
model.param('par4').paramCase.remove('case5');
model.param('par4').paramCase.remove('case6');
model.param('par5').paramCase.remove('case1');
model.param('par5').paramCase.remove('case2');
model.param('par5').paramCase.remove('case3');
model.param('par5').paramCase.remove('case4');
model.param('par5').paramCase.remove('case5');
model.param('par5').paramCase.remove('case6');
model.param('par5').paramCase.remove('case7');
model.param('par5').paramCase.remove('case8');
model.param('par5').paramCase.remove('case9');
model.param('par5').paramCase.remove('case10');
model.param('par5').paramCase.remove('case11');
model.param('par5').paramCase.remove('case12');
model.param('par5').paramCase.remove('case13');
model.param('par5').paramCase.remove('case14');
model.param('par5').paramCase.remove('case15');
model.param('par5').paramCase.remove('case16');
model.param('par7').paramCase.remove('case1');
model.param('par7').paramCase.remove('case2');

model.study('std7').feature('opt').remove('initval', [0 1 2 3 4 5 6 7 8 9]);
model.study('std7').feature('opt').remove('scale', [0 1 2 3 4 5 6 7 8 9]);
model.study('std7').feature('opt').remove('lbound', [0 1 2 3 4 5 6 7 8 9]);
model.study('std7').feature('opt').remove('ubound', [0 1 2 3 4 5 6 7 8 9]);
model.study('std7').feature('opt').remove('punit', [0 1 2 3 4 5 6 7 8 9]);
model.study('std7').feature('opt').remove('pname', [0 1 2 3 4 5 6 7 8 9]);
model.study('std7').feature('opt').setIndex('pname', 'c0', 0);
model.study('std7').feature('opt').setIndex('initval', '343[m/s]', 0);
model.study('std7').feature('opt').setIndex('scale', 1, 0);
model.study('std7').feature('opt').setIndex('lbound', '', 0);
model.study('std7').feature('opt').setIndex('ubound', '', 0);
model.study('std7').feature('opt').setIndex('punit', '', 0);
model.study('std7').feature('opt').setIndex('pname', 'c0', 0);
model.study('std7').feature('opt').setIndex('initval', '343[m/s]', 0);
model.study('std7').feature('opt').setIndex('scale', 1, 0);
model.study('std7').feature('opt').setIndex('lbound', '', 0);
model.study('std7').feature('opt').setIndex('ubound', '', 0);
model.study('std7').feature('opt').setIndex('punit', '', 0);
model.study('std7').feature('opt').setIndex('pname', 'D', 1);
model.study('std7').feature('opt').setIndex('initval', '200[mm]', 1);
model.study('std7').feature('opt').setIndex('scale', 1, 1);
model.study('std7').feature('opt').setIndex('lbound', '', 1);
model.study('std7').feature('opt').setIndex('ubound', '', 1);
model.study('std7').feature('opt').setIndex('punit', '', 1);
model.study('std7').feature('opt').setIndex('pname', 'D', 1);
model.study('std7').feature('opt').setIndex('initval', '200[mm]', 1);
model.study('std7').feature('opt').setIndex('scale', 1, 1);
model.study('std7').feature('opt').setIndex('lbound', '', 1);
model.study('std7').feature('opt').setIndex('ubound', '', 1);
model.study('std7').feature('opt').setIndex('punit', '', 1);
model.study('std7').feature('opt').setIndex('pname', 'delta_th', 2);
model.study('std7').feature('opt').setIndex('initval', '10[deg]', 2);
model.study('std7').feature('opt').setIndex('scale', 1, 2);
model.study('std7').feature('opt').setIndex('lbound', '', 2);
model.study('std7').feature('opt').setIndex('ubound', '', 2);
model.study('std7').feature('opt').setIndex('punit', '', 2);
model.study('std7').feature('opt').setIndex('pname', 'delta_th', 2);
model.study('std7').feature('opt').setIndex('initval', '10[deg]', 2);
model.study('std7').feature('opt').setIndex('scale', 1, 2);
model.study('std7').feature('opt').setIndex('lbound', '', 2);
model.study('std7').feature('opt').setIndex('ubound', '', 2);
model.study('std7').feature('opt').setIndex('punit', '', 2);
model.study('std7').feature('opt').setIndex('pname', 'dis_c2_x1', 3);
model.study('std7').feature('opt').setIndex('initval', 'dis_c2_xmin+(dis_c2_xmax-dis_c2_xmin)*dis_c2_x1n', 3);
model.study('std7').feature('opt').setIndex('scale', 1, 3);
model.study('std7').feature('opt').setIndex('lbound', '', 3);
model.study('std7').feature('opt').setIndex('ubound', '', 3);
model.study('std7').feature('opt').setIndex('punit', '', 3);
model.study('std7').feature('opt').setIndex('pname', 'dis_c2_x1', 3);
model.study('std7').feature('opt').setIndex('initval', 'dis_c2_xmin+(dis_c2_xmax-dis_c2_xmin)*dis_c2_x1n', 3);
model.study('std7').feature('opt').setIndex('scale', 1, 3);
model.study('std7').feature('opt').setIndex('lbound', '', 3);
model.study('std7').feature('opt').setIndex('ubound', '', 3);
model.study('std7').feature('opt').setIndex('punit', '', 3);
model.study('std7').feature('opt').setIndex('pname', 'dis_c2_x1n', 4);
model.study('std7').feature('opt').setIndex('initval', '-dis_c2_xmin/(dis_c2_xmax-dis_c2_xmin)', 4);
model.study('std7').feature('opt').setIndex('scale', 1, 4);
model.study('std7').feature('opt').setIndex('lbound', '', 4);
model.study('std7').feature('opt').setIndex('ubound', '', 4);
model.study('std7').feature('opt').setIndex('punit', '', 4);
model.study('std7').feature('opt').setIndex('pname', 'dis_c2_x1n', 4);
model.study('std7').feature('opt').setIndex('initval', '-dis_c2_xmin/(dis_c2_xmax-dis_c2_xmin)', 4);
model.study('std7').feature('opt').setIndex('scale', 1, 4);
model.study('std7').feature('opt').setIndex('lbound', '', 4);
model.study('std7').feature('opt').setIndex('ubound', '', 4);
model.study('std7').feature('opt').setIndex('punit', '', 4);
model.study('std7').feature('opt').setIndex('pname', 'dis_c2_x2', 5);
model.study('std7').feature('opt').setIndex('initval', 'dis_c2_xmin+(dis_c2_xmax-dis_c2_xmin)*dis_c2_x2n', 5);
model.study('std7').feature('opt').setIndex('scale', 1, 5);
model.study('std7').feature('opt').setIndex('lbound', '', 5);
model.study('std7').feature('opt').setIndex('ubound', '', 5);
model.study('std7').feature('opt').setIndex('punit', '', 5);
model.study('std7').feature('opt').setIndex('pname', 'dis_c2_x2', 5);
model.study('std7').feature('opt').setIndex('initval', 'dis_c2_xmin+(dis_c2_xmax-dis_c2_xmin)*dis_c2_x2n', 5);
model.study('std7').feature('opt').setIndex('scale', 1, 5);
model.study('std7').feature('opt').setIndex('lbound', '', 5);
model.study('std7').feature('opt').setIndex('ubound', '', 5);
model.study('std7').feature('opt').setIndex('punit', '', 5);
model.study('std7').feature('opt').setIndex('pname', 'dis_c2_x2n', 6);
model.study('std7').feature('opt').setIndex('initval', '-dis_c2_xmin/(dis_c2_xmax-dis_c2_xmin)', 6);
model.study('std7').feature('opt').setIndex('scale', 1, 6);
model.study('std7').feature('opt').setIndex('lbound', '', 6);
model.study('std7').feature('opt').setIndex('ubound', '', 6);
model.study('std7').feature('opt').setIndex('punit', '', 6);
model.study('std7').feature('opt').setIndex('pname', 'dis_c2_x2n', 6);
model.study('std7').feature('opt').setIndex('initval', '-dis_c2_xmin/(dis_c2_xmax-dis_c2_xmin)', 6);
model.study('std7').feature('opt').setIndex('scale', 1, 6);
model.study('std7').feature('opt').setIndex('lbound', '', 6);
model.study('std7').feature('opt').setIndex('ubound', '', 6);
model.study('std7').feature('opt').setIndex('punit', '', 6);
model.study('std7').feature('opt').setIndex('pname', 'dis_c2_x3', 7);
model.study('std7').feature('opt').setIndex('initval', 'dis_c2_xmin+(dis_c2_xmax-dis_c2_xmin)*dis_c2_x3n', 7);
model.study('std7').feature('opt').setIndex('scale', 1, 7);
model.study('std7').feature('opt').setIndex('lbound', '', 7);
model.study('std7').feature('opt').setIndex('ubound', '', 7);
model.study('std7').feature('opt').setIndex('punit', '', 7);
model.study('std7').feature('opt').setIndex('pname', 'dis_c2_x3', 7);
model.study('std7').feature('opt').setIndex('initval', 'dis_c2_xmin+(dis_c2_xmax-dis_c2_xmin)*dis_c2_x3n', 7);
model.study('std7').feature('opt').setIndex('scale', 1, 7);
model.study('std7').feature('opt').setIndex('lbound', '', 7);
model.study('std7').feature('opt').setIndex('ubound', '', 7);
model.study('std7').feature('opt').setIndex('punit', '', 7);
model.study('std7').feature('opt').setIndex('pname', 'dis_c2_x3n', 8);
model.study('std7').feature('opt').setIndex('initval', '-dis_c2_xmin/(dis_c2_xmax-dis_c2_xmin)', 8);
model.study('std7').feature('opt').setIndex('scale', 1, 8);
model.study('std7').feature('opt').setIndex('lbound', '', 8);
model.study('std7').feature('opt').setIndex('ubound', '', 8);
model.study('std7').feature('opt').setIndex('punit', '', 8);
model.study('std7').feature('opt').setIndex('pname', 'dis_c2_x3n', 8);
model.study('std7').feature('opt').setIndex('initval', '-dis_c2_xmin/(dis_c2_xmax-dis_c2_xmin)', 8);
model.study('std7').feature('opt').setIndex('scale', 1, 8);
model.study('std7').feature('opt').setIndex('lbound', '', 8);
model.study('std7').feature('opt').setIndex('ubound', '', 8);
model.study('std7').feature('opt').setIndex('punit', '', 8);
model.study('std7').feature('opt').setIndex('pname', 'dis_c2_x4', 9);
model.study('std7').feature('opt').setIndex('initval', 'dis_c2_xmin+(dis_c2_xmax-dis_c2_xmin)*dis_c2_x4n', 9);
model.study('std7').feature('opt').setIndex('scale', 1, 9);
model.study('std7').feature('opt').setIndex('lbound', '', 9);
model.study('std7').feature('opt').setIndex('ubound', '', 9);
model.study('std7').feature('opt').setIndex('punit', '', 9);
model.study('std7').feature('opt').setIndex('pname', 'dis_c2_x4', 9);
model.study('std7').feature('opt').setIndex('initval', 'dis_c2_xmin+(dis_c2_xmax-dis_c2_xmin)*dis_c2_x4n', 9);
model.study('std7').feature('opt').setIndex('scale', 1, 9);
model.study('std7').feature('opt').setIndex('lbound', '', 9);
model.study('std7').feature('opt').setIndex('ubound', '', 9);
model.study('std7').feature('opt').setIndex('punit', '', 9);
model.study('std7').feature('opt').setIndex('pname', 'dis_c2_x4n', 10);
model.study('std7').feature('opt').setIndex('initval', '-dis_c2_xmin/(dis_c2_xmax-dis_c2_xmin)', 10);
model.study('std7').feature('opt').setIndex('scale', 1, 10);
model.study('std7').feature('opt').setIndex('lbound', '', 10);
model.study('std7').feature('opt').setIndex('ubound', '', 10);
model.study('std7').feature('opt').setIndex('punit', '', 10);
model.study('std7').feature('opt').setIndex('pname', 'dis_c2_x4n', 10);
model.study('std7').feature('opt').setIndex('initval', '-dis_c2_xmin/(dis_c2_xmax-dis_c2_xmin)', 10);
model.study('std7').feature('opt').setIndex('scale', 1, 10);
model.study('std7').feature('opt').setIndex('lbound', '', 10);
model.study('std7').feature('opt').setIndex('ubound', '', 10);
model.study('std7').feature('opt').setIndex('punit', '', 10);
model.study('std7').feature('opt').setIndex('pname', 'th1_n', 0);
model.study('std7').feature('opt').setIndex('pname', 'th2_n', 1);
model.study('std7').feature('opt').setIndex('pname', 'r1n', 2);
model.study('std7').feature('opt').setIndex('pname', 'r2n', 3);
model.study('std7').feature('opt').setIndex('pname', 'z1_n', 4);
model.study('std7').feature('opt').setIndex('pname', 'z2_n', 5);
model.study('std7').feature('opt').setIndex('pname', 'dis_c2_x1n', 6);
model.study('std7').feature('opt').setIndex('pname', 'dis_c2_x2n', 7);
model.study('std7').feature('opt').setIndex('pname', '', 9);
model.study('std7').feature('opt').setIndex('pname', 'rotat', 10);
model.study('std7').feature('opt').setIndex('pname', 'dis_c2_x4n', 9);
model.study('std7').feature('opt').setIndex('lbound', 0, 0);
model.study('std7').feature('opt').setIndex('ubound', 1, 0);
model.study('std7').feature('opt').setIndex('lbound', 0, 1);
model.study('std7').feature('opt').setIndex('ubound', 1, 1);
model.study('std7').feature('opt').setIndex('lbound', 0, 2);
model.study('std7').feature('opt').setIndex('ubound', 1, 2);
model.study('std7').feature('opt').setIndex('lbound', 0, 3);
model.study('std7').feature('opt').setIndex('ubound', 1, 3);
model.study('std7').feature('opt').setIndex('lbound', 0, 4);
model.study('std7').feature('opt').setIndex('lbound', 0, 5);
model.study('std7').feature('opt').setIndex('ubound', 0, 4);
model.study('std7').feature('opt').setIndex('lbound', 0, 6);
model.study('std7').feature('opt').setIndex('lbound', 0, 7);
model.study('std7').feature('opt').setIndex('ubound', 1, 4);
model.study('std7').feature('opt').setIndex('lbound', 0, 8);
model.study('std7').feature('opt').setIndex('lbound', 0, 9);
model.study('std7').feature('opt').setIndex('lbound', 0, 10);
model.study('std7').feature('opt').setIndex('ubound', 1, 5);
model.study('std7').feature('opt').setIndex('ubound', 1, 6);
model.study('std7').feature('opt').setIndex('ubound', 1, 7);
model.study('std7').feature('opt').setIndex('ubound', 1, 8);
model.study('std7').feature('opt').setIndex('ubound', 1, 9);
model.study('std7').feature('opt').setIndex('ubound', 1, 10);
model.study('std7').feature('opt').setIndex('lbound', '-pi', 10);
model.study('std7').feature('opt').setIndex('ubound', 'pi', 10);
model.study('std7').feature('freq').set('plist', 1483.8);
model.study('std7').feature('opt').set('objtable', 'new');
model.study('std7').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.component('comp1').mesh('mesh1').run('dis1');

model.study('std7').feature('opt').set('probewindow', '');

% Started to run method method1

model.component('comp1').probe('point1').set('probename', 'ph1');
model.component('comp1').probe('point1').set('expr', 'acpr.p_b');
model.component('comp1').probe('point2').set('probename', 'ph2');
model.component('comp1').probe('point2').set('expr', 'acpr.p_b');
model.component('comp1').probe('point3').set('probename', 'ph3');
model.component('comp1').probe('point3').set('expr', 'acpr.p_b');
model.component('comp1').probe('point4').set('probename', 'ph4');
model.component('comp1').probe('point4').set('expr', 'acpr.p_b');
model.component('comp1').probe('point5').set('probename', 'ph5');
model.component('comp1').probe('point5').set('expr', 'acpr.p_b');
model.component('comp1').probe('point6').set('probename', 'ph6');
model.component('comp1').probe('point6').set('expr', 'acpr.p_b');
model.component('comp1').probe('point7').set('probename', 'ph7');
model.component('comp1').probe('point7').set('expr', 'acpr.p_b');
model.component('comp1').probe('point8').set('probename', 'ph8');
model.component('comp1').probe('point8').set('expr', 'acpr.p_b');

% Finished running method method1

model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol518').runAll;

model.result('pg30').run;
model.result.evaluationGroup('eg1').feature('gev1').setIndex('expr', 'Ez1', 0);
model.result.evaluationGroup('eg1').feature('gev1').setIndex('expr', 'Ef1', 1);
model.result.evaluationGroup('eg1').feature('gev1').setIndex('expr', 'Ez0', 2);
model.result.evaluationGroup('eg1').feature('gev1').setIndex('expr', 'Ef0', 3);
model.result.evaluationGroup('eg1').feature('gev1').setIndex('expr', 'Ez_1', 4);
model.result.evaluationGroup('eg1').feature('gev1').setIndex('expr', 'Ef_', 5);
model.result.evaluationGroup('eg1').run;
model.result.evaluationGroup('eg1').set('data', 'dset14');

% Started to run method method1

model.component('comp1').probe('point1').set('probename', 'p1');
model.component('comp1').probe('point1').set('expr', 'acpr.p_b');
model.component('comp1').probe('point2').set('probename', 'p2');
model.component('comp1').probe('point2').set('expr', 'acpr.p_b');
model.component('comp1').probe('point3').set('probename', 'p3');
model.component('comp1').probe('point3').set('expr', 'acpr.p_b');
model.component('comp1').probe('point4').set('probename', 'p4');
model.component('comp1').probe('point4').set('expr', 'acpr.p_b');
model.component('comp1').probe('point5').set('probename', 'p5');
model.component('comp1').probe('point5').set('expr', 'acpr.p_b');
model.component('comp1').probe('point6').set('probename', 'p6');
model.component('comp1').probe('point6').set('expr', 'acpr.p_b');
model.component('comp1').probe('point7').set('probename', 'p7');
model.component('comp1').probe('point7').set('expr', 'acpr.p_b');
model.component('comp1').probe('point8').set('probename', 'p8');
model.component('comp1').probe('point8').set('expr', 'acpr.p_b');

% Finished running method method1

model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol518').runAll;

model.result('pg30').run;
model.result.evaluationGroup('eg1').feature('gev1').setIndex('expr', 'Ef_1', 5);
model.result.evaluationGroup('eg1').run;
model.result.evaluationGroup('eg1').feature('gev1').setIndex('expr', 'Ez1+Ef1', 6);
model.result.evaluationGroup('eg1').run;
model.result.evaluationGroup('eg1').feature('gev1').setIndex('expr', 'Ez_1+Ef_1', 6);
model.result.evaluationGroup('eg1').run;

model.component('comp1').variable('var4').set('Ein_t', '0.29987');

model.result.evaluationGroup('eg1').clearTableData;

model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol518').runAll;

model.result('pg30').run;

% Started to run method method1

model.component('comp1').probe('point1').set('probename', 'p1');
model.component('comp1').probe('point1').set('expr', 'acpr.p_s');
model.component('comp1').probe('point2').set('probename', 'p2');
model.component('comp1').probe('point2').set('expr', 'acpr.p_s');
model.component('comp1').probe('point3').set('probename', 'p3');
model.component('comp1').probe('point3').set('expr', 'acpr.p_s');
model.component('comp1').probe('point4').set('probename', 'p4');
model.component('comp1').probe('point4').set('expr', 'acpr.p_s');
model.component('comp1').probe('point5').set('probename', 'p5');
model.component('comp1').probe('point5').set('expr', 'acpr.p_s');
model.component('comp1').probe('point6').set('probename', 'p6');
model.component('comp1').probe('point6').set('expr', 'acpr.p_s');
model.component('comp1').probe('point7').set('probename', 'p7');
model.component('comp1').probe('point7').set('expr', 'acpr.p_s');
model.component('comp1').probe('point8').set('probename', 'p8');
model.component('comp1').probe('point8').set('expr', 'acpr.p_s');

% Finished running method method1

model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol518').runAll;

model.result('pg30').run;
model.result.numerical('gev2').set('table', 'tbl33');
model.result.table('tbl33').clearTableData;
model.result.numerical('gev2').set('table', 'tbl33');
model.result.numerical('gev2').setResult;

model.study('std7').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.study('std7').feature('opt').set('probewindow', '');
model.study('std8').create('param', 'Parametric');
model.study('std8').feature('param').setIndex('pname', 'c0', 0);
model.study('std8').feature('param').setIndex('plistarr', '', 0);
model.study('std8').feature('param').setIndex('punit', 'm/s', 0);
model.study('std8').feature('param').setIndex('pname', 'c0', 0);
model.study('std8').feature('param').setIndex('plistarr', '', 0);
model.study('std8').feature('param').setIndex('punit', 'm/s', 0);
model.study('std8').feature('param').setIndex('pname', 'rotat', 0);
model.study('std8').feature('param').setIndex('plistarr', 'range(-180,2,180)', 0);
model.study('std8').feature('param').setIndex('punit', 'deg', 0);
model.study('std8').createAutoSequences('all');

model.sol.create('sol521');
model.sol('sol521').study('std8');
model.sol('sol521').label([native2unicode(hex2dec({'53' 'c2'}), 'unicode')  native2unicode(hex2dec({'65' '70'}), 'unicode')  native2unicode(hex2dec({'53' '16'}), 'unicode')  native2unicode(hex2dec({'89' 'e3'}), 'unicode') ' 2']);

model.batch('p2').feature('so1').set('psol', 'sol521');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.result.create('pg34', 'PlotGroup3D');
model.result('pg34').set('data', 'dset18');
model.result('pg34').setIndex('looplevel', 14, 0);
model.result('pg34').create('surf1', 'Surface');
model.result('pg34').feature('surf1').set('expr', {'acpr.p_t'});
model.result('pg34').feature('surf1').set('colortable', 'Wave');
model.result('pg34').feature('surf1').set('colorscalemode', 'linearsymmetric');
model.result('pg34').set('showlegendsunit', true);
model.result('pg34').label([native2unicode(hex2dec({'58' 'f0'}), 'unicode')  native2unicode(hex2dec({'53' '8b'}), 'unicode') ' (acpr)']);
model.result.create('pg35', 'PlotGroup3D');
model.result('pg35').set('data', 'dset18');
model.result('pg35').setIndex('looplevel', 14, 0);
model.result('pg35').create('surf1', 'Surface');
model.result('pg35').feature('surf1').set('expr', {'acpr.Lp_t'});
model.result('pg35').feature('surf1').set('colortable', 'Rainbow');
model.result('pg35').feature('surf1').set('colorscalemode', 'linear');
model.result('pg35').set('showlegendsunit', true);
model.result('pg35').label([native2unicode(hex2dec({'58' 'f0'}), 'unicode')  native2unicode(hex2dec({'53' '8b'}), 'unicode')  native2unicode(hex2dec({'7e' 'a7'}), 'unicode') ' (acpr)']);
model.result.create('pg36', 'PlotGroup3D');
model.result('pg36').set('data', 'dset18');
model.result('pg36').setIndex('looplevel', 14, 0);
model.result('pg36').create('iso1', 'Isosurface');
model.result('pg36').feature('iso1').set('expr', {'acpr.p_t'});
model.result('pg36').feature('iso1').set('number', '10');
model.result('pg36').feature('iso1').set('colortable', 'Wave');
model.result('pg36').feature('iso1').set('colorscalemode', 'linearsymmetric');
model.result('pg36').set('showlegendsunit', true);
model.result('pg36').label([native2unicode(hex2dec({'58' 'f0'}), 'unicode')  native2unicode(hex2dec({'53' '8b'}), 'unicode')  native2unicode(hex2dec({'ff' '0c'}), 'unicode')  native2unicode(hex2dec({'7b' '49'}), 'unicode')  native2unicode(hex2dec({'50' '3c'}), 'unicode')  native2unicode(hex2dec({'97' '62'}), 'unicode') ' (acpr)']);
model.result.remove('pg34');
model.result.remove('pg35');
model.result.remove('pg36');

model.sol('sol1').clearSolutionData;
model.sol('sol2').clearSolutionData;
model.sol('sol3').clearSolutionData;
model.sol('sol4').clearSolutionData;
model.sol('sol5').clearSolutionData;
model.sol('sol6').clearSolutionData;
model.sol('sol518').clearSolutionData;
model.sol('sol519').clearSolutionData;
model.sol('sol520').clearSolutionData;
model.sol('sol521').clearSolutionData;
model.sol('sol522').clearSolutionData;
model.sol('sol523').clearSolutionData;
model.sol('sol524').clearSolutionData;
model.sol('sol525').clearSolutionData;
model.sol('sol526').clearSolutionData;
model.sol('sol527').clearSolutionData;
model.sol('sol528').clearSolutionData;
model.sol('sol529').clearSolutionData;
model.sol('sol530').clearSolutionData;
model.sol('sol531').clearSolutionData;
model.sol('sol532').clearSolutionData;
model.sol('sol533').clearSolutionData;
model.sol('sol534').clearSolutionData;
model.sol('sol535').clearSolutionData;

model.label([native2unicode(hex2dec({'53' 'cc'}), 'unicode')  native2unicode(hex2dec({'5c' '42'}), 'unicode')  native2unicode(hex2dec({'7e' 'd3'}), 'unicode')  native2unicode(hex2dec({'67' '84'}), 'unicode')  native2unicode(hex2dec({'97' '5e'}), 'unicode')  native2unicode(hex2dec({'5b' 'f9'}), 'unicode')  native2unicode(hex2dec({'79' 'f0'}), 'unicode')  native2unicode(hex2dec({'6d' '4b'}), 'unicode')  native2unicode(hex2dec({'8b' 'd5'}), 'unicode') '_' native2unicode(hex2dec({'4e' 'ff'}), 'unicode')  native2unicode(hex2dec({'71' '67'}), 'unicode') 'optic_' native2unicode(hex2dec({'5d' 'e6'}), 'unicode')  native2unicode(hex2dec({'53' 'f3'}), 'unicode')  native2unicode(hex2dec({'62' '4b'}), 'unicode')  native2unicode(hex2dec({'60' '27'}), 'unicode')  native2unicode(hex2dec({'76' 'f8'}), 'unicode')  native2unicode(hex2dec({'54' '0c'}), 'unicode') '_CPA_200.mph']);

model.param('par5').set('th1_n', '0.15273');
model.param('par5').descr('th1_n', '');
model.param('par5').set('th2_n', '0.1');
model.param('par5').descr('th2_n', '');
model.param('par5').set('r1n', '0.59902');
model.param('par5').descr('r1n', '');
model.param('par5').set('r2n', '0.10098');
model.param('par5').descr('r2n', '');
model.param('par5').set('z1_n', '0.81875');
model.param('par5').descr('z1_n', '');
model.param('par5').set('z2_n', '0.1');
model.param('par5').descr('z2_n', '');

model.component('comp1').geom('geom1').run('rmd1');

model.param('par5').set('th1_n', '0.15273');
model.param('par5').descr('th1_n', '');
model.param('par5').set('th2_n', '0.1');
model.param('par5').descr('th2_n', '');
model.param('par5').set('r1n', '0.59902');
model.param('par5').descr('r1n', '');
model.param('par5').set('r2n', '0.10098');
model.param('par5').descr('r2n', '');
model.param('par5').set('z1_n', '0.81875');
model.param('par5').descr('z1_n', '');
model.param('par5').set('z2_n', '0.1');
model.param('par5').descr('z2_n', '');
model.param('par5').set('th1_n', '0.35781');
model.param('par5').descr('th1_n', '');
model.param('par5').set('th2_n', '0.1');
model.param('par5').descr('th2_n', '');
model.param('par5').set('r1n', '0.8');
model.param('par5').descr('r1n', '');
model.param('par5').set('r2n', '0.3');
model.param('par5').descr('r2n', '');
model.param('par5').set('z1_n', '0.47188');
model.param('par5').descr('z1_n', '');
model.param('par5').set('z2_n', '0.30391');
model.param('par5').descr('z2_n', '');
model.param('par4').set('th1_max', '180[deg]');
model.param('par4').descr('th1_max', '');
model.param('par4').set('th1_min', '10[deg]');
model.param('par4').descr('th1_min', '');
model.param('par4').set('r_max', 'lbd/3');
model.param('par4').descr('r_max', '');
model.param('par4').set('r_min', 'lbd/16');
model.param('par4').descr('r_min', '');
model.param('par4').set('z1_min', 'lbd/16');
model.param('par4').descr('z1_min', '');
model.param('par4').set('z1_max', 'lbd/4');
model.param('par4').descr('z1_max', '');
model.param('par4').set('z2_min', 'lbd/16');
model.param('par4').descr('z2_min', '');
model.param('par4').set('z2_max', 'lbd/4');
model.param('par4').descr('z2_max', '');

model.study('std1').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol1').runAll;

model.result('pg30').run;
model.result('pg30').set('data', 'dset1');
model.result('pg30').set('looplevel', [9]);
model.result('pg30').run;
model.result('pg33').set('windowtitle', [native2unicode(hex2dec({'56' 'fe'}), 'unicode')  native2unicode(hex2dec({'5f' '62'}), 'unicode') ]);
model.result.table('evl3').setColumnHeaders({'x' 'y' 'z' 'Value'});
model.result.table('evl3').addRow([-0.07884060712200208 -0.06125573669690359 -0.009416859678987114 -0.7850446220069831], [0 0 0 0]);

model.nodeGroup('grp1').active(true);

model.component('comp1').physics('acpr').feature('mps1').active(false);

model.result('pg30').run;

model.study('std3').feature('freq').set('plist', 1.3466);
model.study('std3').feature('freq').set('disabledphysics', {'acpr/pr1' 'acpr/pr2' 'acpr/mps2' 'acpr/pr3' 'acpr/pr4' 'acpr/bpf2' 'acpr/bpf1'});
model.study('std3').feature('freq').setSolveFor('/physics/opt', false);
model.study('std3').feature('freq').set('disabledphysics', {'acpr/pr1' 'acpr/pr2' 'acpr/pr3' 'acpr/pr4' 'acpr/bpf2' 'acpr/bpf1' 'opt' 'acpr/tvb1'});
model.study('std3').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol3').runAll;

model.result.create('pg34', 'PlotGroup3D');
model.result('pg34').set('data', 'dset3');
model.result('pg34').setIndex('looplevel', 1, 0);
model.result('pg34').create('surf1', 'Surface');
model.result('pg34').feature('surf1').set('expr', {'acpr.p_t'});
model.result('pg34').feature('surf1').set('colortable', 'Wave');
model.result('pg34').feature('surf1').set('colorscalemode', 'linearsymmetric');
model.result('pg34').set('showlegendsunit', true);
model.result('pg34').label([native2unicode(hex2dec({'58' 'f0'}), 'unicode')  native2unicode(hex2dec({'53' '8b'}), 'unicode') ' (acpr)']);
model.result.create('pg35', 'PlotGroup3D');
model.result('pg35').set('data', 'dset3');
model.result('pg35').setIndex('looplevel', 1, 0);
model.result('pg35').create('surf1', 'Surface');
model.result('pg35').feature('surf1').set('expr', {'acpr.Lp_t'});
model.result('pg35').feature('surf1').set('colortable', 'Rainbow');
model.result('pg35').feature('surf1').set('colorscalemode', 'linear');
model.result('pg35').set('showlegendsunit', true);
model.result('pg35').label([native2unicode(hex2dec({'58' 'f0'}), 'unicode')  native2unicode(hex2dec({'53' '8b'}), 'unicode')  native2unicode(hex2dec({'7e' 'a7'}), 'unicode') ' (acpr)']);
model.result.create('pg36', 'PlotGroup3D');
model.result('pg36').set('data', 'dset3');
model.result('pg36').setIndex('looplevel', 1, 0);
model.result('pg36').create('iso1', 'Isosurface');
model.result('pg36').feature('iso1').set('expr', {'acpr.p_t'});
model.result('pg36').feature('iso1').set('number', '10');
model.result('pg36').feature('iso1').set('colortable', 'Wave');
model.result('pg36').feature('iso1').set('colorscalemode', 'linearsymmetric');
model.result('pg36').set('showlegendsunit', true);
model.result('pg36').label([native2unicode(hex2dec({'58' 'f0'}), 'unicode')  native2unicode(hex2dec({'53' '8b'}), 'unicode')  native2unicode(hex2dec({'ff' '0c'}), 'unicode')  native2unicode(hex2dec({'7b' '49'}), 'unicode')  native2unicode(hex2dec({'50' '3c'}), 'unicode')  native2unicode(hex2dec({'97' '62'}), 'unicode') ' (acpr)']);
model.result('pg34').run;
model.result('pg34').run;
model.result('pg34').feature('surf1').set('rangecoloractive', true);
model.result('pg34').feature('surf1').set('rangecolormin', -10);
model.result('pg34').feature('surf1').set('rangecolormax', 1);
model.result('pg34').feature('surf1').set('rangecolormin', -1);
model.result('pg34').run;

model.param('par5').set('th1_n', '0.2');
model.param('par5').descr('th1_n', '');
model.param('par5').set('th2_n', '0.2');
model.param('par5').descr('th2_n', '');
model.param('par5').set('r1n', '0.45');
model.param('par5').descr('r1n', '');
model.param('par5').set('r2n', '0.99687');
model.param('par5').descr('r2n', '');
model.param('par5').set('z1_n', '0.89922');
model.param('par5').descr('z1_n', '');
model.param('par5').set('z2_n', '0.20391');
model.param('par5').descr('z2_n', '');

model.study('std1').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol1').runAll;

model.result('pg30').run;
model.result('pg30').set('looplevel', [8]);
model.result('pg30').run;

model.param('par7').paramCase.create('case1');
model.param('par5').paramCase.create('case1');
model.param('par4').paramCase.create('case1');
model.param('par4').paramCase('case1').label([native2unicode(hex2dec({'72' '79'}), 'unicode')  native2unicode(hex2dec({'5f' '81'}), 'unicode')  native2unicode(hex2dec({'98' '91'}), 'unicode')  native2unicode(hex2dec({'73' '87'}), 'unicode')  native2unicode(hex2dec({'52' '06'}), 'unicode')  native2unicode(hex2dec({'67' '90'}), 'unicode') ]);

model.study.remove('std2');
model.study.remove('std4');
model.study('std7').label('Opti');

model.component('comp1').physics('acpr').feature('mps2').selection.set([1]);

model.result('pg30').run;

model.study('std3').feature('freq').set('plist', 1.4792);
model.study('std3').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol3').runAll;

model.result('pg34').run;
model.result.evaluationGroup('eg1').run;
model.result.evaluationGroup('eg1').set('data', 'dset3');
model.result.evaluationGroup('eg1').run;
model.result.evaluationGroup('eg1').feature('gev1').setIndex('expr', 'Ez1/', 0);
model.result.evaluationGroup('eg1').feature('gev1').setIndex('expr', 'Ez1/(Ez1+Ez_1+Ez0)', 0);
model.result.evaluationGroup('eg1').feature('gev1').setIndex('expr', 'Ef1/(Ef1+Ef_1+Ef0)', 1);
model.result.evaluationGroup('eg1').clearTableData;
model.result.evaluationGroup('eg1').run;
model.result.evaluationGroup('eg1').feature('gev1').remove('unit', [2 3 4 5 6]);
model.result.evaluationGroup('eg1').feature('gev1').remove('descr', [2 3 4 5 6]);
model.result.evaluationGroup('eg1').feature('gev1').remove('expr', [2 3 4 5 6]);
model.result.numerical.create('pev9', 'EvalPoint');
model.result.numerical.remove('pev9');
model.result.numerical.create('gev3', 'EvalGlobal');
model.result.numerical('gev3').setIndex('expr', 'Ez1/(Ez1+Ez_1+Ez0)', 0);
model.result.numerical('gev3').setIndex('unit', 1, 0);
model.result.numerical('gev3').setIndex('descr', '', 0);
model.result.numerical('gev3').setIndex('expr', 'Ef1/(Ef1+Ef_1+Ef0)', 1);
model.result.numerical('gev3').setIndex('unit', 1, 1);
model.result.numerical('gev3').setIndex('descr', '', 1);
model.result.numerical('gev3').set('data', 'dset3');
model.result.numerical('gev3').label([native2unicode(hex2dec({'8f' '90'}), 'unicode')  native2unicode(hex2dec({'5c' '04'}), 'unicode') ]);
model.result.table.create('tbl36', 'Table');
model.result.table('tbl36').comments([native2unicode(hex2dec({'8f' '90'}), 'unicode')  native2unicode(hex2dec({'5c' '04'}), 'unicode') ' {gev3}']);
model.result.numerical('gev3').set('table', 'tbl36');
model.result.numerical('gev3').setResult;
model.result.table.clear;
model.result.table.create('tbl1', 'Table');
model.result.table('tbl1').comments([native2unicode(hex2dec({'8f' '90'}), 'unicode')  native2unicode(hex2dec({'5c' '04'}), 'unicode') ' {gev3}']);
model.result.numerical('gev3').set('table', 'tbl1');
model.result.numerical('gev3').setResult;
model.result.table('tbl1').label([native2unicode(hex2dec({'8f' '90'}), 'unicode')  native2unicode(hex2dec({'5c' '04'}), 'unicode')  native2unicode(hex2dec({'65' 'e0'}), 'unicode')  native2unicode(hex2dec({'70' 'ed'}), 'unicode')  native2unicode(hex2dec({'9e' 'cf'}), 'unicode') ]);

model.study('std3').feature('freq').set('disabledphysics', {'acpr/pr1' 'acpr/pr2' 'acpr/pr3' 'acpr/pr4' 'acpr/bpf2' 'acpr/bpf1' 'opt'});
model.study('std3').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol3').runAll;

model.result('pg34').run;

model.component('comp1').physics('acpr').feature('tvb1').selection.set([1 2 3 4 5 6 7 8 9 10 11 12 13 17 18 20 21 23 24 26 27 28 30 31 32 34 35 37 38 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 61 62 63 64 65 66 68 69 70 71 72 73 74 75 76 77 78 81 82 83 86 89 90 91 93 94 95 96 97 99 100 101 103 104 106 107 108 109 110]);

model.study('std3').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol3').runAll;

model.result('pg34').run;
model.result.table.create('tbl3', 'Table');
model.result.table('tbl3').comments([native2unicode(hex2dec({'8f' '90'}), 'unicode')  native2unicode(hex2dec({'5c' '04'}), 'unicode') ' {gev3}']);
model.result.numerical('gev3').set('table', 'tbl3');
model.result.numerical('gev3').setResult;
model.result.table('tbl3').label([native2unicode(hex2dec({'8f' '90'}), 'unicode')  native2unicode(hex2dec({'5c' '04'}), 'unicode')  native2unicode(hex2dec({'70' 'ed'}), 'unicode')  native2unicode(hex2dec({'9e' 'cf'}), 'unicode') ]);

model.study('std8').label('CPA');
model.study('std8').feature('param').active(false);
model.study('std8').feature('freq').set('punit', 'kHz');
model.study('std8').feature('freq').set('plist', 1.4792);
model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol518').runAll;

model.result('pg31').run;
model.result('pg30').run;
model.result('pg30').set('data', 'dset14');
model.result('pg30').run;
model.result('pg30').run;
model.result('pg30').feature('surf1').set('expr', 'acpr.p_b');
model.result('pg30').feature('surf1').set('rangecoloractive', true);
model.result('pg30').feature('surf1').set('rangecolormin', -1);
model.result('pg30').feature('surf1').set('rangecolormax', 1);
model.result('pg30').run;
model.result('pg30').run;
model.result('pg30').run;
model.result('pg30').feature('surf1').set('expr', 'acpr.p_s');
model.result('pg30').run;
model.result('pg30').run;
model.result.table.create('tbl4', 'Table');
model.result.table('tbl4').comments([native2unicode(hex2dec({'51' '68'}), 'unicode')  native2unicode(hex2dec({'5c' '40'}), 'unicode')  native2unicode(hex2dec({'8b' 'a1'}), 'unicode')  native2unicode(hex2dec({'7b' '97'}), 'unicode') ' 2 {gev2}']);
model.result.numerical('gev2').set('table', 'tbl4');
model.result.numerical('gev2').setResult;

% Started to run method method1

model.component('comp1').probe('point1').set('probename', 'p1');
model.component('comp1').probe('point1').set('expr', 'acpr.p_b');
model.component('comp1').probe('point2').set('probename', 'p2');
model.component('comp1').probe('point2').set('expr', 'acpr.p_b');
model.component('comp1').probe('point3').set('probename', 'p3');
model.component('comp1').probe('point3').set('expr', 'acpr.p_b');
model.component('comp1').probe('point4').set('probename', 'p4');
model.component('comp1').probe('point4').set('expr', 'acpr.p_b');
model.component('comp1').probe('point5').set('probename', 'p5');
model.component('comp1').probe('point5').set('expr', 'acpr.p_b');
model.component('comp1').probe('point6').set('probename', 'p6');
model.component('comp1').probe('point6').set('expr', 'acpr.p_b');
model.component('comp1').probe('point7').set('probename', 'p7');
model.component('comp1').probe('point7').set('expr', 'acpr.p_b');
model.component('comp1').probe('point8').set('probename', 'p8');
model.component('comp1').probe('point8').set('expr', 'acpr.p_b');

% Finished running method method1

model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');

model.sol('sol518').runAll;

model.result('pg30').run;
model.result.numerical.create('pev9', 'EvalPoint');
model.result.numerical.remove('pev9');
model.result.numerical.create('gev4', 'EvalGlobal');
model.result.numerical('gev4').set('expr', {});
model.result.numerical('gev4').set('descr', {});
model.result.numerical('gev4').setIndex('expr', '(Ez1+Ez_1+Ez0)', 0);
model.result.numerical('gev4').setIndex('expr', '(Ef1+Ef_1+Ef0)', 1);
model.result.numerical('gev4').set('data', 'dset14');
model.result.table.create('tbl5', 'Table');
model.result.table('tbl5').comments([native2unicode(hex2dec({'51' '68'}), 'unicode')  native2unicode(hex2dec({'5c' '40'}), 'unicode')  native2unicode(hex2dec({'8b' 'a1'}), 'unicode')  native2unicode(hex2dec({'7b' '97'}), 'unicode') ' 4 {gev4}']);
model.result.numerical('gev4').set('table', 'tbl5');
model.result.numerical('gev4').setResult;
model.result.numerical('gev4').setIndex('expr', '(Ez1+Ez_1+Ez0)*2', 0);
model.result.numerical('gev4').set('table', 'tbl5');
model.result.numerical('gev4').appendResult;

model.component('comp1').variable('var4').set('Ein_t', '0.9815');
model.component('comp1').variable.create('var5');

model.nodeGroup('grp3').add('variable', 'var5');

model.component('comp1').variable.remove('var5');

model.component('comp1').probe.duplicate('point9', 'point1');

model.nodeGroup('grp3').add('probe', 'point9');

model.component('comp1').probe.duplicate('point10', 'point2');

model.nodeGroup('grp3').add('probe', 'point10');

model.component('comp1').probe.duplicate('point11', 'point3');

model.nodeGroup('grp3').add('probe', 'point11');

model.component('comp1').probe.duplicate('point12', 'point4');

model.nodeGroup('grp3').add('probe', 'point12');

model.component('comp1').probe.duplicate('point13', 'point5');

model.nodeGroup('grp3').add('probe', 'point13');

model.component('comp1').probe.duplicate('point14', 'point6');

model.nodeGroup('grp3').add('probe', 'point14');

model.component('comp1').probe.duplicate('point15', 'point7');

model.nodeGroup('grp3').add('probe', 'point15');

model.component('comp1').probe.duplicate('point16', 'point8');

model.nodeGroup('grp3').add('probe', 'point16');

% Started to run method method1

model.component('comp1').probe('point9').set('probename', 'p9');
model.component('comp1').probe('point9').set('expr', 'acpr.p_s');
model.component('comp1').probe('point10').set('probename', 'p10');
model.component('comp1').probe('point10').set('expr', 'acpr.p_s');
model.component('comp1').probe('point11').set('probename', 'p11');
model.component('comp1').probe('point11').set('expr', 'acpr.p_s');
model.component('comp1').probe('point12').set('probename', 'p12');
model.component('comp1').probe('point12').set('expr', 'acpr.p_s');
model.component('comp1').probe('point13').set('probename', 'p13');
model.component('comp1').probe('point13').set('expr', 'acpr.p_s');
model.component('comp1').probe('point14').set('probename', 'p14');
model.component('comp1').probe('point14').set('expr', 'acpr.p_s');
model.component('comp1').probe('point15').set('probename', 'p15');
model.component('comp1').probe('point15').set('expr', 'acpr.p_s');
model.component('comp1').probe('point16').set('probename', 'p16');
model.component('comp1').probe('point16').set('expr', 'acpr.p_s');

% Finished running method method1

model.component('comp1').variable('var2').label('Mode_Ein');
model.component('comp1').variable('var4').set('Ein_t', '(Ez1+Ez_1+Ez0)*2');
model.component('comp1').variable.create('var5');
model.component('comp1').variable.move('var5', 2);
model.component('comp1').variable('var5').label('Mode_out');
model.component('comp1').variable('var5').set('az1', '(p1*exp(-1*j*1*0*pi)+p2*exp(-1*j*1*0.5*pi)+p3*exp(-1*j*1*1*pi)+p4*exp(-1*j*1*1.5*pi))/4');
model.component('comp1').variable('var5').descr('az1', '');
model.component('comp1').variable('var5').set('az0', '(p1*exp(-1*j*0*0*pi)+p2*exp(-1*j*0*0.5*pi)+p3*exp(-1*j*0*1*pi)+p4*exp(-1*j*0*1.5*pi))/4');
model.component('comp1').variable('var5').descr('az0', '');
model.component('comp1').variable('var5').set('az_1', '(p1*exp(-1*j*-1*0*pi)+p2*exp(-1*j*-1*0.5*pi)+p3*exp(-1*j*-1*1*pi)+p4*exp(-1*j*-1*1.5*pi))/4');
model.component('comp1').variable('var5').descr('az_1', '');
model.component('comp1').variable('var5').set('Ez1', 'real((abs(az1/besselj(1,1.8412)))^2*kz10*pi*R0^2*(1-(1/1.8412)^2)*(besselj(1,1.8412))^2)');
model.component('comp1').variable('var5').descr('Ez1', '');
model.component('comp1').variable('var5').set('Ez0', 'real((abs(az0/besselj(0,0)))^2*kz00*pi*R0^2)');
model.component('comp1').variable('var5').descr('Ez0', '');
model.component('comp1').variable('var5').set('Ez_1', 'real((abs(az_1/besselj(1,1.8412)))^2*kz10*pi*R0^2*(1-(1/1.8412)^2)*(besselj(1,1.8412))^2)');
model.component('comp1').variable('var5').descr('Ez_1', '');
model.component('comp1').variable('var5').set('af_1', '(p5*exp(-1*j*1*0*pi)+p6*exp(-1*j*1*0.5*pi)+p7*exp(-1*j*1*1*pi)+p8*exp(-1*j*1*1.5*pi))/4');
model.component('comp1').variable('var5').descr('af_1', '');
model.component('comp1').variable('var5').set('af0', '(p5*exp(-1*j*0*0*pi)+p6*exp(-1*j*0*0.5*pi)+p7*exp(-1*j*0*1*pi)+p8*exp(-1*j*0*1.5*pi))/4');
model.component('comp1').variable('var5').descr('af0', '');
model.component('comp1').variable('var5').set('af1', '(p5*exp(-1*j*-1*0*pi)+p6*exp(-1*j*-1*0.5*pi)+p7*exp(-1*j*-1*1*pi)+p8*exp(-1*j*-1*1.5*pi))/4');
model.component('comp1').variable('var5').descr('af1', '');
model.component('comp1').variable('var5').set('Ef1', 'real((abs(af1/besselj(1,1.8412)))^2*kz10*pi*R0^2*(1-(1/1.8412)^2)*(besselj(1,1.8412))^2)');
model.component('comp1').variable('var5').descr('Ef1', '');
model.component('comp1').variable('var5').set('Ef0', 'real((abs(af0/besselj(0,0)))^2*kz00*pi*R0^2)');
model.component('comp1').variable('var5').descr('Ef0', '');
model.component('comp1').variable('var5').set('Ef_1', 'real((abs(af_1/besselj(1,1.8412)))^2*kz10*pi*R0^2*(1-(1/1.8412)^2)*(besselj(1,1.8412))^2)');
model.component('comp1').variable('var5').descr('Ef_1', '');
model.component('comp1').variable('var5').rename('az1', 'aoz1');
model.component('comp1').variable('var5').rename('az0', 'aoz0');
model.component('comp1').variable('var5').rename('az_1', 'aoz_1');
model.component('comp1').variable('var5').rename('Ez1', 'Eoz1');
model.component('comp1').variable('var5').rename('Ez0', 'Eoz0');
model.component('comp1').variable('var5').rename('Ez_1', 'Eoz_1');
model.component('comp1').variable('var5').rename('af_1', 'aof_1');
model.component('comp1').variable('var5').rename('af0', 'aof0');
model.component('comp1').variable('var5').rename('af1', 'aof1');
model.component('comp1').variable('var5').rename('Ef1', 'Eof1');
model.component('comp1').variable('var5').rename('Ef0', 'Eof0');
model.component('comp1').variable('var5').rename('Ef_1', 'Eof_1');
model.component('comp1').variable('var5').set('aoz1', '(p9*exp(-1*j*1*0*pi)+p10*exp(-1*j*1*0.5*pi)+p11*exp(-1*j*1*1*pi)+p12*exp(-1*j*1*1.5*pi))/4');
model.component('comp1').variable('var5').set('aoz0', '(p9*exp(-1*j*0*0*pi)+p10*exp(-1*j*0*0.5*pi)+p11*exp(-1*j*0*1*pi)+p12*exp(-1*j*0*1.5*pi))/4');
model.component('comp1').variable('var5').set('aoz_1', '(p9*exp(-1*j*-1*0*pi)+p10*exp(-1*j*-1*0.5*pi)+p11*exp(-1*j*-1*1*pi)+p12*exp(-1*j*-1*1.5*pi))/4');
model.component('comp1').variable('var5').set('Eoz1', 'real((abs(aoz1/besselj(1,1.8412)))^2*kz10*pi*R0^2*(1-(1/1.8412)^2)*(besselj(1,1.8412))^2)');
model.component('comp1').variable('var5').set('Eoz0', 'real((abs(aoz0/besselj(0,0)))^2*kz00*pi*R0^2)');
model.component('comp1').variable('var5').set('Eoz_1', 'real((abs(aoz_1/besselj(1,1.8412)))^2*kz10*pi*R0^2*(1-(1/1.8412)^2)*(besselj(1,1.8412))^2)');
model.component('comp1').variable('var5').set('aof_1', '(p13*exp(-1*j*0*0*pi)+p14*exp(-1*j*0*0.5*pi)+p15*exp(-1*j*0*1*pi)+p16*exp(-1*j*0*1.5*pi))/4');
model.component('comp1').variable('var5').set('aof0', '(p13*exp(-1*j*0*0*pi)+p14*exp(-1*j*0*0.5*pi)+p15*exp(-1*j*0*1*pi)+p16*exp(-1*j*0*1.5*pi))/4');
model.component('comp1').variable('var5').set('aof1', '(p13*exp(-1*j*0*0*pi)+p14*exp(-1*j*0*0.5*pi)+p15*exp(-1*j*0*1*pi)+p16*exp(-1*j*0*1.5*pi))/4');
model.component('comp1').variable('var5').set('Eof1', 'real((abs(aof1/besselj(1,1.8412)))^2*kz10*pi*R0^2*(1-(1/1.8412)^2)*(besselj(1,1.8412))^2)');
model.component('comp1').variable('var5').set('Eof0', 'real((abs(aof0/besselj(0,0)))^2*kz00*pi*R0^2)');
model.component('comp1').variable('var5').set('Eof_1', 'real((abs(aof_1/besselj(1,1.8412)))^2*kz10*pi*R0^2*(1-(1/1.8412)^2)*(besselj(1,1.8412))^2)');
model.component('comp1').variable('var4').set('Ein_t', '(Ez1+Ez_1+Ez0)*2/1[kg^2/(m*s^4)]');
model.component('comp1').variable('var4').set('Eout', '(Eoz1+Eoz0+Eoz_1+Eof1+Eof0+Eof_1)/1[kg^2/(m*s^4)]');

model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

% Started to run method method1

model.component('comp1').probe('point9').set('probename', 'po9');
model.component('comp1').probe('point9').set('expr', 'acpr.p_s');
model.component('comp1').probe('point10').set('probename', 'po10');
model.component('comp1').probe('point10').set('expr', 'acpr.p_s');
model.component('comp1').probe('point11').set('probename', 'po11');
model.component('comp1').probe('point11').set('expr', 'acpr.p_s');
model.component('comp1').probe('point12').set('probename', 'po12');
model.component('comp1').probe('point12').set('expr', 'acpr.p_s');
model.component('comp1').probe('point13').set('probename', 'po13');
model.component('comp1').probe('point13').set('expr', 'acpr.p_s');
model.component('comp1').probe('point14').set('probename', 'po14');
model.component('comp1').probe('point14').set('expr', 'acpr.p_s');
model.component('comp1').probe('point15').set('probename', 'po15');
model.component('comp1').probe('point15').set('expr', 'acpr.p_s');
model.component('comp1').probe('point16').set('probename', 'po16');
model.component('comp1').probe('point16').set('expr', 'acpr.p_s');

% Finished running method method1

model.component('comp1').variable('var5').set('aoz1', '(po9*exp(-1*j*1*0*pi)+po10*exp(-1*j*1*0.5*pi)+po11*exp(-1*j*1*1*pi)+po12*exp(-1*j*1*1.5*pi))/4');
model.component('comp1').variable('var5').set('aoz0', '(po9*exp(-1*j*1*0*pi)+po10*exp(-1*j*1*0.5*pi)+po11*exp(-1*j*1*1*pi)+po12*exp(-1*j*1*1.5*pi))/4');
model.component('comp1').variable('var5').set('aoz_1', '(po9*exp(-1*j*1*0*pi)+po10*exp(-1*j*1*0.5*pi)+po11*exp(-1*j*1*1*pi)+po12*exp(-1*j*1*1.5*pi))/4');
model.component('comp1').variable('var5').set('aof_1', '(po13*exp(-1*j*0*0*pi)+po14*exp(-1*j*0*0.5*pi)+po15*exp(-1*j*0*1*pi)+po16*exp(-1*j*0*1.5*pi))/4');
model.component('comp1').variable('var5').set('aof0', '(po13*exp(-1*j*0*0*pi)+po14*exp(-1*j*0*0.5*pi)+po15*exp(-1*j*0*1*pi)+po16*exp(-1*j*0*1.5*pi))/4');
model.component('comp1').variable('var5').set('aof1', '(po13*exp(-1*j*0*0*pi)+po14*exp(-1*j*0*0.5*pi)+po15*exp(-1*j*0*1*pi)+po16*exp(-1*j*0*1.5*pi))/4');

model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol518').runAll;

model.result('pg30').run;
model.result.numerical('gev2').set('table', 'tbl4');
model.result.numerical('gev2').appendResult;
model.result.table('tbl4').clearTableData;

model.study('std8').feature('freq').set('useadvanceddisable', true);
model.study('std8').feature('freq').set('disabledphysics', {'acpr/mps2'});
model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol518').runAll;

model.result('pg30').run;
model.result.numerical('gev2').label('Alpha');
model.result.numerical('gev2').set('table', 'tbl4');
model.result.numerical('gev2').setResult;
model.result.numerical('gev2').setIndex('expr', 'Ein', 0);
model.result.numerical('gev2').setIndex('expr', 'Eout', 1);
model.result.numerical('gev2').set('table', 'tbl4');
model.result.numerical('gev2').setIndex('expr', 'Ein_t', 0);
model.result.numerical('gev2').set('table', 'tbl4');
model.result.numerical('gev2').appendResult;

model.component('comp1').view('view1').set('renderwireframe', true);

model.result('pg30').run;
model.result('pg30').set('data', 'dset14');
model.result('pg30').run;

% Started to run method method1

model.component('comp1').probe('point9').set('probename', 'po9');
model.component('comp1').probe('point9').set('expr', 'acpr.p_b');
model.component('comp1').probe('point10').set('probename', 'po10');
model.component('comp1').probe('point10').set('expr', 'acpr.p_b');
model.component('comp1').probe('point11').set('probename', 'po11');
model.component('comp1').probe('point11').set('expr', 'acpr.p_b');
model.component('comp1').probe('point12').set('probename', 'po12');
model.component('comp1').probe('point12').set('expr', 'acpr.p_b');
model.component('comp1').probe('point13').set('probename', 'po13');
model.component('comp1').probe('point13').set('expr', 'acpr.p_b');
model.component('comp1').probe('point14').set('probename', 'po14');
model.component('comp1').probe('point14').set('expr', 'acpr.p_b');
model.component('comp1').probe('point15').set('probename', 'po15');
model.component('comp1').probe('point15').set('expr', 'acpr.p_b');
model.component('comp1').probe('point16').set('probename', 'po16');
model.component('comp1').probe('point16').set('expr', 'acpr.p_b');

% Finished running method method1

model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol518').runAll;

model.result('pg30').run;
model.result.numerical('gev2').set('table', 'tbl4');
model.result.numerical('gev2').appendResult;

model.component('comp1').variable('var5').set('aoz0', '(po9*exp(-1*j*0*0*pi)+po10*exp(-1*j*0*0.5*pi)+po11*exp(-1*j*0*1*pi)+po12*exp(-1*j*0*1.5*pi))/4');
model.component('comp1').variable('var5').set('aoz_1', '(po9*exp(-1*j*-1*0*pi)+po10*exp(-1*j*-1*0.5*pi)+po11*exp(-1*j*-1*1*pi)+po12*exp(-1*j*-1*1.5*pi))/4');
model.component('comp1').variable('var5').set('aof_1', '(po13*exp(-1*j*1*0*pi)+po14*exp(-1*j*1*0.5*pi)+po15*exp(-1*j*1*1*pi)+po16*exp(-1*j*1*1.5*pi))/4');
model.component('comp1').variable('var5').set('aof1', '(po13*exp(-1*j*-1*0*pi)+po14*exp(-1*j*-1*0.5*pi)+po15*exp(-1*j*-1*1*pi)+po16*exp(-1*j*-1*1.5*pi))/4');

model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol518').runAll;

model.result('pg30').run;
model.result.numerical('gev2').set('table', 'tbl4');
model.result.numerical('gev2').appendResult;

% Started to run method method1

model.component('comp1').probe('point9').set('probename', 'po9');
model.component('comp1').probe('point9').set('expr', 'acpr.p_s');
model.component('comp1').probe('point10').set('probename', 'po10');
model.component('comp1').probe('point10').set('expr', 'acpr.p_s');
model.component('comp1').probe('point11').set('probename', 'po11');
model.component('comp1').probe('point11').set('expr', 'acpr.p_s');
model.component('comp1').probe('point12').set('probename', 'po12');
model.component('comp1').probe('point12').set('expr', 'acpr.p_s');
model.component('comp1').probe('point13').set('probename', 'po13');
model.component('comp1').probe('point13').set('expr', 'acpr.p_s');
model.component('comp1').probe('point14').set('probename', 'po14');
model.component('comp1').probe('point14').set('expr', 'acpr.p_s');
model.component('comp1').probe('point15').set('probename', 'po15');
model.component('comp1').probe('point15').set('expr', 'acpr.p_s');
model.component('comp1').probe('point16').set('probename', 'po16');
model.component('comp1').probe('point16').set('expr', 'acpr.p_s');

% Finished running method method1

model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol518').runAll;

model.result('pg30').run;
model.result('pg36').set('windowtitle', [native2unicode(hex2dec({'56' 'fe'}), 'unicode')  native2unicode(hex2dec({'5f' '62'}), 'unicode') ]);
model.result('pg35').set('windowtitle', [native2unicode(hex2dec({'56' 'fe'}), 'unicode')  native2unicode(hex2dec({'5f' '62'}), 'unicode') ]);
model.result('pg34').set('windowtitle', [native2unicode(hex2dec({'56' 'fe'}), 'unicode')  native2unicode(hex2dec({'5f' '62'}), 'unicode') ]);
model.result.numerical('gev2').setIndex('expr', 'Alpha', 2);
model.result.numerical('gev2').set('table', 'tbl4');
model.result.numerical('gev2').appendResult;
model.result.table('tbl4').clearTableData;

model.study('std8').feature('param').active(true);

model.sol.remove('sol518');
model.sol.remove('sol521');
model.sol.remove('sol522');
model.sol.remove('sol523');
model.sol.remove('sol524');
model.sol.remove('sol525');
model.sol.remove('sol526');
model.sol.remove('sol527');
model.sol.remove('sol528');
model.sol.remove('sol529');
model.sol.remove('sol530');
model.sol.remove('sol531');
model.sol.remove('sol532');
model.sol.remove('sol533');
model.sol.remove('sol534');
model.sol.remove('sol535');

model.study('std8').showAutoSequences('all');

model.sol('sol521').feature('s1').feature('d1').set('linsolver', 'pardiso');

model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol521').runAll;

model.result.create('pg38', 'PlotGroup3D');
model.result('pg38').set('data', 'dset17');
model.result('pg38').setIndex('looplevel', 181, 0);
model.result('pg38').create('surf1', 'Surface');
model.result('pg38').feature('surf1').set('expr', {'acpr.p_t'});
model.result('pg38').feature('surf1').set('colortable', 'Wave');
model.result('pg38').feature('surf1').set('colorscalemode', 'linearsymmetric');
model.result('pg38').set('showlegendsunit', true);
model.result('pg38').label([native2unicode(hex2dec({'58' 'f0'}), 'unicode')  native2unicode(hex2dec({'53' '8b'}), 'unicode') ' (acpr) 1']);
model.result.create('pg39', 'PlotGroup3D');
model.result('pg39').set('data', 'dset17');
model.result('pg39').setIndex('looplevel', 181, 0);
model.result('pg39').create('surf1', 'Surface');
model.result('pg39').feature('surf1').set('expr', {'acpr.Lp_t'});
model.result('pg39').feature('surf1').set('colortable', 'Rainbow');
model.result('pg39').feature('surf1').set('colorscalemode', 'linear');
model.result('pg39').set('showlegendsunit', true);
model.result('pg39').label([native2unicode(hex2dec({'58' 'f0'}), 'unicode')  native2unicode(hex2dec({'53' '8b'}), 'unicode')  native2unicode(hex2dec({'7e' 'a7'}), 'unicode') ' (acpr) 1']);
model.result.create('pg40', 'PlotGroup3D');
model.result('pg40').set('data', 'dset17');
model.result('pg40').setIndex('looplevel', 181, 0);
model.result('pg40').create('iso1', 'Isosurface');
model.result('pg40').feature('iso1').set('expr', {'acpr.p_t'});
model.result('pg40').feature('iso1').set('number', '10');
model.result('pg40').feature('iso1').set('colortable', 'Wave');
model.result('pg40').feature('iso1').set('colorscalemode', 'linearsymmetric');
model.result('pg40').set('showlegendsunit', true);
model.result('pg40').label([native2unicode(hex2dec({'58' 'f0'}), 'unicode')  native2unicode(hex2dec({'53' '8b'}), 'unicode')  native2unicode(hex2dec({'ff' '0c'}), 'unicode')  native2unicode(hex2dec({'7b' '49'}), 'unicode')  native2unicode(hex2dec({'50' '3c'}), 'unicode')  native2unicode(hex2dec({'97' '62'}), 'unicode') ' (acpr) 1']);
model.result('pg38').run;
model.result.numerical.create('pev17', 'EvalPoint');
model.result.numerical.remove('pev17');
model.result.numerical.create('gev4', 'EvalGlobal');
model.result.numerical('gev4').set('expr', {});
model.result.numerical('gev4').set('descr', {});
model.result.numerical('gev4').setIndex('expr', 'Alpha', 0);
model.result.numerical('gev4').set('data', 'dset17');
model.result.create('pg41', 'PlotGroup1D');
model.result('pg41').run;
model.result('pg41').create('glob1', 'Global');
model.result('pg41').feature('glob1').set('markerpos', 'datapoints');
model.result('pg41').feature('glob1').set('linewidth', 'preference');
model.result('pg41').feature('glob1').set('expr', {});
model.result('pg41').feature('glob1').set('descr', {});
model.result('pg41').feature('glob1').setIndex('expr', 'Alpha', 0);
model.result('pg41').run;
model.result('pg41').set('data', 'dset17');
model.result('pg41').setIndex('looplevelinput', 'manual', 0);
model.result('pg41').run;
model.result('pg41').run;
model.result('pg41').feature('glob1').createTable('tbl6');

model.param.set('rotat', '64[deg]');

model.study('std7').feature('opt').setIndex('initval', '64[deg]', 10);
model.study('std7').feature('opt').setIndex('initval', 0.2, 0);
model.study('std7').feature('opt').setIndex('initval', 0.2, 1);
model.study('std7').feature('opt').setIndex('initval', 0.45, 2);
model.study('std7').feature('opt').setIndex('initval', 0.99687, 3);
model.study('std7').feature('opt').setIndex('initval', 0.89922, 4);
model.study('std7').feature('opt').setIndex('initval', 0.20391, 5);

model.component('comp1').physics('opt').feature('gconstr1').active(false);
model.component('comp1').physics('opt').feature('gconstr2').active(true);
model.component('comp1').physics('opt').feature('gconstr2').set('constraintExpression', 'th1+th2');
model.component('comp1').physics('opt').feature('gconstr2').set('useLowerBound', false);
model.component('comp1').physics('opt').feature('gconstr2').set('useUpperBound', true);
model.component('comp1').physics('opt').feature('gconstr2').set('upperBound', '160[deg]');

model.study('std7').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.study('std7').feature('opt').set('probewindow', '');

model.component('comp1').geom('geom1').run;

model.result.table.create('tbl11', 'Table');
model.result.table('tbl11').comments([native2unicode(hex2dec({'51' '68'}), 'unicode')  native2unicode(hex2dec({'5c' '40'}), 'unicode')  native2unicode(hex2dec({'8b' 'a1'}), 'unicode')  native2unicode(hex2dec({'7b' '97'}), 'unicode') ' 4 {gev4}']);
model.result.numerical('gev4').set('table', 'tbl11');
model.result.numerical('gev4').setResult;
model.result.evaluationGroup('eg1').feature('gev1').set('expr', {});
model.result.evaluationGroup('eg1').feature('gev1').set('descr', {});
model.result.evaluationGroup('eg1').feature('gev1').setIndex('expr', 'Ez1', 0);
model.result.evaluationGroup('eg1').feature('gev1').setIndex('expr', 'Ef1', 1);
model.result.evaluationGroup('eg1').run;

model.component('comp1').physics('acpr').feature('bpf1').selection.set([10 11]);

model.study('std7').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.study('std7').feature('opt').set('probewindow', '');

model.result('pg41').set('windowtitle', [native2unicode(hex2dec({'56' 'fe'}), 'unicode')  native2unicode(hex2dec({'5f' '62'}), 'unicode') ]);
model.result('pg40').set('windowtitle', [native2unicode(hex2dec({'56' 'fe'}), 'unicode')  native2unicode(hex2dec({'5f' '62'}), 'unicode') ]);
model.result('pg39').set('windowtitle', [native2unicode(hex2dec({'56' 'fe'}), 'unicode')  native2unicode(hex2dec({'5f' '62'}), 'unicode') ]);
model.result('pg38').set('windowtitle', [native2unicode(hex2dec({'56' 'fe'}), 'unicode')  native2unicode(hex2dec({'5f' '62'}), 'unicode') ]);

model.study('std7').feature('opt').set('plot', false);
model.study('std7').feature('freq').set('useadvanceddisable', true);
model.study('std7').feature('freq').set('disabledphysics', {'acpr/mps2'});
model.study('std7').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.batch('o1').run('compute');

model.component('comp1').geom('geom1').run;

model.study('std7').feature('opt').set('probewindow', '');

model.result.table.create('tbl12', 'Table');
model.result.table('tbl12').comments([native2unicode(hex2dec({'51' '68'}), 'unicode')  native2unicode(hex2dec({'5c' '40'}), 'unicode')  native2unicode(hex2dec({'8b' 'a1'}), 'unicode')  native2unicode(hex2dec({'7b' '97'}), 'unicode') ' 4 {gev4}']);
model.result.numerical('gev4').set('table', 'tbl12');
model.result.numerical('gev4').setResult;

model.study('std7').feature('opt').setIndex('initval', 0.20145, 0);
model.study('std7').feature('opt').setIndex('initval', 0.19874, 1);
model.study('std7').feature('opt').setIndex('initval', 0.44937, 2);
model.study('std7').feature('opt').setIndex('initval', 0.84296, 3);
model.study('std7').feature('opt').setIndex('initval', 0.90758, 4);
model.study('std7').feature('opt').setIndex('initval', 0.35242, 5);
model.study('std7').feature('opt').setIndex('initval', 0.44429, 6);
model.study('std7').feature('opt').setIndex('initval', 0.44505, 7);
model.study('std7').feature('opt').setIndex('initval', 0.44433, 8);
model.study('std7').feature('opt').setIndex('initval', 0.44474, 9);
model.study('std7').feature('opt').setIndex('initval', 1.1182, 10);

model.sol.remove('sol519');
model.sol.remove('sol520');
model.sol.remove('sol522');

model.batch.remove('o1');
model.batch.remove('p1');

model.study('std7').showAutoSequences('all');

model.sol('sol522').feature('s1').feature('d1').set('linsolver', 'pardiso');

model.study('std7').createAutoSequences('all');

model.sol.create('sol523');
model.sol('sol523').study('std7');
model.sol('sol523').label([native2unicode(hex2dec({'53' 'c2'}), 'unicode')  native2unicode(hex2dec({'65' '70'}), 'unicode')  native2unicode(hex2dec({'53' '16'}), 'unicode')  native2unicode(hex2dec({'89' 'e3'}), 'unicode') ' 1']);

model.batch('p1').feature('so1').set('psol', 'sol523');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.study('std7').feature('opt').set('probewindow', '');
model.study('std7').feature('opt').setIndex('scale', 10, 0);
model.study('std7').feature('opt').setIndex('scale', 10, 1);
model.study('std7').feature('opt').setIndex('scale', 10, 2);
model.study('std7').feature('opt').setIndex('scale', 10, 3);
model.study('std7').feature('opt').setIndex('scale', 10, 4);
model.study('std7').feature('opt').setIndex('scale', 10, 5);
model.study('std7').feature('opt').setIndex('scale', 10, 6);
model.study('std7').feature('opt').setIndex('scale', 10, 7);
model.study('std7').feature('opt').setIndex('scale', 10, 8);
model.study('std7').feature('opt').setIndex('scale', 10, 9);
model.study('std7').feature('opt').setIndex('scale', 10, 10);
model.study('std7').feature('opt').set('objectivesolution', 'max');

model.component('comp1').physics('opt').feature('gconstr2').set('upperBound', '165[deg]');

model.study('std7').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.study('std7').feature('opt').set('probewindow', '');
model.study('std7').feature('opt').remove('initval', 10);
model.study('std7').feature('opt').remove('scale', 10);
model.study('std7').feature('opt').remove('lbound', 10);
model.study('std7').feature('opt').remove('ubound', 10);
model.study('std7').feature('opt').remove('punit', 10);
model.study('std7').feature('opt').remove('pname', [10]);

model.param.set('rotat', '1.1182');

model.study('std7').feature('opt').set('objectivesolution', 'auto');
model.study('std7').feature('opt').set('objtable', 'new');
model.study('std7').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.component('comp1').mesh('mesh1').run('size2');

model.study('std7').feature('opt').set('probewindow', '');

model.sol('sol1').clearSolutionData;
model.sol('sol3').clearSolutionData;
model.sol('sol5').clearSolutionData;
model.sol('sol6').clearSolutionData;
model.sol('sol521').clearSolutionData;
model.sol('sol522').clearSolutionData;
model.sol('sol523').clearSolutionData;

model.label([native2unicode(hex2dec({'53' 'cc'}), 'unicode')  native2unicode(hex2dec({'5c' '42'}), 'unicode')  native2unicode(hex2dec({'7e' 'd3'}), 'unicode')  native2unicode(hex2dec({'67' '84'}), 'unicode')  native2unicode(hex2dec({'97' '5e'}), 'unicode')  native2unicode(hex2dec({'5b' 'f9'}), 'unicode')  native2unicode(hex2dec({'79' 'f0'}), 'unicode')  native2unicode(hex2dec({'6d' '4b'}), 'unicode')  native2unicode(hex2dec({'8b' 'd5'}), 'unicode') '_' native2unicode(hex2dec({'4e' 'ff'}), 'unicode')  native2unicode(hex2dec({'71' '67'}), 'unicode') 'optic_' native2unicode(hex2dec({'5d' 'e6'}), 'unicode')  native2unicode(hex2dec({'53' 'f3'}), 'unicode')  native2unicode(hex2dec({'62' '4b'}), 'unicode')  native2unicode(hex2dec({'60' '27'}), 'unicode')  native2unicode(hex2dec({'76' 'f8'}), 'unicode')  native2unicode(hex2dec({'54' '0c'}), 'unicode') '_CPA_200.mph']);

model.result('pg38').run;
model.result('pg35').run;
model.result('pg34').run;

model.component('comp1').geom('geom1').run('rmd1');

model.component('comp1').view('view1').set('renderwireframe', false);

model.study('std3').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol3').runAll;

model.result('pg34').run;

model.component('comp1').variable('var4').set('Ein_t', '0.1129');
model.component('comp1').variable('var4').descr('Ein_t', '');
model.component('comp1').variable('var4').set('Eout', '(Ez1+Ez0+Ez_1+Ef1+Ef0+Ef_1)/1[kg^2/(m*s^4)]');
model.component('comp1').variable('var4').descr('Eout', '');
model.component('comp1').variable('var4').set('Rt', 'Eout/Ein_t');
model.component('comp1').variable('var4').descr('Rt', '');
model.component('comp1').variable('var4').set('Alpha', '1-Rt');
model.component('comp1').variable('var4').descr('Alpha', '');
model.component('comp1').variable('var4').set('Forward', 'Ez1/(Ez1+Ez0+Ez_1)');
model.component('comp1').variable('var4').descr('Forward', '');
model.component('comp1').variable('var4').set('Backward', 'Ef1/(Ef1+Ef0+Ef_1)');
model.component('comp1').variable('var4').descr('Backward', '');
model.component('comp1').variable('var4').set('opti', 'abs(1-Forward)+abs(1-Backward)');
model.component('comp1').variable('var4').descr('opti', '');
model.component('comp1').variable('var4').set('a1', 'abs(1-Forward)');
model.component('comp1').variable('var4').descr('a1', '');
model.component('comp1').variable('var4').set('b1', 'abs(1-Backward)');
model.component('comp1').variable('var4').descr('b1', '');
model.component('comp1').variable('var4').set('opti1', 'max(a1,b1)+0.03*(a1+b1)');
model.component('comp1').variable('var4').descr('opti1', '');
model.component('comp1').variable('var4').set('F1', 'Ez1/(1e-4[W])');
model.component('comp1').variable('var4').descr('F1', '');
model.component('comp1').variable('var4').set('B1', 'Ef1/(1e-4[W])');
model.component('comp1').variable('var4').descr('B1', '');
model.component('comp1').variable('var4').set('ef', '200*a1');
model.component('comp1').variable('var4').descr('ef', '');
model.component('comp1').variable('var4').set('eb', '200*b1');
model.component('comp1').variable('var4').descr('eb', '');
model.component('comp1').variable('var4').set('ep1', 'max(0,110-F1)/110');
model.component('comp1').variable('var4').descr('ep1', '');
model.component('comp1').variable('var4').set('ep2', 'max(0,110-B1)/110');
model.component('comp1').variable('var4').descr('ep2', '');
model.component('comp1').variable('var4').set('opti3', 'max(max(ef,eb),max(ep1,ep2))+0.02*(ef+eb+ep1+ep2)');
model.component('comp1').variable('var4').descr('opti3', '');
model.component('comp1').variable('var4').set('ebal1', 'abs(Forward-Backward)');
model.component('comp1').variable('var4').descr('ebal1', '');
model.component('comp1').variable('var4').set('ebal2', 'abs(F1-B1)/100');
model.component('comp1').variable('var4').descr('ebal2', '');
model.component('comp1').variable('var4').set('opti4', 'max(max(ef,eb),max(ep1,ep2))+0.02*(ef+eb+ep1+ep2)+ebal1+0.5*ebal2');
model.component('comp1').variable('var4').descr('opti4', '');
model.component('comp1').variable('var4').set('opti5', 'max(max(ef,eb),max(ep1,ep2))+0.01*(ef+eb+ep1+ep2)+ebal1');
model.component('comp1').variable('var4').descr('opti5', '');
model.component('comp1').variable('var4').set('opti6', 'max(max(ef,eb),20*max(ep1,ep2))+0.02*(ef+eb)+0.2*(ep1+ep2)');
model.component('comp1').variable('var4').descr('opti6', '');
model.component('comp1').variable('var4').set('opti7', 'max(max(ef,eb),20*max(ep1,ep2))+0.02*(ef+eb)+0.2*(ep1+ep2)+10*ebal1+0.2*ebal2');
model.component('comp1').variable('var4').descr('opti7', '');

model.study('std3').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol3').runAll;

model.result('pg34').run;
model.result.numerical('gev3').set('table', 'tbl3');
model.result.numerical('gev3').appendResult;
model.result.numerical('gev3').setIndex('expr', 'F', 0);
model.result.numerical('gev3').setIndex('expr', 'F1', 0);
model.result.numerical('gev3').setIndex('expr', 'B1', 1);
model.result.numerical('gev3').setIndex('expr', 'Forward', 0);
model.result.numerical('gev3').setIndex('expr', 'Backward', 1);
model.result.numerical('gev3').set('table', 'tbl3');
model.result.numerical('gev3').appendResult;

model.label([native2unicode(hex2dec({'53' 'cc'}), 'unicode')  native2unicode(hex2dec({'5c' '42'}), 'unicode')  native2unicode(hex2dec({'7e' 'd3'}), 'unicode')  native2unicode(hex2dec({'67' '84'}), 'unicode')  native2unicode(hex2dec({'97' '5e'}), 'unicode')  native2unicode(hex2dec({'5b' 'f9'}), 'unicode')  native2unicode(hex2dec({'79' 'f0'}), 'unicode')  native2unicode(hex2dec({'6d' '4b'}), 'unicode')  native2unicode(hex2dec({'8b' 'd5'}), 'unicode') '_' native2unicode(hex2dec({'4e' 'ff'}), 'unicode')  native2unicode(hex2dec({'71' '67'}), 'unicode') 'optic_' native2unicode(hex2dec({'5d' 'e6'}), 'unicode')  native2unicode(hex2dec({'53' 'f3'}), 'unicode')  native2unicode(hex2dec({'62' '4b'}), 'unicode')  native2unicode(hex2dec({'60' '27'}), 'unicode')  native2unicode(hex2dec({'76' 'f8'}), 'unicode')  native2unicode(hex2dec({'54' '0c'}), 'unicode') '_CPA_200-' native2unicode(hex2dec({'8f' '90'}), 'unicode')  native2unicode(hex2dec({'5c' '04'}), 'unicode') '.mph']);

model.result.numerical('gev3').set('table', 'tbl3');
model.result.numerical('gev3').appendResult;
model.result.table('tbl3').clearTableData;

model.study('std3').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol3').runAll;

model.result('pg34').run;

model.component('comp1').variable('var4').set('Forward', 'Eoz1/(Eoz1+Eoz0+Eoz_1)');
model.component('comp1').variable('var4').set('Backward', 'Eof1/(Eof1+Eof0+Eof_1)');

model.study('std3').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol3').runAll;

model.result('pg34').run;
model.result.numerical('gev3').set('table', 'tbl3');
model.result.numerical('gev3').setResult;

model.study('std8').feature('param').active(false);
model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol521').runAll;

model.result('pg38').run;
model.result('pg34').run;

model.study('std3').feature('freq').set('punit', 'Hz');
model.study('std3').feature('freq').set('plist', 'range(1429.2,1,1529.2)');
model.study('std3').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol3').runAll;

model.result('pg34').run;
model.result('pg36').run;
model.result('pg41').run;
model.result.create('pg42', 'PlotGroup1D');
model.result('pg42').run;
model.result('pg42').create('lngr1', 'LineGraph');
model.result('pg42').feature('lngr1').set('markerpos', 'datapoints');
model.result('pg42').feature('lngr1').set('linewidth', 'preference');
model.result('pg42').feature('lngr1').set('evaluationsettings', 'parent');
model.result('pg42').feature.remove('lngr1');
model.result('pg42').run;
model.result('pg42').create('glob1', 'Global');
model.result('pg42').feature('glob1').set('markerpos', 'datapoints');
model.result('pg42').feature('glob1').set('linewidth', 'preference');
model.result('pg42').run;
model.result('pg42').label([native2unicode(hex2dec({'8f' '90'}), 'unicode')  native2unicode(hex2dec({'5c' '04'}), 'unicode') ]);
model.result.numerical('gev3').set('table', 'tbl3');
model.result.numerical('gev3').appendResult;
model.result.table('tbl3').clearTableData;
model.result('pg42').run;
model.result('pg42').feature('glob1').set('expr', {});
model.result('pg42').feature('glob1').set('descr', {});
model.result('pg42').feature('glob1').setIndex('expr', 'Forward', 0);
model.result('pg42').feature('glob1').setIndex('unit', 1, 0);
model.result('pg42').feature('glob1').setIndex('descr', '', 0);
model.result('pg42').feature('glob1').setIndex('expr', 'Backward', 1);
model.result('pg42').feature('glob1').setIndex('unit', 1, 1);
model.result('pg42').feature('glob1').setIndex('descr', '', 1);
model.result('pg42').run;
model.result('pg42').set('data', 'dset3');
model.result('pg42').run;

model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol521').runAll;

model.result('pg38').run;
model.result('pg41').run;
model.result('pg41').run;
model.result('pg41').run;
model.result('pg41').run;
model.result('pg41').run;
model.result('pg34').run;
model.result('pg34').run;
model.result('pg38').run;
model.result('pg38').run;
model.result('pg38').feature('surf1').set('expr', 'acpr.p_b');
model.result('pg38').run;
model.result('pg38').run;

model.component('comp1').physics('acpr').feature('bpf2').set('CalculateIntensity', false);
model.component('comp1').physics('acpr').selection.set([]);
model.component('comp1').physics('acpr').feature('bpf1').active(false);
model.component('comp1').physics('acpr').selection.set([4 5 6 7 8 9 10 11 12]);

model.study('std8').feature('freq').set('plist', 'range(1429.2,1,1529.2)');
model.study('std8').feature('freq').set('punit', 'Hz');
model.study('std8').setGenConv(false);
model.study('std8').setStoreSolution(true);
model.study('std8').setGenPlots(false);
model.study('std8').setPlotUndefVals(true);
model.study('std8').setStoreSolution(false);
model.study('std8').setPlotUndefVals(false);
model.study('std8').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.param.set('xy_theta', '10+180');

model.study('std3').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol3').runAll;

model.result('pg34').run;

model.component('comp1').physics('acpr').selection.set([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17]);

model.study('std3').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol3').runAll;

model.result('pg34').run;
model.result('pg42').run;

model.component('comp1').variable('var4').set('F1', 'Eoz1/(1e-4[W])');
model.component('comp1').variable('var4').set('B1', 'Eof1/(1e-4[W])');

model.component('comp1').physics('opt').feature('gobj1').set('objectiveExpression', 'opti4');
model.component('comp1').physics('opt').create('gconstr3', 'GlobalInequality', -1);
model.component('comp1').physics('opt').feature('gconstr3').set('useUpperBound', false);
model.component('comp1').physics('opt').feature('gconstr3').set('constraintExpression', 'Forward');
model.component('comp1').physics('opt').feature('gconstr3').set('lowerBound', 0.99);
model.component('comp1').physics('opt').feature.duplicate('gconstr4', 'gconstr3');
model.component('comp1').physics('opt').feature('gconstr4').set('constraintExpression', 'Backward');
model.component('comp1').physics('opt').feature.duplicate('gconstr5', 'gconstr4');
model.component('comp1').physics('opt').feature.duplicate('gconstr6', 'gconstr5');
model.component('comp1').physics('opt').feature('gconstr6').set('constraintExpression', 'F1');
model.component('comp1').physics('opt').feature('gconstr6').set('lowerBound', 100);
model.component('comp1').physics('opt').feature('gconstr5').set('constraintExpression', 'B1');
model.component('comp1').physics('opt').feature('gconstr5').set('lowerBound', 100);

model.component('comp1').variable('var3').set('om', 'acpr.freq*2*pi');
model.component('comp1').variable('var3').descr('om', '');
model.component('comp1').variable('var3').set('C1', '1/(2*rho0*om)');
model.component('comp1').variable('var3').descr('C1', '');
model.component('comp1').variable('var2').set('Ez1', 'real((abs(az1/besselj(1,1.8412)))^2*kz10*pi*R0^2*(1-(1/1.8412)^2)*(besselj(1,1.8412))^2)*C1');
model.component('comp1').variable('var2').set('Ez0', 'real((abs(az0/besselj(0,0)))^2*kz00*pi*R0^2)*C1');
model.component('comp1').variable('var2').set('Ez_1', 'real((abs(az_1/besselj(1,1.8412)))^2*kz10*pi*R0^2*(1-(1/1.8412)^2)*(besselj(1,1.8412))^2)*C1');
model.component('comp1').variable('var2').set('Ef1', 'real((abs(af1/besselj(1,1.8412)))^2*kz10*pi*R0^2*(1-(1/1.8412)^2)*(besselj(1,1.8412))^2)*C1');
model.component('comp1').variable('var2').set('Ef0', 'real((abs(af0/besselj(0,0)))^2*kz00*pi*R0^2)*C1');
model.component('comp1').variable('var2').set('Ef_1', 'real((abs(af_1/besselj(1,1.8412)))^2*kz10*pi*R0^2*(1-(1/1.8412)^2)*(besselj(1,1.8412))^2)*C1');

model.param.set('rho0', '1.21[kg/m^3]');
model.param.descr('rho0', '');

model.component('comp1').variable('var5').set('Eoz1', 'real((abs(aoz1/besselj(1,1.8412)))^2*kz10*pi*R0^2*(1-(1/1.8412)^2)*(besselj(1,1.8412))^2)*C1');
model.component('comp1').variable('var5').set('Eoz0', 'real((abs(aoz0/besselj(0,0)))^2*kz00*pi*R0^2)*C1');
model.component('comp1').variable('var5').set('Eoz_1', 'real((abs(aoz_1/besselj(1,1.8412)))^2*kz10*pi*R0^2*(1-(1/1.8412)^2)*(besselj(1,1.8412))^2)*C1');
model.component('comp1').variable('var5').set('Eof1', 'real((abs(aof1/besselj(1,1.8412)))^2*kz10*pi*R0^2*(1-(1/1.8412)^2)*(besselj(1,1.8412))^2)*C1');
model.component('comp1').variable('var5').set('Eof0', 'real((abs(aof0/besselj(0,0)))^2*kz00*pi*R0^2)*C1');
model.component('comp1').variable('var5').set('Eof_1', 'real((abs(aof_1/besselj(1,1.8412)))^2*kz10*pi*R0^2*(1-(1/1.8412)^2)*(besselj(1,1.8412))^2)*C1');

model.study('std3').feature('freq').set('plist', 1479.2);
model.study('std3').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol3').runAll;

model.result('pg34').run;
model.result('pg42').run;
model.result.numerical.create('gev5', 'EvalGlobal');
model.result.numerical('gev5').set('expr', {});
model.result.numerical('gev5').set('descr', {});
model.result.numerical('gev5').setIndex('expr', 'F', 0);
model.result.numerical('gev5').setIndex('expr', 'F1', 0);
model.result.numerical('gev5').setIndex('expr', 'B1', 1);
model.result.numerical('gev5').set('data', 'dset3');
model.result.table.create('tbl15', 'Table');
model.result.table('tbl15').comments([native2unicode(hex2dec({'51' '68'}), 'unicode')  native2unicode(hex2dec({'5c' '40'}), 'unicode')  native2unicode(hex2dec({'8b' 'a1'}), 'unicode')  native2unicode(hex2dec({'7b' '97'}), 'unicode') ' 5 {gev5}']);
model.result.numerical('gev5').set('table', 'tbl15');
model.result.numerical('gev5').setResult;

model.study('std7').feature('opt').remove('initval', 6);
model.study('std7').feature('opt').remove('scale', 6);
model.study('std7').feature('opt').remove('lbound', 6);
model.study('std7').feature('opt').remove('ubound', 6);
model.study('std7').feature('opt').remove('punit', 6);
model.study('std7').feature('opt').remove('pname', [6]);
model.study('std7').feature('opt').remove('initval', 6);
model.study('std7').feature('opt').remove('scale', 6);
model.study('std7').feature('opt').remove('lbound', 6);
model.study('std7').feature('opt').remove('ubound', 6);
model.study('std7').feature('opt').remove('punit', 6);
model.study('std7').feature('opt').remove('pname', [6]);
model.study('std7').feature('opt').remove('initval', 6);
model.study('std7').feature('opt').remove('scale', 6);
model.study('std7').feature('opt').remove('lbound', 6);
model.study('std7').feature('opt').remove('ubound', 6);
model.study('std7').feature('opt').remove('punit', 6);
model.study('std7').feature('opt').remove('pname', [6]);
model.study('std7').feature('opt').remove('initval', 6);
model.study('std7').feature('opt').remove('scale', 6);
model.study('std7').feature('opt').remove('lbound', 6);
model.study('std7').feature('opt').remove('ubound', 6);
model.study('std7').feature('opt').remove('punit', 6);
model.study('std7').feature('opt').remove('pname', [6]);
model.study('std7').feature('opt').setIndex('initval', 0.2, 0);
model.study('std7').feature('opt').setIndex('initval', 0.2, 1);
model.study('std7').feature('opt').setIndex('initval', 0.45, 2);
model.study('std7').feature('opt').setIndex('initval', 0.99687, 3);
model.study('std7').feature('opt').setIndex('initval', 0.89922, 4);
model.study('std7').feature('opt').setIndex('initval', 0.20391, 5);

model.component('comp1').geom('geom1').run('mir1');
model.component('comp1').geom('geom1').run('rot3');
model.component('comp1').geom('geom1').run('mir1');
model.component('comp1').geom('geom1').run('mov5');
model.component('comp1').geom('geom1').run('mov2');
model.component('comp1').geom('geom1').run('mov3');

model.param('par7').set('dis_c2_x5', 'dis_c2_xmin+(dis_c2_xmax-dis_c2_xmin)*dis_c2_x5n');
model.param('par7').descr('dis_c2_x4', [native2unicode(hex2dec({'65' '74'}), 'unicode')  native2unicode(hex2dec({'4f' '53'}), 'unicode')  native2unicode(hex2dec({'79' 'fb'}), 'unicode')  native2unicode(hex2dec({'52' 'a8'}), 'unicode') ]);
model.param('par7').set('dis_c2_x5n', '-1');

model.component('comp1').geom('geom1').run('mov5');
model.component('comp1').geom('geom1').create('mov6', 'Move');
model.component('comp1').geom('geom1').feature('mov6').selection('input').set({'mov2' 'mov3' 'mov4' 'mov5'});
model.component('comp1').geom('geom1').feature('mov6').set('displz', 'dis_c2_x5');
model.component('comp1').geom('geom1').run('mov6');
model.component('comp1').geom('geom1').run('mov5');

model.param('par7').set('dis_c2_x5n', '1');

model.component('comp1').geom('geom1').run('mov6');

model.param('par7').set('dis_c2_x5n', '1.5');

model.component('comp1').geom('geom1').run('mov6');
model.component('comp1').geom('geom1').feature('mov6').label([native2unicode(hex2dec({'65' '74'}), 'unicode')  native2unicode(hex2dec({'4f' '53'}), 'unicode')  native2unicode(hex2dec({'79' 'fb'}), 'unicode')  native2unicode(hex2dec({'52' 'a8'}), 'unicode') ]);
model.component('comp1').geom('geom1').run;

model.param('par7').set('dis_c2_x5n', '0');

model.component('comp1').geom('geom1').run('rmd1');

model.param('par7').set('dis_c2_x5', 'dis_c5_xmin+(dis_c5_xmax-dis_c5_xmin)*dis_c2_x5n');
model.param('par7').set('dis_c5_xmax', 'lbd/2');
model.param('par7').set('dis_c5_xmin', '0');
model.param('par7').set('dis_c5_xmax', 'lbd');

model.component('comp1').geom('geom1').run('rmd1');

model.param('par7').set('dis_c2_x5n', '1');

model.component('comp1').geom('geom1').run('rmd1');

model.study('std3').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol3').runAll;

model.result('pg34').run;
model.result.numerical('gev5').set('table', 'tbl15');
model.result.numerical('gev5').appendResult;
model.result.numerical('gev5').label([native2unicode(hex2dec({'65' '3e'}), 'unicode')  native2unicode(hex2dec({'59' '27'}), 'unicode')  native2unicode(hex2dec({'50' '0d'}), 'unicode')  native2unicode(hex2dec({'65' '70'}), 'unicode') ]);

model.study('std7').feature('opt').setIndex('pname', 'c0', 6);
model.study('std7').feature('opt').setIndex('initval', '343[m/s]', 6);
model.study('std7').feature('opt').setIndex('scale', 1, 6);
model.study('std7').feature('opt').setIndex('lbound', '', 6);
model.study('std7').feature('opt').setIndex('ubound', '', 6);
model.study('std7').feature('opt').setIndex('punit', '', 6);
model.study('std7').feature('opt').setIndex('pname', 'c0', 6);
model.study('std7').feature('opt').setIndex('initval', '343[m/s]', 6);
model.study('std7').feature('opt').setIndex('scale', 1, 6);
model.study('std7').feature('opt').setIndex('lbound', '', 6);
model.study('std7').feature('opt').setIndex('ubound', '', 6);
model.study('std7').feature('opt').setIndex('punit', '', 6);
model.study('std7').feature('opt').setIndex('pname', 'dis_c2_x5n', 6);
model.study('std7').feature('opt').setIndex('scale', 10, 6);
model.study('std7').feature('opt').setIndex('lbound', 0, 6);
model.study('std7').feature('opt').setIndex('ubound', 1, 6);
model.study('std7').feature('freq').set('plist', 1479.2);
model.study.remove('std5');
model.study.remove('std6');
model.study.remove('std8');

model.sol('sol1').clearSolutionData;
model.sol('sol3').clearSolutionData;
model.sol('sol522').clearSolutionData;
model.sol('sol523').clearSolutionData;

model.mesh.clearMeshes;

model.study('std7').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.study('std7').feature('opt').set('probewindow', '');
model.study('std7').feature('opt').set('constrmethod', 'augLagrange');
model.study('std7').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.component('comp1').mesh('mesh1').run('size2');

model.study('std7').feature('opt').set('probewindow', '');
model.study('std7').feature('opt').set('objectivetype', 'minimization');
model.study('std7').feature('opt').set('constrmethod', 'penalty');
model.study('std7').feature('opt').setIndex('initval', 0, 6);
model.study('std7').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.study('std7').feature('opt').set('probewindow', '');
model.study('std3').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol3').runAll;

model.result('pg34').run;

model.param('par7').set('dis_c2_x5n', '0');

model.component('comp1').geom('geom1').run('rmd1');

model.study('std3').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol3').runAll;

model.result('pg34').run;

model.study('std7').feature('freq').set('disabledphysics', {'acpr/bpf2'});
model.study('std3').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol3').runAll;

model.result('pg34').run;

model.component('comp1').physics('acpr').feature('bpf2').active(false);

model.study('std3').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol3').runAll;

model.result('pg34').run;

model.component('comp1').physics('acpr').feature('mps2').selection.set([1]);

model.study('std3').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol3').runAll;

model.result('pg34').run;

model.component('comp1').physics('opt').feature('gobj1').set('objectiveExpression', 'opti6');

model.label([native2unicode(hex2dec({'53' 'cc'}), 'unicode')  native2unicode(hex2dec({'5c' '42'}), 'unicode')  native2unicode(hex2dec({'7e' 'd3'}), 'unicode')  native2unicode(hex2dec({'67' '84'}), 'unicode')  native2unicode(hex2dec({'97' '5e'}), 'unicode')  native2unicode(hex2dec({'5b' 'f9'}), 'unicode')  native2unicode(hex2dec({'79' 'f0'}), 'unicode')  native2unicode(hex2dec({'6d' '4b'}), 'unicode')  native2unicode(hex2dec({'8b' 'd5'}), 'unicode') '_' native2unicode(hex2dec({'4e' 'ff'}), 'unicode')  native2unicode(hex2dec({'71' '67'}), 'unicode') 'optic_' native2unicode(hex2dec({'5d' 'e6'}), 'unicode')  native2unicode(hex2dec({'53' 'f3'}), 'unicode')  native2unicode(hex2dec({'62' '4b'}), 'unicode')  native2unicode(hex2dec({'60' '27'}), 'unicode')  native2unicode(hex2dec({'76' 'f8'}), 'unicode')  native2unicode(hex2dec({'54' '0c'}), 'unicode') '_CPA_200-' native2unicode(hex2dec({'8f' '90'}), 'unicode')  native2unicode(hex2dec({'5c' '04'}), 'unicode') '.mph']);

model.study('std1').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol1').runAll;

model.result('pg34').run;
model.result('pg34').set('data', 'dset1');
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepPrevious(0);
model.result('pg34').run;
model.result('pg34').set('data', 'dset3');
model.result('pg34').run;

model.component('comp1').physics('acpr').feature('mps2').selection.set([3]);

model.study('std3').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol3').runAll;

model.result('pg34').run;

model.component('comp1').physics('acpr').feature('mps2').selection.set([1]);

model.study('std3').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol3').runAll;

model.result('pg34').run;

model.component('comp1').physics('acpr').feature('mps2').selection.set([3]);

model.study('std3').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol3').runAll;

model.result('pg34').run;
model.result('pg42').run;

model.component('comp1').physics('acpr').feature('mps2').selection.set([1]);

model.study('std3').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol3').runAll;

model.result('pg34').run;
model.result('pg34').set('data', 'dset1');
model.result('pg34').run;
model.result('pg34').set('looplevel', [8]);
model.result('pg34').run;
model.result('pg42').run;
model.result('pg34').run;
model.result('pg34').set('data', 'dset3');
model.result('pg34').run;

model.component('comp1').geom('geom1').run('wp9');
model.component('comp1').geom('geom1').create('mir3', 'Mirror');
model.component('comp1').geom('geom1').feature('mir3').selection('input').set({'rot3'});
model.component('comp1').geom('geom1').feature.remove('mir3');
model.component('comp1').geom('geom1').run('wp9');
model.component('comp1').geom('geom1').create('rot4', 'Rotate');
model.component('comp1').geom('geom1').feature('rot4').selection('input').set({'rot3'});
model.component('comp1').geom('geom1').feature('rot4').set('axistype', 'x');
model.component('comp1').geom('geom1').feature('rot4').set('rot', 180);
model.component('comp1').geom('geom1').measure.selection.init(0);
model.component('comp1').geom('geom1').measure.selection.set('mir2', 3);
model.component('comp1').geom('geom1').feature('rot4').set('pos', [0 0 0.08]);
model.component('comp1').geom('geom1').run('rot4');

model.study('std1').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol1').runAll;

model.result('pg34').run;
model.result('pg34').set('data', 'dset1');
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepPrevious(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepPrevious(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepPrevious(0);
model.result('pg34').run;

model.study('std3').feature('freq').set('punit', 'kHz');
model.study('std3').feature('freq').set('plist', 1.6672);
model.study('std3').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol3').runAll;

model.result('pg35').run;
model.result('pg34').run;
model.result('pg34').set('data', 'dset3');
model.result('pg34').run;
model.result('pg34').run;

model.study('std3').feature('freq').set('plist', 1.492);
model.study('std3').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol3').runAll;

model.result('pg34').run;

model.param.set('xy_theta', '0');

model.study('std3').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol3').runAll;

model.result('pg34').run;

model.param.set('xy_theta', '10');

model.component('comp1').geom('geom1').feature('rot4').active(false);

model.study('std3').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol3').runAll;

model.result('pg34').run;

model.study('std1').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol1').runAll;

model.result('pg34').run;
model.result('pg34').set('data', 'dset1');
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;

model.study('std3').feature('freq').set('plist', 1.4792);
model.study('std3').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol3').runAll;

model.result('pg35').run;
model.result('pg34').run;
model.result('pg34').set('data', 'dset3');
model.result('pg34').run;
model.result('pg42').run;
model.result('pg42').run;

model.label([native2unicode(hex2dec({'53' 'cc'}), 'unicode')  native2unicode(hex2dec({'5c' '42'}), 'unicode')  native2unicode(hex2dec({'7e' 'd3'}), 'unicode')  native2unicode(hex2dec({'67' '84'}), 'unicode')  native2unicode(hex2dec({'97' '5e'}), 'unicode')  native2unicode(hex2dec({'5b' 'f9'}), 'unicode')  native2unicode(hex2dec({'79' 'f0'}), 'unicode')  native2unicode(hex2dec({'6d' '4b'}), 'unicode')  native2unicode(hex2dec({'8b' 'd5'}), 'unicode') '_' native2unicode(hex2dec({'4e' 'ff'}), 'unicode')  native2unicode(hex2dec({'71' '67'}), 'unicode') 'optic_' native2unicode(hex2dec({'5d' 'e6'}), 'unicode')  native2unicode(hex2dec({'53' 'f3'}), 'unicode')  native2unicode(hex2dec({'62' '4b'}), 'unicode')  native2unicode(hex2dec({'60' '27'}), 'unicode')  native2unicode(hex2dec({'76' 'f8'}), 'unicode')  native2unicode(hex2dec({'54' '0c'}), 'unicode') '_CPA_200-' native2unicode(hex2dec({'8f' '90'}), 'unicode')  native2unicode(hex2dec({'5c' '04'}), 'unicode') '.mph']);

model.result('pg42').run;

model.component('comp1').physics('acpr').selection.set([3 4 5 6 7 8 9 10 11 12]);
model.component('comp1').physics('acpr').feature('mps2').selection.set([1 81]);

model.study('std3').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol3').runAll;

model.result('pg34').run;

model.study('std3').feature('freq').set('plist', 'range(1429.2,10,1529.2)');
model.study('std3').feature('freq').set('punit', 'Hz');
model.study('std3').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol3').runAll;

model.result('pg34').run;

model.study('std1').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.component('comp1').mesh('mesh1').automatic(true);
model.component('comp1').mesh('mesh1').run;

model.study('std1').feature('eig').setSolveFor('/physics/opt', false);
model.study('std1').feature('eig').set('disabledphysics', {'acpr/mps1' 'acpr/mps2' 'acpr/pr1' 'acpr/pr2' 'acpr/pr3' 'acpr/pr4' 'acpr/bpf2' 'acpr/bpf1' 'acpr/tvb1' 'opt'});
model.study('std1').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.result('pg42').run;
model.result('pg42').feature('glob1').set('data', 'dset3');
model.result('pg42').run;

model.component('comp1').mesh('mesh1').contribute('geom/detail', false);
model.component('comp1').mesh('mesh1').run;

model.study('std1').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol1').runAll;

model.result.numerical('gev3').set('table', 'tbl3');
model.result.numerical('gev3').setResult;

model.label([native2unicode(hex2dec({'53' 'cc'}), 'unicode')  native2unicode(hex2dec({'5c' '42'}), 'unicode')  native2unicode(hex2dec({'7e' 'd3'}), 'unicode')  native2unicode(hex2dec({'67' '84'}), 'unicode')  native2unicode(hex2dec({'97' '5e'}), 'unicode')  native2unicode(hex2dec({'5b' 'f9'}), 'unicode')  native2unicode(hex2dec({'79' 'f0'}), 'unicode')  native2unicode(hex2dec({'6d' '4b'}), 'unicode')  native2unicode(hex2dec({'8b' 'd5'}), 'unicode') '_' native2unicode(hex2dec({'4e' 'ff'}), 'unicode')  native2unicode(hex2dec({'71' '67'}), 'unicode') 'optic_' native2unicode(hex2dec({'5d' 'e6'}), 'unicode')  native2unicode(hex2dec({'53' 'f3'}), 'unicode')  native2unicode(hex2dec({'62' '4b'}), 'unicode')  native2unicode(hex2dec({'60' '27'}), 'unicode')  native2unicode(hex2dec({'76' 'f8'}), 'unicode')  native2unicode(hex2dec({'54' '0c'}), 'unicode') '_CPA_200-' native2unicode(hex2dec({'8f' '90'}), 'unicode')  native2unicode(hex2dec({'5c' '04'}), 'unicode') '.mph']);

model.study('std1').feature('eig').set('useadvanceddisable', false);

model.component('comp1').physics('acpr').feature('tvb1').active(false);

model.label([native2unicode(hex2dec({'53' 'cc'}), 'unicode')  native2unicode(hex2dec({'5c' '42'}), 'unicode')  native2unicode(hex2dec({'7e' 'd3'}), 'unicode')  native2unicode(hex2dec({'67' '84'}), 'unicode')  native2unicode(hex2dec({'97' '5e'}), 'unicode')  native2unicode(hex2dec({'5b' 'f9'}), 'unicode')  native2unicode(hex2dec({'79' 'f0'}), 'unicode')  native2unicode(hex2dec({'6d' '4b'}), 'unicode')  native2unicode(hex2dec({'8b' 'd5'}), 'unicode') '_' native2unicode(hex2dec({'4e' 'ff'}), 'unicode')  native2unicode(hex2dec({'71' '67'}), 'unicode') 'optic_' native2unicode(hex2dec({'5d' 'e6'}), 'unicode')  native2unicode(hex2dec({'53' 'f3'}), 'unicode')  native2unicode(hex2dec({'62' '4b'}), 'unicode')  native2unicode(hex2dec({'60' '27'}), 'unicode')  native2unicode(hex2dec({'76' 'f8'}), 'unicode')  native2unicode(hex2dec({'54' '0c'}), 'unicode') '_CPA_200-' native2unicode(hex2dec({'8f' '90'}), 'unicode')  native2unicode(hex2dec({'5c' '04'}), 'unicode') '.mph']);

model.result.numerical('gev3').setIndex('expr', 'Freq', 2);
model.result.numerical('gev3').set('data', 'dset1');
model.result.numerical('gev3').setIndex('expr', 'freq', 2);
model.result.table.create('tbl16', 'Table');
model.result.table('tbl16').comments([native2unicode(hex2dec({'8f' '90'}), 'unicode')  native2unicode(hex2dec({'5c' '04'}), 'unicode') ' {gev3}']);
model.result.numerical('gev3').set('table', 'tbl16');
model.result.numerical('gev3').setResult;
model.result.table('tbl16').clearTableData;
model.result.numerical('gev3').remove('unit', 2);
model.result.numerical('gev3').remove('descr', 2);
model.result.numerical('gev3').remove('expr', [2]);
model.result.numerical('gev3').set('table', 'tbl16');
model.result.numerical('gev3').setResult;
model.result.numerical.create('gev6', 'EvalGlobal');
model.result.numerical('gev6').set('expr', {});
model.result.numerical('gev6').set('descr', {});
model.result.numerical('gev6').setIndex('expr', 'Eoz1/(Eoz1+Eoz0+Eoz_1)', 0);
model.result.numerical('gev6').setIndex('expr', 'Eoz1', 0);
model.result.numerical('gev6').setIndex('expr', 'Eoz0', 1);
model.result.numerical('gev6').setIndex('expr', 'Eoz1', 2);
model.result.numerical('gev6').setIndex('expr', 'Eoz_1', 2);
model.result.numerical('gev6').setIndex('expr', 'Eoz1', 3);
model.result.numerical('gev6').setIndex('unit', 'W', 3);
model.result.numerical('gev6').setIndex('descr', '', 3);
model.result.numerical('gev6').setIndex('expr', 'Eoz0', 4);
model.result.numerical('gev6').setIndex('unit', 'W', 4);
model.result.numerical('gev6').setIndex('descr', '', 4);
model.result.numerical('gev6').setIndex('expr', 'Eoz_1', 5);
model.result.numerical('gev6').setIndex('unit', 'W', 5);
model.result.numerical('gev6').setIndex('descr', '', 5);
model.result.numerical('gev6').setIndex('expr', 'Eof1', 3);
model.result.numerical('gev6').setIndex('expr', 'Eof0', 4);
model.result.numerical('gev6').setIndex('expr', 'Eof_1', 5);
model.result.table('tbl16').clearTableData;
model.result.table.create('tbl17', 'Table');
model.result.table('tbl17').comments([native2unicode(hex2dec({'51' '68'}), 'unicode')  native2unicode(hex2dec({'5c' '40'}), 'unicode')  native2unicode(hex2dec({'8b' 'a1'}), 'unicode')  native2unicode(hex2dec({'7b' '97'}), 'unicode') ' 6 {gev6}']);
model.result.numerical('gev6').set('table', 'tbl17');
model.result.numerical('gev6').setResult;
model.result.table('tbl17').save(['G:\' native2unicode(hex2dec({'97' '5e'}), 'unicode')  native2unicode(hex2dec({'5b' 'f9'}), 'unicode')  native2unicode(hex2dec({'79' 'f0'}), 'unicode')  native2unicode(hex2dec({'8f' '90'}), 'unicode')  native2unicode(hex2dec({'5c' '04'}), 'unicode') '\' native2unicode(hex2dec({'74' '06'}), 'unicode')  native2unicode(hex2dec({'8b' 'ba'}), 'unicode') 'codex\' native2unicode(hex2dec({'72' '79'}), 'unicode')  native2unicode(hex2dec({'5f' '81'}), 'unicode')  native2unicode(hex2dec({'98' '91'}), 'unicode')  native2unicode(hex2dec({'73' '87'}), 'unicode') '.txt']);

model.component('comp1').geom('geom1').measure.selection.init(1);
model.component('comp1').geom('geom1').measure.selection.set('fin', 14);
model.component('comp1').geom('geom1').measure.selection.init(1);
model.component('comp1').geom('geom1').measure.selection.set('fin', [11 17]);
model.component('comp1').geom('geom1').measure.selection.init(1);
model.component('comp1').geom('geom1').measure.selection.set('fin', [17 18]);
model.component('comp1').geom('geom1').measure.selection.init(1);
model.component('comp1').geom('geom1').measure.selection.set('fin', [16 17]);
model.component('comp1').geom('geom1').measure.selection.init(1);
model.component('comp1').geom('geom1').measure.selection.set('fin', [14 17]);
model.component('comp1').geom('geom1').measure.selection.init(1);
model.component('comp1').geom('geom1').measure.selection.set('fin', 14);
model.component('comp1').geom('geom1').measure.selection.init(1);
model.component('comp1').geom('geom1').measure.selection.set('fin', 18);
model.component('comp1').geom('geom1').measure.selection.init(1);
model.component('comp1').geom('geom1').measure.selection.set('fin', 16);

model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').set('data', 'dset1');
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').run;
model.result('pg34').set('looplevel', [26]);
model.result('pg34').run;

model.component('comp1').physics('acpr').selection.set([1 3 4 5 6 7 8 9 10 11 12]);

model.study('std1').createAutoSequences('all');

model.component('comp1').probe('point1').genResult('none');
model.component('comp1').probe('point2').genResult('none');
model.component('comp1').probe('point3').genResult('none');
model.component('comp1').probe('point4').genResult('none');
model.component('comp1').probe('point5').genResult('none');
model.component('comp1').probe('point6').genResult('none');
model.component('comp1').probe('point7').genResult('none');
model.component('comp1').probe('point8').genResult('none');
model.component('comp1').probe('point9').genResult('none');
model.component('comp1').probe('point10').genResult('none');
model.component('comp1').probe('point11').genResult('none');
model.component('comp1').probe('point12').genResult('none');
model.component('comp1').probe('point13').genResult('none');
model.component('comp1').probe('point14').genResult('none');
model.component('comp1').probe('point15').genResult('none');
model.component('comp1').probe('point16').genResult('none');

model.sol('sol1').runAll;

model.result('pg34').run;
model.result('pg34').stepPrevious(0);
model.result('pg34').run;
model.result('pg34').stepPrevious(0);
model.result('pg34').run;
model.result('pg34').stepPrevious(0);
model.result('pg34').run;
model.result('pg34').stepPrevious(0);
model.result('pg34').run;
model.result('pg34').stepPrevious(0);
model.result('pg34').run;
model.result('pg34').stepPrevious(0);
model.result('pg34').run;
model.result('pg34').stepPrevious(0);
model.result('pg34').run;
model.result('pg34').stepPrevious(0);
model.result('pg34').run;
model.result('pg34').stepNext(0);
model.result('pg34').run;
model.result('pg34').stepPrevious(0);
model.result('pg34').run;
model.result('pg34').stepPrevious(0);
model.result('pg34').run;
model.result('pg34').stepPrevious(0);
model.result('pg34').run;
model.result('pg34').stepPrevious(0);
model.result('pg34').run;
model.result('pg34').stepPrevious(0);
model.result('pg34').run;
model.result('pg34').stepPrevious(0);
model.result('pg34').run;
model.result('pg34').stepPrevious(0);
model.result('pg34').run;
model.result('pg34').stepPrevious(0);
model.result('pg34').run;
model.result.table('tbl17').clearTableData;
model.result.numerical('gev6').set('table', 'tbl17');
model.result.numerical('gev6').setResult;
model.result.table('tbl17').save(['G:\' native2unicode(hex2dec({'97' '5e'}), 'unicode')  native2unicode(hex2dec({'5b' 'f9'}), 'unicode')  native2unicode(hex2dec({'79' 'f0'}), 'unicode')  native2unicode(hex2dec({'8f' '90'}), 'unicode')  native2unicode(hex2dec({'5c' '04'}), 'unicode') '\' native2unicode(hex2dec({'74' '06'}), 'unicode')  native2unicode(hex2dec({'8b' 'ba'}), 'unicode') 'codex\' native2unicode(hex2dec({'72' '79'}), 'unicode')  native2unicode(hex2dec({'5f' '81'}), 'unicode')  native2unicode(hex2dec({'98' '91'}), 'unicode')  native2unicode(hex2dec({'73' '87'}), 'unicode') '2.txt']);

model.label([native2unicode(hex2dec({'53' 'cc'}), 'unicode')  native2unicode(hex2dec({'5c' '42'}), 'unicode')  native2unicode(hex2dec({'7e' 'd3'}), 'unicode')  native2unicode(hex2dec({'67' '84'}), 'unicode')  native2unicode(hex2dec({'97' '5e'}), 'unicode')  native2unicode(hex2dec({'5b' 'f9'}), 'unicode')  native2unicode(hex2dec({'79' 'f0'}), 'unicode')  native2unicode(hex2dec({'6d' '4b'}), 'unicode')  native2unicode(hex2dec({'8b' 'd5'}), 'unicode') '_' native2unicode(hex2dec({'4e' 'ff'}), 'unicode')  native2unicode(hex2dec({'71' '67'}), 'unicode') 'optic_' native2unicode(hex2dec({'5d' 'e6'}), 'unicode')  native2unicode(hex2dec({'53' 'f3'}), 'unicode')  native2unicode(hex2dec({'62' '4b'}), 'unicode')  native2unicode(hex2dec({'60' '27'}), 'unicode')  native2unicode(hex2dec({'76' 'f8'}), 'unicode')  native2unicode(hex2dec({'54' '0c'}), 'unicode') '_CPA_200-' native2unicode(hex2dec({'8f' '90'}), 'unicode')  native2unicode(hex2dec({'5c' '04'}), 'unicode') '.mph']);

out = model;
