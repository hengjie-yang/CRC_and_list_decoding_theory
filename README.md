# CRC_and_list_decoding_theory
This repo contains scripts related to the theoretical analysis of DSO CRC search and list decoding.

## Updates
- *03/28/2021 Added detailed descriptions of scripts.*
- *09/17/2020 Originally written by Hengjie Yang (hengjie.yang@ucla.edu).*

## Purpose of this repository
This repo is associated with the ongoing IT Transaction manuscript "CRC-Aided List Decoding of Convolutional Codes in the Short Blocklength Regime".

### References
 1. H. Yang, E. Liang, M. Pan, and R. D. Wesel, "CRC-Aided List Decoding of Convolutional Codes in the Short Blocklength Regime", *submitted to IEEE Transactions on Information Theory*.

## Scripts for the IT Transaction manuscript
- TIT_script_add_line_segments_to_tradeoff_plot.m
- TIT_script_compute_upper_bound_on_d_crc.m
- TIT_script_plot_approximations_cond_exp_list_rank.m
- TIT_script_plot_cond_exp_list_rank_vs_eta.m
- TIT_script_plot_exp_list_size_vs_SNR.m
- TIT_script_plot_exp_list_size_vs_SNR_TBCC.m
- TIT_script_plot_P_UE_and_RCU_MC_bounds_TBCC.m
- TIT_script_plot_prob_of_UE_vs_Psi.m
- TIT_script_plot_prob_of_UE_vs_SNR.m
- TIT_script_plot_union_bounds.m


## Scripts for plotting the saddlepoint approximation of the RCU bound and MC bound
See scripts under "rcu_files" folder and "mc_files" folder

## Scripts for studying discrete cases (channel is a BSC)
- Analysis_discrete_case_list_size_upper_bound.m
- Analysis_discrete_case_list_size_upper_bound_v2.m
- Analysis_equivalence_class_method.m
- Analysis_relative_distance_spectra_pattern.m
- Compute_brute_force_bound.m
- Compute_covering_radius.m
- Compute_hist_cond_undetected_dist.m
- Compute_relative_distance_spectrum.m
- Compute_relative_distance_spectrum_brute_force.m
- Compute_relative_low_rate_code_spectrum.m
- Simulation_expected_list_size_hard_SLVD.m
- DBS_LVA_Hamming.m
- Plot_upper_bound_and_conditional_exp_list_sizes
- Plot_upper_bound_expected_list_size.m
- Tool_script_equivalence_class_by_weight.m
- Tool_script_Combinatorics.m

## Scripts for studying continuous cases (channel is a BI-AWGN channel)
- Analysis_continuous_case_list_size_upper_bound.m
- Analysis_cond_exp_list_rank_vs_eta.m
- Check_divisibility.m
- Compress_raw_data_into_list_rank_table.m
- Simulation_cond_expected_list_size_soft_SLVD.m
- Simulation_expected_list_size_soft_SLVD.m
- Simulation_expected_list_size_soft_SLVD_origin_noise.m
- DBS_LVA_Euclidean.m
- DBS_LVA_TBCC_Euclidean.m
- Tool_script_compute_critical_normalized_factor_eta.m
- Tool_script_empirical_list_size_distribution.m
- Tool_script_plot_Voronoi_regions.m
- Tool_script_RCU_and_MC_bounds.m









