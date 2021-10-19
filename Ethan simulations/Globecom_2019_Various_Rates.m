clear; clc;
v_10_m_10_punctured = [0.107100000000000	0.0651000000000000	0.0347000000000000	0.0185000000000000	0.00686059275521405	0.00314021039409640	0.000982656119490984	0.000330516233304799	0.000101537892926261	2.77365273978644e-05];
v_10_m_10_punctured_snr = [1:0.25:3.25];

EL_v_10_m_10_punctured = [78609.3623000000	47729.6596000000	25487.0326000000	15026.8254000000	5368.91527167947	2367.68290155440	819.126064953570	310.285407377783	84.7073728694812	26.4561482728187];
EL_v_10_m_10_punctured_snr = [1:0.25:3.25];

v_8_m_10_punctured = [0.105500000000000,0.0577000000000000,0.0337000000000000,0.0166000000000000,0.00659804697809448,0.00265287173365168,0.00112078724095805,0.000356266187844910,0.000106820830489229,3.13851621624251e-05, 7.28188231997567e-06];
v_8_m_10_punctured_snr = [1,1.25000000000000,1.50000000000000,1.75000000000000,2,2.25000000000000,2.50000000000000,2.75000000000000,3,3.25000000000000, 3.5];

EL_v_8_m_10_punctured = [26480.4731000000,15702.6087000000,8634.75400000000,4082.04360000000,1585.94998680391,711.825679798382,286.875872813064,89.0194663845038,33.1445670391509,8.93380116056053, 3.23849387954150];
EL_v_8_m_10_punctured_snr = [1,1.25000000000000,1.50000000000000,1.75000000000000,2,2.25000000000000,2.50000000000000,2.75000000000000,3,3.25000000000000, 3.5];

v_7_m_10_punctured = [250/7138, 250/29812, 250/197472, 250/1496231, (85+71+82)/(6000000+5000000+6000000), (21+21+29+20)/(15000000+14000000+18000000+14000000)];
v_7_m_10_punctured_snr = [1.5, 2, 2.5, 3.0, 3.5, 4.0];

EL_v_7_m_10_punctured = [4247.88021854861,1025.55383738092,158.687748136445,20.3180524932313,2.99712866666667,1.49223157142857];
EL_v_7_m_10_punctured_snr = [1.5, 2, 2.5, 3.0, 3.5, 4.0];

v_6_m_11_punctured = [229/2000, 306/8000, 100/11283, (87+100)/(60000+61262), (300)/(533718+543187+603438), (100+100)/(5790307+5800510), (52+52+59+42)/(120000000)];
v_6_m_11_punctured_snr = [1, 1.5, 2, 2.5, 3.0, 3.5, 4.0];

EL_v_6_m_11_punctured = [16154.7465000000,4783.28912500000,1087.48329345032,174.441816666667,22.9029503105590,3.42828216704289,1.57808993333333];
EL_v_6_m_11_punctured_snr = [1, 1.5, 2, 2.5, 3.0, 3.5, 4.0];

Polar_rate_1_2_L_8 = [0.6115,0.3905,0.2385,0.1013,0.0362,0.008733333,0.00134375,0.000157,0.000006];
Polar_rate_1_2_L_8_snr = [0,0.5,1,1.5,2,2.5,3,3.5,4];
Polar_rate_1_2_L_32 = [0.5105,0.2815,0.1486,0.0535,0.015,0.00255,0.000367273,0.000027];
Polar_rate_1_2_L_32_snr = [0:0.5:3.5];

T_3_v_6_m_10_rate_1_3 = [586/10000, 192/10000, 100/34589, 100/185769, 100/1776349,100/17769526];
T_3_v_6_m_10_rate_1_3_snr = [-1,-0.5,0,0.5,1, 1.5];

EL_T_3_v_6_m_10_rate_1_3 = [4045.67890000000,1190.74870000000,182.568215328573,28.0611350655922,4.59673971725151,1.7979];
EL_T_3_v_6_m_10_rate_1_3_snr = [-1,-0.5,0,0.5,1,1.5];

Polar_rate_1_3_L_8 = [0.53,0.391,0.239,0.1079,0.0392,0.010133333,0.001592308,0.000221978,0.000019];
Polar_rate_1_3_L_8_snr = [-2,-1.5,-1,-0.5,0,0.5,1,1.5,2];
Polar_rate_1_3_L_32 = [0.643,0.4525,0.28,0.1288,0.0474,0.01095,0.001845455,0.000223333,0.000015];
Polar_rate_1_3_L_32_snr = [-2.5,-2,-1.5,-1,-0.5,0,0.5,1,1.5];

