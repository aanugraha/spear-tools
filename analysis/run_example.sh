# Uncomment and edit the following lines to create symbolic links so you can choose
# where to keep your data
# ln -sfr <dataset-folder-full-path> spear_data  # Output path for the processed audio, metrics csv and plots
# ln -sfr <outputs-folder-full-path> my_results  # Root folder of the SPEAR datasets containing the folders Main and Extra


# Define variables
SET='Dev'               # 'Train', 'Dev' or 'Eval'.
DATASET=2               # 1 to 4.
SESSION='10'            # 1 to 9 for Train, 10 to 12 for Dev, 13 to 15 for Eval. Select '' for all session of current Dev.
MINUTE='00'             # 00 to 30 (depends on the current session). '' for all minutes of current session.
PROCESSING='baseline'   # Name of desired processing. 'baseline' by default
REFERENCE='passthrough' # Name of desired reference enhancement. 'passthrough' by default.


# Output paths
# These can be whatever you want them to be
audio_dir_ref="my_results/audio_${REFERENCE}_$(date '+%Y%m%d')"
audio_dir_proc="my_results/audio_${PROCESSING}_$(date '+%Y%m%d')"
metrics_dir="my_results/metrics"
plots_dir="my_results/plots/${PROCESSING}_${SET}_D${DATASET}_S${SESSION}_M${MINUTE}"


# Input paths relative to spear_data should not be changed
input_root_ref="spear_data/Main/$SET"
input_root_proc="spear_data/Main/$SET"
segments_csv="segments_$SET.csv"

# Derived paths
metrics_csv_ref="${metrics_dir}/${REFERENCE}_${SET}_D${DATASET}_S${SESSION}_M${MINUTE}.csv"
metrics_csv_proc="${metrics_dir}/${PROCESSING}_${SET}_D${DATASET}_S${SESSION}_M${MINUTE}.csv"



# Run passtrough and enhance
python spear_enhance.py $input_root_ref  $audio_dir_ref  --method_name $REFERENCE --list_cases D$DATASET $SESSION $MINUTE
python spear_enhance.py $input_root_proc $audio_dir_proc --method_name $PROCESSING --list_cases D$DATASET $SESSION $MINUTE

# Compute metrics
python spear_evaluate.py $input_root_ref  $audio_dir_ref  $segments_csv $metrics_csv_ref  --list_cases D$DATASET $SESSION $MINUTE
python spear_evaluate.py $input_root_proc $audio_dir_proc $segments_csv $metrics_csv_proc --list_cases D$DATASET $SESSION $MINUTE

# Visualise/plot metrics
python spear_visualise.py $plots_dir $metrics_csv_ref $metrics_csv_proc --reference_name $REFERENCE --method_name $PROCESSING
