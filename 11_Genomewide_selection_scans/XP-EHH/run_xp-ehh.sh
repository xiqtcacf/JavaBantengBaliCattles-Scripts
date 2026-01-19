# This is how the xp-ehh run after wgscan is run
input_dir=path_to_wgscan_files
pop1_prefix=prefix_for_wgscan_result_of_pop1
pop2_prefix=prefix_for_wgscan_result_of_pop2
pop1_ID=name_of_pop1_for_xp-ehh
pop2_ID=name_of_pop2_for_xp-ehh

Rscript calculate_xp-ehh.R $input_dir $pop1_prefix $pop2_prefix $pop1_ID $pop2_ID
