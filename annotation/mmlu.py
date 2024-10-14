import os
import json
import pdb
from collections import defaultdict


def read_json(path):
    data = []
    with open(path, 'r') as file:
        for line in file:
            try:
                data.append(json.loads(line))
            except json.JSONDecodeError as e:
                print(f"Error decoding JSON: {e}")
    return data

def annotate_documents(output_dir, subject, num_documents, model_id):
    helpful_doc_ids = defaultdict(list)
    for ctx_id in range(num_documents):
        sub_dir = os.path.join(output_dir, f'{subject}_{ctx_id}.json', model_id)
        for filename in os.listdir(sub_dir):
            if 'samples' in filename:
                _data = read_json(os.path.join(sub_dir, filename))
                for ex in _data:
                    sample_id = int(ex['doc_id'])
                    acc = ex['acc']
                    if acc:
                        helpful_doc_ids[sample_id].append(ctx_id)
    pdb.set_trace()



if __name__ == '__main__':
    output_dir = '/checkpoint/amaia/explore/rulin/mmlu/rag_cache_all_docs/0_shot'
    subject = 'mmlu_abstract_algebra'
    model_id = 'meta-llama__Llama-3.1-8B-Instruct'
    num_documents = 100
    annotate_documents(output_dir, subject, num_documents, model_id)