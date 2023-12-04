# Run the scripts
.PHONY: get-data eda tune-models get-results

all: .PHONY

# Target for getting train/test data
get-data:
	python src/scripts/english_score_get_data.py \
	--url="https://osf.io/download/g72pq/" \
	--output_folder_path="./data/raw"

# Target for performing EDA
eda: data/raw/train_data.csv
	python src/scripts/english_score_eda.py -v \
	--training-data="data/raw/train_data.csv" \
	--plot-to="results/figures/" \
	--pickle-to="results/models/preprocessor/" \
	--tables-to="results/tables/"

# Target for tuning models
tune-models: data/raw/train_data.csv data/raw/test_data.csv results/models/preprocessor/preprocessor.pkl
	python src/scripts/english_score_tuning.py -v \
	--train="data/raw/train_data.csv" \
	--test="data/raw/test_data.csv" \
	--output_dir="results/" \
	--preprocessor_path="results/models/preprocessor/preprocessor.pkl"

# Target for getting optimal model results
get-results: data/raw/train_data.csv data/raw/test_data.csv results/models/ridge_best_model.pkl
	python src/scripts/english_score_results.py -v \
	--train="data/raw/train_data.csv" \
	--test="data/raw/test_data.csv" \
	--plot_to="results/figures/" \
	--tables_to="results/tables/" \
	--preprocessor_path="results/models/preprocessor/preprocessor.pkl" \
	--best_model_path="results/models/ridge_best_model.pkl"

# Build the docs
docs:
	jupyter-book build notebooks
	cp -r notebooks/_build/html/ docs

# Clean up everything
clean:
	rm -rf data/raw/*.csv
	rm -rf data/raw/*.zip
	rm -rf results/figures/*.png
	rm -rf results/tables/*.csv
	rm -rf results/models/*.pkl
	rm -rf results/models/preprocessor/*.pkl
	rm -rf notebooks/_build
	rm -rf docs/*