T_5_v_6_m_10_rate_1_6 = [698/10000, 209/10000, 100/23081, 100/152779, 100/1500812, 100/17467092];
T_5_v_6_m_10_rate_1_6_snr = [-4, -3.5, -3, -2.5, -2, -1.5];
T_5_v_6_m_11_rate_1_6 = [563/10000, 158/10000, 100/31737, 100/279471, 100/2472960, 100/31690712];
T_5_v_6_m_11_rate_1_6_snr = [-4, -3.5, -3, -2.5, -2, -1.5];
T_5_v_7_m_10_rate_1_6 = [224/10000, 100/17763, 100/120338, 100/975922, 100/9460788];
T_5_v_7_m_10_rate_1_6_snr = [-4, -3.5, -3, -2.5, -2];
T_5_v_7_m_11_rate_1_6 = [181/10000, 100/25928, 100/169021, 100/1903427, 100/19317720];
T_5_v_7_m_11_rate_1_6_snr = [-4, -3.5, -3, -2.5, -2];
T_5_v_8_m_10_rate_1_6 = [218/10000, 100/27476, 100/193241, 100/1856184, 100/23741211];
T_5_v_8_m_10_rate_1_6_snr = [-4, -3.5, -3, -2.5, -2];
T_5_v_8_m_11_rate_1_6 = [150/10000, 100/40293, 100/276606, 100/3028195, 100/44274996];
T_5_v_8_m_11_rate_1_6_snr = [-4, -3.5, -3, -2.5, -2];

Polar_rate_1_6_L_8 = [0.574,0.3705,0.1995,0.0862,0.0249,0.005875,0.000908696,0.000075,0.000002];
Polar_rate_1_6_L_8_snr = [-5.5,-5,-4.5,-4,-3.5,-3,-2.5,-2,-1.5];
Polar_rate_1_6_L_32 = [0.585,0.4305,0.228,0.1082,0.0356,0.007233333,0.001057895,0.00011,0.000005];
Polar_rate_1_6_L_32_snr = [-6,-5.5,-5,-4.5,-4,-3.5,-3,-2.5,-2];

EL_T_5_v_6_m_10_rate_1_6 = [4061.94060000000,1300.33430000000,222.534812183181,38.9723522211822,5.88868026108533, 1.8872];
EL_T_5_v_6_m_10_rate_1_6_snr = [-4, -3.5, -3, -2.5, -2, -1.5];
EL_T_5_v_6_m_11_rate_1_6 = [7077.90580000000,1658.60810000000,271.862053754293,44.7708134296582,5.88456182065217,1.88341609364914];
EL_T_5_v_6_m_11_rate_1_6_snr = [-4, -3.5, -3, -2.5, -2, -1.5];
EL_T_5_v_7_m_10_rate_1_6 = [2794.83480000000,571.369025502449,85.4031976599245,12.9129612817418,2.87231148187656];
EL_T_5_v_7_m_10_rate_1_6_snr = [-4, -3.5, -3, -2.5, -2];
EL_T_5_v_7_m_11_rate_1_6 = [4514.94610000000,917.387958963283,120.712432182983,14.1576677224816,2.71352902930574];
EL_T_5_v_7_m_11_rate_1_6_snr = [-4, -3.5, -3, -2.5, -2];
EL_T_5_v_8_m_10_rate_1_6 = [4673.39470000000,782.715533556558,100.744184722704,12.9961156868069,2.7619];
EL_T_5_v_8_m_10_rate_1_6_snr = [-4, -3.5, -3, -2.5, -2.0];
EL_T_5_v_8_m_11_rate_1_6 = [6470.62750000000,1037.84774030229,139.798225635019,15.1991146541091,2.8293];
EL_T_5_v_8_m_11_rate_1_6_snr = [-4, -3.5, -3, -2.5, -2.0];

