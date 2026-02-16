python /camp/home/yuq/work/documents/aiod/ai-on-demand/src/ai_on_demand/Segment-Flow/modules/models/resources/usr/bin/run_plantseg2.py \
    --model-type generic_confocal_3D_unet \
    --img-path /camp/home/yuq/work/downloads/N_511_final_crop_ds2_raw_crop_small_export.tiff \
    --mask-fname cell_seg \
    --output-dir ./results \
    --model-chkpt dummy \
    --model-config /camp/home/yuq/work/documents/aiod/ai-on-demand/src/ai_on_demand/Segment-Flow/tests/plantseg-config.yaml \
    --idxs 0 115 0 108 0 80 \
    --channels 1 \
    --num-slices 80
