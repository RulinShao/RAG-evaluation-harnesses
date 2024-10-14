#!/bin/bash
#SBATCH --job-name=mmlu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --hint=nomultithread
#SBATCH --account fair_amaia_cw_explore
#SBATCH --qos explore
#SBATCH --mem 1000G
#SBATCH --gres=gpu:1
#SBATCH --time 1:00:00
#SBATCH --requeue
#SBATCH --chdir=/home/rulin/RAG-evaluation-harnesses
#SBATCH --output=/checkpoint/amaia/explore/rulin/mmlu/slurm_cache/slurm-%A_%a.out
#SBATCH --error=/checkpoint/amaia/explore/rulin/mmlu/slurm_cache/slurm-%A_%a.err
#SBATCH --array=0-569


cd /home/rulin/RAG-evaluation-harnesses
source /home/rulin/miniconda3/bin/activate
conda activate vllm


# 57 subjects
mmlu_domains=('mmlu_econometrics' 'mmlu_moral_disputes' 'mmlu_marketing' 'mmlu_college_biology' 'mmlu_high_school_geography' 'mmlu_professional_medicine' 'mmlu_high_school_chemistry' 'mmlu_high_school_computer_science' \
'mmlu_high_school_european_history' 'mmlu_international_law' 'mmlu_global_facts' 'mmlu_human_aging' 'mmlu_anatomy' 'mmlu_miscellaneous' 'mmlu_formal_logic' 'mmlu_conceptual_physics' 'mmlu_high_school_physics' 'mmlu_prehistory' \
'mmlu_computer_security' 'mmlu_jurisprudence' 'mmlu_college_mathematics' 'mmlu_high_school_world_history' 'mmlu_business_ethics' 'mmlu_human_sexuality' 'mmlu_sociology' 'mmlu_clinical_knowledge' 'mmlu_high_school_biology' \
'mmlu_college_chemistry' 'mmlu_medical_genetics' 'mmlu_high_school_mathematics' 'mmlu_professional_accounting' 'mmlu_high_school_government_and_politics' 'mmlu_logical_fallacies' 'mmlu_professional_law' 'mmlu_electrical_engineering' \
'mmlu_elementary_mathematics' 'mmlu_public_relations' 'mmlu_moral_scenarios' 'mmlu_college_medicine' 'mmlu_high_school_microeconomics' 'mmlu_machine_learning' 'mmlu_world_religions' 'mmlu_high_school_statistics' 'mmlu_nutrition' \
'mmlu_us_foreign_policy' 'mmlu_philosophy' 'mmlu_high_school_macroeconomics' 'mmlu_security_studies' 'mmlu_high_school_psychology' 'mmlu_high_school_us_history' 'mmlu_college_computer_science' 'mmlu_professional_psychology' \
'mmlu_abstract_algebra' 'mmlu_astronomy' 'mmlu_virology' 'mmlu_college_physics' 'mmlu_management')


doc_index=$(($SLURM_ARRAY_TASK_ID / ${#mmlu_domains[@]}))
task_index=$(($SLURM_ARRAY_TASK_ID % ${#mmlu_domains[@]}))

i=$doc_index
TASK=${mmlu_domains[$task_index]}
echo $i
echo $TASK

MODEL_NAME_OR_PATH="meta-llama/Llama-3.1-8B-Instruct"
NUM_FEWSHOT=0

lm_eval --model vllm \
    --model_args pretrained=$MODEL_NAME_OR_PATH \
    --tasks $TASK \
    --batch_size auto \
    --retrieval_file /home/rulin/data/mmlu_searched_results_from_massiveds/${TASK}_retrieved_results.jsonl \
    --concat_k 1 \
    --num_fewshot $NUM_FEWSHOT \
    --log_samples \
    --output_path /checkpoint/amaia/explore/rulin/mmlu/rag_cache_all_docs/${NUM_FEWSHOT}_shot/${TASK}_$i.json \
    --specified_document_id $i \
    --log_to_spreadsheet