T_10_v_6_m_12_rate_1_12 = [104/10000, 100/59678, 100/481438, 100/5036521];
T_10_v_6_m_12_rate_1_12_snr = [-6.5, -6, -5.5, -5];
T_10_v_6_m_13_rate_1_12 = [100/13485, 100/100243, 100/891745, 100/11922081];
T_10_v_6_m_13_rate_1_12_snr = [-6.5, -6, -5.5, -5];
T_10_v_7_m_12_rate_1_12 = [100/23066, 100/139567, 100/1895161, 100/25505404];
T_10_v_7_m_12_rate_1_12_snr = [-6.5, -6, -5.5, -5];
T_10_v_7_m_13_rate_1_12 = [100/26491, 100/229554, 100/3112462, 100/41974382];
T_10_v_7_m_13_rate_1_12_snr = [-6.5, -6, -5.5, -5];
T_10_v_8_m_12_rate_1_12 = [100/47231, 100/481880, 100/6126803];
T_10_v_8_m_12_rate_1_12_snr = [-6.5, -6, -5.5];
T_10_v_8_m_13_rate_1_12 = [100/58392, 100/637463, 100/9479035];
T_10_v_8_m_13_rate_1_12_snr = [-6.5, -6, -5.5];

Polar_rate_1_12_L_8 = [0.517,0.308,0.1535,0.0581,0.01515,0.002971429,0.000315625,0.000012];
Polar_rate_1_12_L_8_snr = [-8.5,-8,-7.5,-7,-6.5,-6,-5.5,-5];
Polar_rate_1_12_L_32 = [0.5825,0.355,0.1895,0.0783,0.01985,0.003633333,0.000434783,0.00002];
Polar_rate_1_12_L_32_snr = [-9,-8.5,-8,-7.5,-7,-6.5,-6,-5.5];

EL_T_10_v_6_m_12_rate_1_12 = [2473.99510000000,374.947652401220,40.8096037288291,5.51614894487683];
EL_T_10_v_6_m_12_rate_1_12_snr = [-6.5, -6, -5.5, -5];
EL_T_10_v_6_m_13_rate_1_12 = [3166.93058954394,456.041219835799,47.4971813691134,5.61022643613980];
EL_T_10_v_6_m_13_rate_1_12_snr = [-6.5, -6, -5.5, -5];
EL_T_10_v_7_m_12_rate_1_12 = [1629.53841151478,276.604691653471,27.4014883168237,3.76540661735842];
EL_T_10_v_7_m_12_rate_1_12_snr = [-6.5, -6, -5.5, -5];
EL_T_10_v_7_m_13_rate_1_12 = [2179.93012721302,360.306681652247,28.6705370218175,3.85427880748786];
EL_T_10_v_7_m_13_rate_1_12_snr = [-6.5, -6, -5.5, -5];
EL_T_10_v_8_m_12_rate_1_12 = [1544.80553026614,158.577218394621,15.5573980426660];
EL_T_10_v_8_m_12_rate_1_12_snr = [-6.5, -6, -5.5];
EL_T_10_v_8_m_13_rate_1_12 = [1833.28270996027,188.849774810460,17.1340];
EL_T_10_v_8_m_13_rate_1_12_snr = [-6.5, -6, -5.5];

Fabian_m_8 = [0.143678,0.0642261,0.0177085,0.00384246,0.000854781,0.000150723,2.71E-05,3.23E-06,3.30E-07];
Fabian_m_8_snr = [1,1.5,2,2.5,3,3.5,4,4.5,5];
Fabian_m_11 = [0.0998004,0.0398565,0.0101513,0.00137722,1.38E-04,1.27E-05,9.51E-07];
Fabian_m_11_snr = [1,1.5,2,2.5,3,3.5,4];
Fabian_m_14 = [0.119332,0.0340599,0.00840015,0.000986405,9.01E-05,5.17E-06];
Fabian_m_14_snr = [1,1.5,2,2.5,3,3.5];
Fabian_unknown = [3.35E-3, 1.71E-3, 6.81E-4, 2.09E-4, 6.93E-5, 2.06E-5];
Fabian_unknown_snr = [2.8,3,3.2,3.4,3.6,3.8];
Fabian_5g_L32 = [0.92318, 0.88673, 0.83432, 0.76963, 0.68409, 0.59483, 0.49488, 0.38931, 0.29013, 0.20347, 0.13447, 0.0812, 0.04517, 0.02211, 0.01056, 0.0044, 0.00165, 0.00051, 0.00019, 4.904762e-05, 9.174312e-06, 1.836364e-06];
Fabian_5g_L32_snr = [-1.0:0.25:4.25];

