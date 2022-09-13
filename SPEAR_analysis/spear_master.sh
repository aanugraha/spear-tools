# Setup soft links to make paths easier
ln -sf <outputs-folder-full-path> my_results  
ln -sf <dataset-folder-full-path> spear_data  

# Define variables
SET='Dev'
DATASET=2
SESSION=''
MINUTE=''
METRICS=''
METHOD='baseline'


# Run passtrough and enhance
python spear_enhance.py "spear_data/Main/$SET" "my_results/audio_passthrough_$(date '+%Y%m%d')" -m passthrough -l D$DATASET $SESSION $MINUTE
python spear_enhance.py "spear_data/Main/$SET" "my_results/audio_${METHOD}_$(date '+%Y%m%d')" -m $METHOD -l D$DATASET $SESSION $MINUTE

# Compute metrics
python spear_evaluate.py "spear_data/Main/$SET" "my_results/audio_passthrough_$(date '+%Y%m%d')" "segments_$SET.csv" "my_results/metrics/passthrough_${SET}_D${DATASET}_S${SESSION}_M${MINUTE}.csv"  -l D$DATASET $SESSION $MINUTE -m $METRICS
python spear_evaluate.py "spear_data/Main/$SET" "my_results/audio_${METHOD}_$(date '+%Y%m%d')" "segments_$SET.csv" "my_results/metrics/${METHOD}_${SET}_D${DATASET}_S${SESSION}_M${MINUTE}.csv"  -l D$DATASET $SESSION $MINUTE -m $METRICS

# Visualise/plot metrics
python spear_visualise.py "my_results/metrics/${METHOD}_${SET}_D${DATASET}_S${SESSION}_M${MINUTE}" "my_results/metrics/passthrough_${SET}_D${DATASET}_S${SESSION}_M${MINUTE}.csv" "my_results/metrics/${METHOD}_D${DATASET}_S${SESSION}_M${MINUTE}.csv" -m $METHOD
