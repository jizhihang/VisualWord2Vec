% Script to analyze the clusters initially formed
% Flags to show relevant parts
% showPRS = show the tsne of P,R,S separately
% showPRStog = sow the tsne of P,R,S together

% Read the file
clustIdPath = '../../modelsNdata/cluster_id_save_25.txt';
cIds = dlmread(clustIdPath);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Show the TSNE for P,R,S
% Read the tuples and feature files
% Setting up paths
rootPath = '/home/satwik/VisualWord2Vec/';
%rootPath = '/Users/skottur/CMU/Personal/VisualWord2Vec/';

addpath(fullfile(rootPath, 'code/io/'));
addpath(genpath(fullfile(rootPath, 'libs')));
psrPath = fullfile(rootPath, 'data/PSR_features.txt');
featPath = fullfile(rootPath, 'data/float_features_withoutheader.txt');

%rootPath = '/home/satwik/VisualWord2Vec/code/word2vecVisual';
rootPath = fullfile(rootPath, '/code/word2vecVisual');
modelPath = fullfile(rootPath, 'modelsNdata');

preFile = fullfile(modelPath, 'word2vec_wiki_pre_0_0_1_25.txt');
postFile = fullfile(modelPath, 'word2vec_wiki_post_0_0_1_25.txt');
vocabFile = fullfile(modelPath, 'word2vec_vocab_0_0_0_25.txt');

% Dont read if already exists in workspace
if(~exist('Rfeats', 'var'))
    [Plabel, Slabel, Rlabel, Rfeats] = readFromFile(psrPath, featPath);
end

if(~exist('preEmbed', 'var'))
    % Read the embeddings before / after refining along with vocab
    [preEmbed, postEmbed, featureWords] = ...
                        readEmbedFile(preFile, postFile, vocabFile, true);
end

% Collect unique embeddings for top sorted tuples
% Consider P,R,S separately
% Collect the embeddings for top sorted tuples
noInst = length(Plabel);
noClusters = size(cIds, 1);
featDim = 200;

pLabels = {};
rLabels = {};
sLabels = {};
pId = zeros(noInst, 1);
rId = zeros(noInst, 1);
sId = zeros(noInst, 1);
uniqPreP = zeros(noInst, featDim);
uniqPreR = zeros(noInst, featDim);
uniqPreS = zeros(noInst, featDim);
uniqPostP = zeros(noInst, featDim);
uniqPostR = zeros(noInst, featDim);
uniqPostS = zeros(noInst, featDim);

% Pre and post embeds for P,R,S for all the examples
% Also get majority cluster for each of P, R, S
for i = 1:noInst
    % Check if already exists
    p = Plabel{i};
    r = Rlabel{i};
    s = Slabel{i};
    
    % P
    % New label, add it
    if(~ismember(p, pLabels))
        % Check for all the dominant clusters current label is present
        clustHist = hist(cIds(strcmp(p, Plabel), 1), 1:noClusters);
        %clusts = find(hist(cIds(strcmp(p, Plabel), 1), 1:noClusters) > 0);
        % Take the mode
        [~, clusts] = max(clustHist);
        for k = clusts
            pLabels = [pLabels, {p}];
            pId(length(pLabels)) = k;
            uniqPreP(length(pLabels), :) = preEmbed.P(p);
            uniqPostP(length(pLabels), :) = postEmbed.P(p);
        end
    end

    % R
    % New label, add it
    if(~ismember(r, rLabels))
        % Check for all the dominant clusters current label is present
        clustHist = hist(cIds(strcmp(r, Rlabel), 1), 1:noClusters);
        %clusts = find(hist(cIds(strcmp(r, Rlabel), 1), 1:noClusters) > 0);
        [~, clusts] = max(clustHist);
        for k = clusts
            rLabels = [rLabels, {r}];
            rId(length(rLabels)) = k;
            uniqPreR(length(rLabels), :) = preEmbed.R(r);
            uniqPostR(length(rLabels), :) = postEmbed.R(r);
        end
    end

    % S
    % New label, add it
    if(~ismember(s, sLabels))
        % Check for all the dominant clusters current label is present
        clustHist = hist(cIds(strcmp(s, Slabel), 1), 1:noClusters);
        %clusts = find(hist(cIds(strcmp(s, Slabel), 1), 1:noClusters) > 0);
        [~, clusts] = max(clustHist);
        for k = clusts
            sLabels = [sLabels, {s}];
            sId(length(sLabels)) = k;
            uniqPreS(length(sLabels), :) = preEmbed.S(s);
            uniqPostS(length(sLabels), :) = postEmbed.S(s);
        end
    end
end