%Calculating the RCU-values
rcu_rate_1_2 = [0.0423356923968606,0.0317110938966719,0.0233869420708073,0.0169735987701580,0.0121169620820546,0.00850384007532871,0.00586438006368385,0.00397193341265190,0.00264086331839147,0.00172286353055488,0.00110235385615009,0.000691464745800856,0.000425034035096233,0.000255931159752090,0.000150913805172302,8.71216619845982e-05,4.92300806563189e-05,2.72268103913337e-05,1.47376500009286e-05,7.80890056028097e-06,4.05157788193703e-06,2.05954530760325e-06,1.02658455598894e-06,5.02356955597272e-07,2.41733034918569e-07,1.14634896484966e-07];
rcu_snr_rate_1_2 = [1.5:0.1:4];
rcu_rate_1_3 = [0.0485827828159233,0.0365488952285676,0.0270539642500551,0.0196920918508500,0.0140862011284241,0.00989626418314438,0.00682426597022430,0.00461612568262462,0.00306100584635227,0.00198857415387201,0.00126483989109723,0.000787172224045218,0.000479036495351990,0.000284876674337942,0.000165447802418037,9.37799557073034e-05,5.18486175155144e-05,2.79435530839163e-05,1.46720447102322e-05,7.50105557678364e-06,3.73206593306958e-06,1.80618588356661e-06,8.49917436915310e-07,3.88720788202432e-07,1.72754807953908e-07,7.45912902079232e-08];
rcu_snr_rate_1_3 = [-1:0.1:1.5];
rcu_rate_1_6 = [0.00715296756254956,0.00483488469011907,0.00320155422580118,0.00207541853479670,0.00131616882569204,0.000815953385158383,0.000494139394858301,0.000292107274303882,0.000168429573066840,9.46559287218815e-05,5.18080835385907e-05,2.75950273801052e-05,1.42924973626647e-05,7.19262390115769e-06,3.51418563236325e-06,1.66561801921259e-06,7.65235081077092e-07,3.40517886835592e-07,1.46646111650361e-07,6.10733697918986e-08,2.45785809580939e-08];
rcu_snr_rate_1_6 = [-4:0.1:-2];
rcu_rate_1_12 = [0.00236007921145550,0.00150515496603096,0.000938361322020218,0.000571434546625890,0.000339655307677201,0.000196901266353364,0.000111238234660230,6.11937430228481e-05,3.27532036994702e-05,1.70425881155616e-05,8.61367033482373e-06,4.22515636480414e-06,2.00967249623698e-06,9.26099046945656e-07,4.13101646935619e-07,1.78212453647523e-07,7.42869353645477e-08,2.98944122959386e-08,1.16032634527457e-08,4.34003400609116e-09,1.56293886141446e-09];
rcu_snr_rate_1_12 = [-7:0.1:-5];

%----------------------For computing the RCU if needed--------------------
% for iter = rcu_snr_rate_1_2
%     rcu_rate_1_2 = [rcu_rate_1_2, rcu(64*2, 1/2, [0.5;0.5], [-1,1], 10^(-iter/10))];
% end
% for iter = rcu_snr_rate_1_3
%     rcu_rate_1_3 = [rcu_rate_1_3, rcu(64*3, 1/3, [0.5;0.5], [-1,1], 10^(-iter/10))];
% end
% for iter = rcu_snr_rate_1_6
%     rcu_rate_1_6 = [rcu_rate_1_6, rcu(64*6, 1/6, [0.5;0.5], [-1,1], 10^(-iter/10))];
% end
% for iter = rcu_snr_rate_1_12
%     rcu_rate_1_12 = [rcu_rate_1_12, rcu(64*12, 1/12, [0.5;0.5], [-1,1], 10^(-iter/10))];
% end


