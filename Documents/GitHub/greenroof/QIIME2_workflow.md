
# QIIME2 WORKFLOW

--------------
#### Paul Metzler
#### Chaudary Lab
--------------
Note: The Chaudhary Lab has a document called 'QIIME2 for absolute beginers', that you may want to check out. .qzv files can be visualized on the qiime2 [visualizer](https://view.qiime2.org/), other tutorials and helpful information can be found on the QIIME2 [website](https://qiime2.org/).

## Demultiplex summary

>qiime demux summarize \
  --i-data demux-GR.qza \
  --o-visualization demux-GR.qzv

## Denoising

>qiime dada2 denoise-paired \
  --i-demultiplexed-seqs demux.qza \
  --p-trunc-len-f 300 \
  --p-trunc-len-r 300 \
  --o-table tableR1.qza \
  --o-representative-sequences rep-seqsR1.qza \
  --o-denoising-stats denoising-statsR1.qza

>qiime feature-table summarize \
  --i-table tableR1.qza \
  --o-visualization tableR1.qzv \
  --m-sample-metadata-file sample-metadata.tsv

>qiime feature-table tabulate-seqs \
  --i-data rep-seqsR1.qza \
  --o-visualization rep-seqsR1.qzv

>qiime metadata tabulate \
  --m-input-file denoising-statsR1.qza \
  --o-visualization statsR1.qzv

## Denoising: ITS method

Because ITS is so variable in length, some
researchers choose to leave out truncation
lengths, each read is truncated based on
EE and quality of each read


>qiime dada2 denoise-paired \
 --i-demultiplexed-seqs demux.qza \
 --p-trunc-len-f 0 \
 --p-trunc-len-r 0 \
 --p-max-ee-f 3 \
 --p-max-ee-r 3 \
 --p-trunc-q 2 \
 --o-table tableEE3.qza \
 --o-representative-sequences rep-seqsEE3.qza \
 --o-denoising-stats denoising-statsEE3.qza

Now I'm trying it with only the GR samples

I had to edit the metadata outside of qiime and use the
filter-samples method. there's probably a better way

# Filtering samples (green roof only)

>qiime demux filter-samples \
 --i-demux demux.qza \
 --m-metadata-file sample-meta-GR.tsv \
 --o-filtered-demux demux-GR.qza

# Denoise GR & visualize

>qiime dada2 denoise-paired \
  --i-demultiplexed-seqs demux-GR.qza \
  --p-trunc-len-f 300 \
  --p-trunc-len-r 300 \
  --o-table tableGR.qza \
  --o-representative-sequences rep-seqsGR.qza \
  --o-denoising-stats denoising-statsGR.qza

>qiime feature-table summarize \
  --i-table tableGR.qza \
  --o-visualization tableGR.qzv \
  --m-sample-metadata-file sample-meta-GR.tsv

>qiime feature-table tabulate-seqs \
  --i-data rep-seqsGR.qza \
  --o-visualization rep-seqsGR.qzv

>qiime metadata tabulate \
  --m-input-file denoising-statsGR.qza \
  --o-visualization statsGR.qzv

## OR

>qiime dada2 denoise-paired \
 --i-demultiplexed-seqs demux-GR.qza \
 --p-trunc-len-f 0 \
 --p-trunc-len-r 0 \
 --p-max-ee-f 2 \
 --p-max-ee-r 2 \
 --p-trunc-q 2 \
 --o-table tableGREE2.qza \
 --o-representative-sequences rep-seqsGREE2.qza \
 --o-denoising-stats denoising-statsGREE2.qza

>qiime feature-table summarize \
  --i-table tableGREE2.qza \
  --o-visualization tableGREE2.qzv \
  --m-sample-metadata-file sample-meta-GR.tsv

>qiime feature-table tabulate-seqs \
  --i-data rep-seqsGREE2.qza \
  --o-visualization rep-seqsGREE2.qzv

>qiime metadata tabulate \
  --m-input-file denoising-statsGREE2.qza \
  --o-visualization statsGREE2.qzv


# Creating an OTU table

I couldnt figure out how to do this in qiime2. that doesnt mean there isnt a way
first, export your feature table as a .biom file

>qiime tools export \
--input-path tableGR.qza \
--output-path exported-feature-table

it creates a folder that contains the file feature-table.biom
convert that file to a .tsv file where the name of the column that containts the
sample names is supplied next to the --header-key command

>biom convert \
-i exported-feature-table/feature-table.biom \
-o otu_tableGR.csv \
--to-tsv \
--header-key sample

you open the .csv file. you may need to use excels text to columns feature to finish the table
