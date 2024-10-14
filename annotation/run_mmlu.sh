# https://github.com/hendrycks/test/blob/master/categories.py
math=(college_mathematics elementary_mathematics high_school_mathematics high_school_statistics)
# abstract_algebra

MODEL_NAME_OR_PATH="meta-llama/Llama-3.1-8B-Instruct"
NUM_FEWSHOT=0

for SUB in "${math[@]}"; do
TASK=mmlu_${SUB}
for i in {0..99}; do
lm_eval --model vllm \
    --model_args pretrained=$MODEL_NAME_OR_PATH \
    --tasks $TASK \
    --batch_size auto \
    --retrieval_file /checkpoint/amaia/explore/rulin/mmlu/mmlu_searched_results_from_massiveds/${TASK}_retrieved_results.jsonl \
    --concat_k 1 \
    --num_fewshot $NUM_FEWSHOT \
    --log_samples \
    --output_path /checkpoint/amaia/explore/rulin/mmlu/rag_cache_all_docs/${NUM_FEWSHOT}_shot/${TASK}_$i.json \
    --specified_document_id $i \
    --log_to_spreadsheet
done
done



MODEL_NAME_OR_PATH="meta-llama/Llama-3.1-8B-Instruct"
TASK="mmlu_abstract_algebra"
NUM_FEWSHOT=5
lm_eval --model vllm \
    --model_args pretrained=$MODEL_NAME_OR_PATH \
    --tasks $TASK \
    --batch_size auto \
    --num_fewshot $NUM_FEWSHOT \
    --log_samples \
    --output_path /checkpoint/amaia/explore/rulin/mmlu/rag_cache_all_docs/lm_only/${TASK}.json \
    --log_to_spreadsheet