%Plotting the FER for the high rate case
if(1)
    x0 = 10;
    y0 = 10;
    width = 800;
    height = 600;
    labelTextSize = 18;
    legendTextSize = 14;
    figure;
    my_colors = distinguishable_colors(40);
    lineWidth = 1.5;
    semilogy(Fabian_m_8_snr,Fabian_m_8, 's-', 'Color', my_colors(6,:), 'LineWidth', lineWidth); hold on;
    semilogy(Fabian_m_11_snr,Fabian_m_11, 's-', 'Color', my_colors(7,:), 'LineWidth', lineWidth); hold on;
    semilogy(Fabian_m_14_snr,Fabian_m_14, 's-', 'Color', my_colors(10,:), 'LineWidth', lineWidth);
    semilogy(Fabian_5g_L32_snr, Fabian_5g_L32, 'd-', 'Color', my_colors(31,:), 'LineWidth', lineWidth);
    semilogy(Polar_rate_1_2_L_8_snr,Polar_rate_1_2_L_8, 'd-','Color', my_colors(8,:), 'LineWidth', lineWidth);
    semilogy(Polar_rate_1_2_L_32_snr,Polar_rate_1_2_L_32, 'd-', 'Color', my_colors(9,:), 'LineWidth', lineWidth);
    %semilogy(v_6_m_11_punctured_snr,v_6_m_11_punctured, 'o-', 'Color', my_colors(1,:), 'LineWidth', lineWidth);
    semilogy(v_7_m_10_punctured_snr,v_7_m_10_punctured, 'o-', 'Color', my_colors(2,:), 'LineWidth', lineWidth);
    semilogy(v_8_m_10_punctured_snr,v_8_m_10_punctured, 'o-', 'Color', my_colors(30,:), 'LineWidth', lineWidth);
    %semilogy(v_10_m_10_punctured_snr,v_10_m_10_punctured, 'o-', 'Color', my_colors(33,:), 'LineWidth', lineWidth);
    semilogy(Fabian_unknown_snr,Fabian_unknown, '^-', 'Color', my_colors(11,:), 'LineWidth', lineWidth); hold on;
    semilogy(rcu_snr_rate_1_2,rcu_rate_1_2, '--', 'Color', 'k', 'LineWidth', lineWidth);
    
    
    grid on;
    ylabel('Frame Error Rate', 'interpreter', 'latex', 'FontSize', labelTextSize);
    xlabel("SNR(dB)", 'interpreter', 'latex', 'FontSize', labelTextSize);
    legend(...
        "WAVA $v=8$",...
        "WAVA $v=11$",...
        "WAVA $v=14$",...
        "5G eMBB Polar $L=32$",...
        "PC-Polar $L=8$",...
        "PC-Polar $L=32$",...
        "S-LVA DSO CRC $v=7$, $m=10$",...
        "S-LVA DSO CRC $v=8$, $m=10$",...
        "IBF OTS CRC $v=11$, $m=16$",...
        "RCU Bound",...
        'location', 'southwest', 'interpreter', 'latex', 'FontSize', legendTextSize);
    xlim([1,4]);
    ylim([10^-6, 10^-1]);
    set(gcf,'position', [x0,y0,width,height]);
    saveas(gcf, "Plot_Globecom_2019_TBCC_FER_SNR_HighRate");
    %saveas(gcf, "Plot_Globecom_2019_TBCC_FER_SNR_HighRate.pdf");
end