% Trim the matrices
uniqPreP = uniqPreP(1:length(pLabels), :);
uniqPreR = uniqPreR(1:length(rLabels), :);
uniqPreS = uniqPreS(1:length(sLabels), :);

uniqPostP = uniqPostP(1:length(pLabels), :);
uniqPostR = uniqPostR(1:length(rLabels), :);
uniqPostS = uniqPostS(1:length(sLabels), :);

pId = pId(1:length(pLabels));
rId = rId(1:length(rLabels));
sId = sId(1:length(sLabels));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display the origina clusters in the visual feature space
origClusts = false;
if(origClusts)
    noDims = 2;
    noInitDims = 30;
    perplexity = 50;

    tsneEmbed = tsne(Rfeats, [], noDims, noInitDims, perplexity);
    % Visualizations based on visual features
    % Get the tuples
    tupleLabels = strcat('<', Plabel, ':', Slabel, ':', Rlabel, '>');

    %figure(1); gscatter(tsneEmbed(:, 1), tsneEmbed(:, 2), cIds(:, 1), [], ['o', 'x', 's', 'd'], 2)

    % PLot just one cluster
    noClusters = length(unique(cIds(:, 1)));
    for k = 1:noClusters
        members = cIds(:, 1) == k;
        figure(1); scatter(tsneEmbed(members, 1), tsneEmbed(members, 2))
        dx = 0.1; dy = 0.1;
        text(tsneEmbed(members, 1) + dx, tsneEmbed(members, 2) + dy, tupleLabels(members))
        pause()
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Embed through t-sne (either individual / together)
individual = true;
if(individual)
    noDims = 2;
    noInitDims = [];
    perplexity = 50;

    tsnePreP = tsne(uniqPreP, [], noDims, noInitDims, perplexity);
    tsnePostP = tsne(uniqPostP, [], noDims, noInitDims, perplexity);

    tsnePreS = tsne(uniqPreS, [], noDims, noInitDims, perplexity);
    tsnePostS = tsne(uniqPostS, [], noDims, noInitDims, perplexity);

    tsnePreR = tsne(uniqPreR, [], noDims, noInitDims, perplexity);
    tsnePostR = tsne(uniqPostR, [], noDims, noInitDims, perplexity);

    % Displacement for points
    dx = 0.1; dy = 0.1;
    figure(1); gscatter(tsnePreP(:, 1), tsnePreP(:, 2), pId, [], ...
                                            [], 20)
    %text(tsnePreP(:, 1) + dx, tsnePreP(:, 2) + dy, pLabels)
    figure(2); gscatter(tsnePostP(:, 1), tsnePostP(:, 2), pId, [], ...
                                            [], 20)
    %text(tsnePostP(:, 1) + dx, tsnePostP(:, 2) + dy, pLabels)

    figure(3); gscatter(tsnePreS(:, 1), tsnePreS(:, 2), sId, [], ...
                                                    ['o', '+', 'x'], 5)
    %text(tsnePreS(:, 1) + dx, tsnePreS(:, 2) + dy, sLabels)
    figure(4); gscatter(tsnePostS(:, 1), tsnePostS(:, 2), sId, [], ...
                                                    ['o', '+', 'x'], 5)
    %text(tsnePostS(:, 1) + dx, tsnePostS(:, 2) + dy, sLabels)

    figure(5); gscatter(tsnePreR(:, 1), tsnePreR(:, 2), rId, [], [], 20)
    %text(tsnePreR(:, 1) + dx, tsnePreR(:, 2) + dy, rLabels)
    figure(6); gscatter(tsnePostR(:, 1), tsnePostR(:, 2), rId, [], [], 20)
    %text(tsnePostR(:, 1) + dx, tsnePostR(:, 2) + dy, rLabels)
else
    noDims = 2;
    noInitDims = 50;
    perplexity = 5;

    tsnePre = tsne([uniqPreP; uniqPreS; uniqPreR], [], noDims, noInitDims, perplexity);
    tsnePost = tsne([uniqPostP; uniqPostS; uniqPostR], [], noDims, noInitDims, perplexity);

    labels = [pLabels, sLabels, rLabels];
    groups = [ones(length(pLabels), 1); ...
            2 * ones(length(sLabels), 1); ...
            3 * ones(length(rLabels), 1)];

    % Displacement for points
    dx = 0.1; dy = 0.1;
    figure(7); gscatter(tsnePre(:, 1), tsnePre(:, 2), groups)
    text(tsnePre(:, 1) + dx, tsnePre(:, 2) + dy, labels)
    figure(8); gscatter(tsnePost(:, 1), tsnePost(:, 2), groups)
    text(tsnePost(:, 1) + dx, tsnePost(:, 2) + dy, labels)
end
