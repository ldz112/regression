python train.py \
    --model_name_or_path "/root/models/DeepSeek-Qwen-1.5B" \
    --train_file "./data/train.json" \
    --eval_file "./data/eval.json" \
    --epochs 3 \
    --model_dir "./output_model" \
    --save_merged_model \
    --early_stopping_patience 3
    
    
 NUM_GPUS=$(nvidia-smi --query-gpu=gpu_name --format=csv,noheader | wc -l)
 
torchrun --nproc_per_node=NUM_GPUS \
   train.py \
   --epochs 3 \
   --train_batch_size 4 \
   --grad_accum_steps 2 \
   --model_dir "./output_model"