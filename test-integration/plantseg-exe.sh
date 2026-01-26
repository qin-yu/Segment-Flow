python /camp/home/yuq/work/documents/aiod/Segment-Flow/modules/models/resources/usr/bin/run_plantseg2.py \
    --img-path /camp/home/yuq/work/downloads/N_511_final_crop_ds2_raw.tif \
    --mask-fname cell_seg \
    --output-dir ./results \
    --model-chkpt dummy \
    --model-config /camp/home/yuq/work/documents/aiod/Segment-Flow/test-integration/plantseg-config.yaml \
    --idxs 400 715 500 810 100 260 \
    --channels 1 \
    --num-slices 260