%Plotting the FER for the low rate case
if (1)
    x0 = 10;
    y0 = 10;
    width = 800;
    height = 600;
    labelTextSize = 18;
    legendTextSize = 11.5;
    figure;
    my_colors = distinguishable_colors(20);
    lineWidth = 1.5;
    %Plotting for legend
    semilogy(-100, -3, 'o-', 'Color', my_colors(14,:), 'LineWidth', lineWidth); hold on;
    semilogy(-100, -3, 'o-', 'Color', my_colors(20,:), 'LineWidth', lineWidth);
    semilogy(-100, -3, '--', 'Color', 'k', 'LineWidth', lineWidth);
    semilogy(-100, -3, 'o-', 'Color', my_colors(3,:), 'LineWidth', lineWidth);
    semilogy(-100, -3, 'o-', 'Color', my_colors(12,:), 'LineWidth', lineWidth);
    semilogy(-100, -3, 'o-', 'Color', my_colors(13,:), 'LineWidth', lineWidth);
    semilogy(-100, -3, 'd-', 'Color', my_colors(8,:), 'LineWidth', lineWidth);
    semilogy(-100, -3, 'd-', 'Color', my_colors(9,:), 'LineWidth', lineWidth);
    
    %Plotting Actual Data
    semilogy(Polar_rate_1_3_L_8_snr,Polar_rate_1_3_L_8, 'd-', 'Color', my_colors(8,:), 'LineWidth', lineWidth); hold on;
    semilogy(Polar_rate_1_3_L_32_snr,Polar_rate_1_3_L_32, 'd-', 'Color', my_colors(9,:), 'LineWidth', lineWidth);
    semilogy(T_3_v_6_m_10_rate_1_3_snr,T_3_v_6_m_10_rate_1_3, 'o-', 'Color', my_colors(3,:), 'LineWidth', lineWidth);
    semilogy(rcu_snr_rate_1_3,rcu_rate_1_3, '--', 'Color', 'k', 'LineWidth', lineWidth);
    semilogy(Polar_rate_1_6_L_8_snr,Polar_rate_1_6_L_8, 'd-', 'Color', my_colors(8,:), 'LineWidth', lineWidth);
    semilogy(Polar_rate_1_6_L_32_snr,Polar_rate_1_6_L_32, 'd-', 'Color', my_colors(9,:), 'LineWidth', lineWidth);
    semilogy(T_5_v_8_m_10_rate_1_6_snr,T_5_v_8_m_10_rate_1_6, 'o-', 'Color', my_colors(12,:), 'LineWidth', lineWidth); 
    semilogy(T_5_v_8_m_11_rate_1_6_snr,T_5_v_8_m_11_rate_1_6, 'o-', 'Color', my_colors(13,:), 'LineWidth', lineWidth);
    semilogy(rcu_snr_rate_1_6,rcu_rate_1_6, '--', 'Color', 'k', 'LineWidth', lineWidth);
    semilogy(Polar_rate_1_12_L_8_snr,Polar_rate_1_12_L_8, 'd-', 'Color', my_colors(8,:), 'LineWidth', lineWidth);
    semilogy(Polar_rate_1_12_L_32_snr,Polar_rate_1_12_L_32, 'd-', 'Color', my_colors(9,:), 'LineWidth', lineWidth);
    semilogy(T_10_v_8_m_12_rate_1_12_snr,T_10_v_8_m_12_rate_1_12, 'o-', 'Color', my_colors(14,:), 'LineWidth', lineWidth);
    semilogy(T_10_v_8_m_13_rate_1_12_snr,T_10_v_8_m_13_rate_1_12, 'o-', 'Color', my_colors(20,:), 'LineWidth', lineWidth);
    semilogy(rcu_snr_rate_1_12,rcu_rate_1_12, '--', 'Color', 'k', 'LineWidth', lineWidth);

    grid on;
    %title("FER vs. SNR: BPSK with 1-D noise, k=64");
    ylabel('Frame Error Rate', 'interpreter', 'latex', 'FontSize', labelTextSize);
    xlabel("SNR(dB)", 'interpreter', 'latex', 'FontSize', labelTextSize);
    legend(...
        "S-LVA DSO CRC $v=8$, $m=12$",...
        "S-LVA DSO CRC $v=8$, $m=13$",...
        "RCU Bound",...
        "S-LVA DSO CRC $v=6$, $m=10$",...
        "S-LVA DSO CRC $v=8$, $m=10$",...
        "S-LVA DSO CRC $v=8$, $m=11$",...
        "PC-Polar $L=8$",...
        "PC-Polar $L=32$",...
        'location', 'northeast',...
        'interpreter', 'latex',...
        'Location','SouthOutside',...
        'NumColumns', 3, 'FontSize', legendTextSize);
    %legend("FizzBuzz", 'Location', 'NorthEast');
    xlim([-7, 2]);
    ylim([10^-6, 10^-1]);
    set(gcf,'position', [x0,y0,width,height]);
    
    %Adding annotation to plot
    dim = [.70 .71 .12 .06];
    annotation('ellipse',dim);
    x = [0.66 0.70];
    y = [0.74 0.74];
    annotation('textarrow',x,y,'String','Rate-$1/3$', 'interpreter', 'latex',...
        'FontSize', legendTextSize)
    
    dim = [.43 .57 .12 .06];
    annotation('ellipse',dim);
    x = [0.40 0.43];
    y = [0.60 0.60];
    annotation('textarrow',x,y,'String','Rate-$1/6$', 'interpreter', 'latex',...
        'FontSize', legendTextSize)
    
    dim = [.18 .43 .12 .06];
    annotation('ellipse',dim);
    x = [0.33 0.30];
    y = [0.46 0.46];
    annotation('textarrow',x,y,'String','Rate-$1/12$', 'interpreter', 'latex',...
        'FontSize', legendTextSize)
    
    saveas(gcf, "Plot_Globecom_2019_TBCC_FER_SNR_LowRate");
    %saveas(gcf, "Plot_Globecom_2019_TBCC_FER_SNR_LowRate.pdf");
end


