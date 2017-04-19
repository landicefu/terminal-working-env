source_dir=$(dirname $BASH_SOURCE)
source $source_dir/mac.sh
source $source_dir/source_navigation.sh
source $source_dir/android.sh
source $source_dir/search.sh

function tupdate() {
	source ~/.bash_profile
	remove_duplicated_path
}
