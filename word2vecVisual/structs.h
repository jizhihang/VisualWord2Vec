#ifndef STRUCTS
#define STRUCTS

// Structure to hold the index information
struct featureWord{
    char* str;
    int count;
    int* index;
    // Word embedding for the instance
    float* embed; 
    float magnitude;
    // Word embeddings for each of the model
    float* embedR, *embedP, *embedS, *embedRaw;
    float magnitudeR, magnitudeP, magnitudeS, magnitudeRaw;

    // Refined / raw
    int useRaw;
};

// Structure to hold information about P,R,S triplets
struct prsTuple{
    int p, r, s;
    //struct featureWord p, r, s;
    
    // visual features for the instance 
    float* feat;
    // Cluster id assigned to the current instance
    int cId; 
};

// Structure
struct vocab_word {
  long long cn;
  int *point;
  char *word, *code, codelen;
};

// Structure to hold information about vp task
struct Sentence{
    // Actual sentences
    char* sent;
    // no of tokens
    int count;
    // no of words recognized in the current vocab
    int actCount;
    // indices of the words recognized in the curent vocab
    int* index;
    // Indices of the words at the end of each sentence
    int* endIndex;
    // Number of sentences
    int sentCount;
    // Training visual feature used for clustering
    float* vFeat;
    // Cluster Id for the feature
    int cId;
    // Ground truth whether the sentence/corresponding is truth or not
    int gt;
    // Feature index in case of many-to-one (MS COCO)
    int featInd;

    // Embeddings for the sentence
    float* embed;

    // Other visual features
    float* otherFeats;
};

// Structure for holding the pair of sentences used in VP task
struct SentencePair{
    // Pair of sentences
    struct Sentence* sent1;
    struct Sentence* sent2;

    // Ground truth of the pair
    int gt;
    // If training/test
    int isTrain;
    // If in the val set
    int isVal;
    // Record the base score and improved score
    float baseScore, newScore;

    // Features (word2vec, coc, tf) in that order
    float* feature;
};

// Enumerations
// Training mode for vp task
// Refining using either entire descriptions/sentences/words
enum TrainMode {DESCRIPTIONS, SENTENCES, WINDOWS, WORDS};
#endif