%Plot expected list size vs. SNR
if(0)
    figure;
    my_colors = distinguishable_colors(30);
    lineWidth = 1.5;
    semilogy(EL_v_6_m_11_punctured_snr,EL_v_6_m_11_punctured, '-o', 'Color', my_colors(1,:), 'LineWidth', lineWidth); hold on;
    semilogy(EL_v_7_m_10_punctured_snr,EL_v_7_m_10_punctured, '-o', 'Color', my_colors(2,:), 'LineWidth', lineWidth);
    semilogy(EL_v_8_m_10_punctured_snr,EL_v_8_m_10_punctured, '-o', 'Color', my_colors(30,:), 'LineWidth', lineWidth);
    semilogy(EL_T_3_v_6_m_10_rate_1_3_snr,EL_T_3_v_6_m_10_rate_1_3, '-x', 'Color', my_colors(3,:), 'LineWidth', lineWidth);
    %semilogy(EL_T_5_v_6_m_10_rate_1_6_snr,EL_T_5_v_6_m_10_rate_1_6, 'Color', my_colors(4,:), 'LineWidth', lineWidth);
    %semilogy(EL_T_5_v_6_m_11_rate_1_6_snr,EL_T_5_v_6_m_11_rate_1_6, 'Color', my_colors(5,:), 'LineWidth', lineWidth);
    %semilogy(EL_T_5_v_7_m_10_rate_1_6_snr,EL_T_5_v_7_m_10_rate_1_6, 'Color', my_colors(6,:), 'LineWidth', lineWidth);
    %semilogy(EL_T_5_v_7_m_11_rate_1_6_snr,EL_T_5_v_7_m_11_rate_1_6, 'Color', my_colors(7,:), 'LineWidth', lineWidth);
    semilogy(EL_T_5_v_8_m_10_rate_1_6_snr,EL_T_5_v_8_m_10_rate_1_6, '-s', 'Color', my_colors(12,:), 'LineWidth', lineWidth);
    semilogy(EL_T_5_v_8_m_11_rate_1_6_snr,EL_T_5_v_8_m_11_rate_1_6, '-s', 'Color', my_colors(13,:), 'LineWidth', lineWidth);
    %semilogy(EL_T_10_v_6_m_12_rate_1_12_snr,EL_T_10_v_6_m_12_rate_1_12, 'Color', my_colors(10,:), 'LineWidth', lineWidth);
    %semilogy(EL_T_10_v_6_m_13_rate_1_12_snr,EL_T_10_v_6_m_13_rate_1_12, 'Color', my_colors(11,:), 'LineWidth', lineWidth);
    %semilogy(EL_T_10_v_7_m_12_rate_1_12_snr,EL_T_10_v_7_m_12_rate_1_12, 'Color', my_colors(12,:), 'LineWidth', lineWidth);
    %semilogy(EL_T_10_v_7_m_13_rate_1_12_snr,EL_T_10_v_7_m_13_rate_1_12, 'Color', my_colors(13,:), 'LineWidth', lineWidth);
    semilogy(EL_T_10_v_8_m_12_rate_1_12_snr,EL_T_10_v_8_m_12_rate_1_12, '-^', 'Color', my_colors(14,:), 'LineWidth', lineWidth);
    semilogy(EL_T_10_v_8_m_13_rate_1_12_snr,EL_T_10_v_8_m_13_rate_1_12, '-^', 'Color', my_colors(20,:), 'LineWidth', lineWidth);

    grid on;
    %title("E_{L} vs. SNR: BPSK with 1-D noise, k=64");
    ylabel('$E_{L}$', 'interpreter', 'latex');
    xlabel("SNR(dB)", 'interpreter', 'latex');
    legend("Rate $1/2$, $v=6$, $m=11$",...
        "Rate $1/2$, $v=7$, $m=10$",...
        "Rate $1/2$, $v=8$, $m=10$",...
        "Rate $1/3$, $v=6$, $m=10$",..."Rate 1/6, v=6, m=10","Rate 1/6, v=6, m=11","Rate 1/6, v=7, m=10","Rate 1/6, v=7, m=11",
        "Rate $64/370$, $v=8$, $m=10$",...
        "Rate $64/375$, $v=8$, $m=11$",..."Rate 1/12, v=6, m=12","Rate 1/12, v=6, m=13","Rate 1/12, v=7, m=12","Rate 1/12, v=7, m=13",
        "Rate $64/760$, $v=8$, $m=12$",...
        "Rate $64/770$, $v=8$, $m=13$",...
        'interpreter', 'latex');
    xlim([-7, 4]);
    set(gcf,'position', [x0,y0,width,height]);
    saveas(gcf, "Plot_Globecom_2019_TBCC_ListSize_SNR");
    %saveas(gcf, "Plot_Globecom_2019_TBCC_ListSize_SNR.pdf");
end

