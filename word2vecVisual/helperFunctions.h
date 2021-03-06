# ifndef HELPER_FUNCS
# define HELPER_FUNCS

// Standard libraries
# include <stdio.h>
# include <stdlib.h>
# include <string.h>
# include <math.h>
# include <pthread.h>
# include <ctype.h>

// For clustering
# include <yael/vector.h>
# include <yael/kmeans.h>
# include <yael/machinedeps.h>
# include "structs.h"
# include "macros.h"

// Declaring the extern variables allowing separation of code
extern long long vocab_size, layer1_size;
extern float *syn0, *syn1, *syn0P, *syn0S, *syn0R;
extern int num_threads;

// Returns position of a word in the vocabulary; if the word is not found, returns -1
int SearchVocab(char *word);
// Returns hash value of a word
int GetWordHash(char *word);
// Adds a word to the vocabulary
int AddWordToVocab(char *word);

// Saving the word2vec vectors for further use
void saveWord2Vec(char*);
// Saving the word2vec vectors for further use (multi)
void saveWord2VecMulti(char*);
// Load the word2vec vectors
// We assume all the other parameters(vocabulary is kept constant)
// Use with caution
void loadWord2Vec(char*);

// Initializing the network and read the embeddings
void initializeEmbeddings(char* embedPath);

// Multiple character split
// Source: http://stackoverflow.com/questions/29788983/split-char-string-with-multi-character-delimiter-in-c
char *multi_tok(char *, char *);

/***************************************************/
// Read the sentences
struct Sentence** readSentences(char*, long*);

// Tokenize sentences
void tokenizeSentences(struct Sentence*, long);

// Save the sentence embeddings
void writeSentenceEmbeddings(char*, struct Sentence*, long);

/***************************************************/
// Read the features from the text file
float*** readVisualFeatures(char*, long*, int*);
// Thread for reading the visual feature
void* readVisualFeaturesThread(void*);

# endif
// Save the sentences back into a text file
void saveSentences(struct Sentence*, int, char*);
// Save the features back into a text file
void saveVisualFeatures(float**, long, int, char*);
/***************************************************/
