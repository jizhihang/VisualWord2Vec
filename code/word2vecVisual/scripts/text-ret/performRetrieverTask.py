# Script to read the tuples for the text based image retrieval task
import pickle
import json
from ImageRetriever import ImageRetriever

print 'Started the task'
# Setting up paths
dataPath = '/home/satwik/VisualWord2Vec/data/text-ret/';
#tupPath = dataPath + 'text_ret_pilot_lemma.p';
tupPath = dataPath + 'text_ret_final_lemma.p';
with open(tupPath, 'rb') as dataFile:
    tupData = pickle.load(dataFile);

# Order : Relation, Primary, Secondary
tuples = tupData['data'];

# Create instance of the task (with multiple / single embeddings)
task = ImageRetriever('SINGLE');
#task = ImageRetriever('SINGLE', raw = True);
# Read the ground truth
gtPath = dataPath + 'pilot_gt.txt';
task.readGroundTuples(gtPath);

# Reading embeddings for multiple models
#modelPath = '/home/satwik/VisualWord2Vec/models/%s_wiki_model.txt';
#modelPath = '/home/satwik/VisualWord2Vec/data/%s_model.bin';
#embedPath = "/home/satwik/VisualWord2Vec/code/word2vecVisual/modelsNdata/wiki_iters/word2vec_wiki_iter_24.bin";
#task.loadWord2Vec(embedPath)
#task.performTask(tuples)

# Save the scores, ground list and top queries
#pickle.dump(task.scores, open('after_scores.pickle', 'wb'));
#pickle.dump(task.tupleList, open('tupleList.pickle', 'wb'));

embedPath = "/home/satwik/VisualWord2Vec/code/word2vecVisual/modelsNdata/wiki_iters/word2vec_wiki_iter_0.bin";
task.loadWord2Vec(embedPath)
task.performTask(tuples)
pickle.dump(task.scores, open('before_scores_redone.pickle', 'wb'));
print 'Saved pickle files'

'''embedPaths = {};
for i in ['r', 'p', 's']:
    embedPaths[i] = modelPath % i;
task.loadWord2Vec(embedPaths)
task.performTask(tuples)'''


'''embedPath = '/home/satwik/VisualWord2Vec/code/word2vecVisual/modelsNdata/al_vectors.txt';
task.loadWord2Vec(embedPath, 'raw')
#task.performTask(tuples)

embedPath = '/home/satwik/VisualWord2Vec/data/word2vec_output_bestmodel_single.bin';
task.loadWord2Vec(embedPath)

# Vocab file for coco
vocabPath = "/home/satwik/VisualWord2Vec/code/word2vecVisual/modelsNdata/refineVocab_coco.bin";
# Load the refined vocab (words that got refined)
task.loadRefineVocab(vocabPath);

task.performTask(tuples);'''

####################### Examples ##########################

#embedPath = '/home/satwik/VisualWord2Vec/models/vp_coco_embeddings.bin';
# word2vec path 0.156923076923 0.391538461538 0.510769230769
# Only 3: 0.173076923077 0.390384615385 0.509615384615
'''embedPath = '/home/satwik/VisualWord2Vec/code/word2vecVisual/modelsNdata/word2vec_before_refine.bin';
task.readWord2Vec(embedPath);
# Perform the task
task.performTask(tuples);

# Read after refining and perform task again 0.166923 0.3853846 0.5330769 
# Only 3:0.180769230769 0.388461538462 0.540384615385
embedPath = '/home/satwik/VisualWord2Vec/code/word2vecVisual/modelsNdata/word2vec_after_refine.bin';
task.readWord2Vec(embedPath);
# Perform the task
task.performTask(tuples);'''

#0.147692307692 0.362307692308 0.483076923077
#embedPath = '/home/satwik/VisualWord2Vec/code/word2vecVisual/modelsNdata/al_vectors.txt';
#task.readWord2Vec(embedPath);
# Perform the task
#task.performTask(tuples);

# Reading embeddings for multiple models
'''modelPath = '/home/satwik/VisualWord2Vec/data/%s_model.bin';
embedPaths = {};
for i in ['r', 's', 'p']:
    embedPaths[i] = modelPath % i;
task.readWord2Vec(embedPaths)'''

#embedPath = '/home/satwik/VisualWord2Vec/code/word2vecVisual/modelsNdata/word2vec_output_bestmodel_single.bin';
'''embedPath = '/home/satwik/VisualWord2Vec/models/wiki_embeddings_pre_refine.bin';
#0.133076923077 0.324615384615 0.422307692308
# Only top 3 : 0.159615384615 0.369230769231 0.490384615385
task.readWord2Vec(embedPath);
# Perform the task
task.performTask(tuples);

#0.124615384615 0.290769230769 0.383076923077
# Only top 3 :  
embedPath = '/home/satwik/VisualWord2Vec/models/wiki_embeddings_post_refine.bin';
task.readWord2Vec(embedPath);
# Perform the task
task.performTask(tuples);'''

# Read the embeddings dumped during each iteration of refining and re-do text 
# retrieval
'''dumpPath = "/home/satwik/VisualWord2Vec/code/word2vecVisual/modelsNdata/word2vec_wiki_iter_0.bin";
task.readWord2Vec(dumpPath);
task.performTask(tuples);
dumpPath = "/home/satwik/VisualWord2Vec/code/word2vecVisual/modelsNdata/word2vec_wiki_iter_24.bin";
task.readWord2Vec(dumpPath);
task.performTask(tuples);'''

'''dumpPath = "/home/satwik/VisualWord2Vec/code/word2vecVisual/modelsNdata/word2vec_iter_%d.bin";
for i in xrange(0, 34):
    print 'Current iteration : %d / %d' % (i, 34)

    # Read embeddings and perform task
    task.readWord2Vec(dumpPath % i);
    task.performTask(tuples);'''