%Plot expected list size vs. FER
if (0)
    figure;
    my_colors = distinguishable_colors(30);
    lineWidth = 1.5;
    loglog(v_6_m_11_punctured,EL_v_6_m_11_punctured, '-o', 'Color', my_colors(1,:), 'LineWidth', lineWidth); hold on;
    loglog(v_7_m_10_punctured,EL_v_7_m_10_punctured, '-o', 'Color', my_colors(2,:), 'LineWidth', lineWidth);
    loglog(v_8_m_10_punctured,EL_v_8_m_10_punctured, '-o', 'Color', my_colors(30,:), 'LineWidth', lineWidth);
    loglog(T_3_v_6_m_10_rate_1_3,EL_T_3_v_6_m_10_rate_1_3, '-x', 'Color', my_colors(3,:), 'LineWidth', lineWidth);
    %loglog(T_5_v_6_m_10_rate_1_6,EL_T_5_v_6_m_10_rate_1_6, 'Color', my_colors(4,:), 'LineWidth', lineWidth);
    %loglog(T_5_v_6_m_11_rate_1_6,EL_T_5_v_6_m_11_rate_1_6, 'Color', my_colors(5,:), 'LineWidth', lineWidth);
    %loglog(T_5_v_7_m_10_rate_1_6,EL_T_5_v_7_m_10_rate_1_6, 'Color', my_colors(6,:), 'LineWidth', lineWidth);
    %loglog(T_5_v_7_m_11_rate_1_6,EL_T_5_v_7_m_11_rate_1_6, 'Color', my_colors(7,:), 'LineWidth', lineWidth);
    loglog(T_5_v_8_m_10_rate_1_6,EL_T_5_v_8_m_10_rate_1_6, '-s', 'Color', my_colors(12,:), 'LineWidth', lineWidth);
    loglog(T_5_v_8_m_11_rate_1_6,EL_T_5_v_8_m_11_rate_1_6, '-s', 'Color', my_colors(13,:), 'LineWidth', lineWidth);
    %loglog(T_10_v_6_m_12_rate_1_12,EL_T_10_v_6_m_12_rate_1_12, 'Color', my_colors(10,:), 'LineWidth', lineWidth);
    %loglog(T_10_v_6_m_13_rate_1_12,EL_T_10_v_6_m_13_rate_1_12, 'Color', my_colors(11,:), 'LineWidth', lineWidth);
    %loglog(T_10_v_7_m_12_rate_1_12,EL_T_10_v_7_m_12_rate_1_12, 'Color', my_colors(12,:), 'LineWidth', lineWidth);
    %loglog(T_10_v_7_m_13_rate_1_12,EL_T_10_v_7_m_13_rate_1_12, 'Color', my_colors(13,:), 'LineWidth', lineWidth);
    loglog(T_10_v_8_m_12_rate_1_12,EL_T_10_v_8_m_12_rate_1_12, '-^', 'Color', my_colors(14,:), 'LineWidth', lineWidth);
    loglog(T_10_v_8_m_13_rate_1_12,EL_T_10_v_8_m_13_rate_1_12, '-^', 'Color', my_colors(20,:), 'LineWidth', lineWidth);
    
    grid on;
    %title("E_{L} vs. FER: BPSK with 1-D noise, k=64");
    ylabel('$E_{L}$', 'interpreter', 'latex');
    xlabel("Frame Error Rate", 'interpreter', 'latex');
    legend("Rate $1/2$, $v=6$, $m=11$",...
        "Rate $1/2$, $v=7$, $m=10$",...
        "Rate $1/2$, $v=8$, $m=10$",...
        "Rate $1/3$, $v=6$, $m=10$",...%"Rate 1/6, v=6, m=10","Rate 1/6, v=6, m=11","Rate 1/6, v=7, m=10","Rate 1/6, v=7, m=11",
        "Rate $64/370$, $v=8$, $m=10$",...
        "Rate $64/375$, $v=8$, $m=11$",...%"Rate 1/12, v=6, m=12","Rate 1/12, v=6, m=13","Rate 1/12, v=7, m=12", "Rate 1/12, v=7, m=13",
        "Rate $64/760$, $v=8$, $m=12$",...
        "Rate $64/770$, $v=8$, $m=13$",...
        'location', 'southeast', 'interpreter', 'latex');
    set(gcf,'position', [x0,y0,width,height]);
    saveas(gcf, "Plot_Globecom_2019_TBCC_ListSize_FER");
    %saveas(gcf, "Plot_Globecom_2019_TBCC_ListSize_FER.pdf");
end