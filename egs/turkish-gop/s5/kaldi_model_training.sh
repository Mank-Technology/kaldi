utils/prepare_lang.sh --position-dependent-phones false data/local/dict '<UNK>' data/local/lang data/lang
utils/utt2spk_to_spk2utt.pl data/train/utt2spk > data/train/spk2utt
utils/validate_data_dir.sh --no-feats data/train/
steps/make_mfcc.sh --nj 12 --cmd 'utils/run.pl' data/train/ exp/make_mfcc/train mfcc
steps/compute_cmvn_stats.sh data/train/ exp/make_mfcc/train/ mfcc
utils/subset_data_dir.sh data/train/ 5000 data/train.5k
steps/train_mono.sh --nj 12 --cmd 'utils/run.pl' data/train.5k/ data/lang/ exp/mono
steps/align_si.sh --nj 12 --cmd 'utils/run.pl' data/train.5k/ data/lang/ exp/mono exp/mono_ali
steps/train_deltas.sh --cmd "utils/run.pl" 2500 25000 data/train data/lang exp/mono_ali exp/tri1
steps/align_si.sh --nj 12 --cmd 'utils/run.pl' data/train/ data/lang/ exp/tri1 exp/tri1_ali
steps/train_deltas.sh --cmd "utils/run.pl" 3500 35000 data/train data/lang exp/tri1_ali exp/tri2
steps/align_si.sh --nj 12 --cmd 'utils/run.pl' data/train/ data/lang/ exp/tri2 exp/tri2_ali
steps/train_lda_mllt.sh --cmd "utils/run.pl" 3500 35000 data/train data/lang exp/tri2_ali exp/tri3
steps/align_fmllr.sh --nj 12 --cmd 'utils/run.pl' data/train/ data/lang/ exp/tri3 exp/tri3_ali
steps/train_sat.sh --cmd "utils/run.pl" 4000 40000 data/train data/lang exp/tri3_ali exp/tri4
steps/align_fmllr.sh --nj 12 --cmd 'utils/run.pl' data/train/ data/lang/ exp/tri4 exp/tri4_ali
