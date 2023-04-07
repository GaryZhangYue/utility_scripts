# create symbolic files for the missing ones

for i in /data/NHLBI_IDSS/rawdata/NHLBI-75/bulkRNAseq/Flowcell_HK2KKDRX2/*Sample_*/*_R1*.fastq.gz; do p=${i##*/}; q=${p%_S*}; f=Symlinks/X${q}.R1.fastq.gz; if test ! -e "$f"; then echo $f; ln -s $i $f; echo "ln -s $i $f" >> links2.sh; fi; done | wc -l

for i in /data/NHLBI_IDSS/rawdata/NHLBI-75/bulkRNAseq/Flowcell_HK2KKDRX2/*Sample_*/*_R2*.fastq.gz; do p=${i##*/}; q=${p%_S*}; f=Symlinks/X${q}.R2.fastq.gz; if test ! -e "$f"; then echo $f; ln -s $i $f; echo "ln -s $i $f" >> links2.sh; fi; done | wc -l

# create symlink files to the current dir
for i in /data/NHLBI_IDSS/rawdata/NHLBI-75/Endotoxin-Neutrophil-Data/Suffredini_miRNA_Neutrophil_06h_Endotoxin_challenge/merged/*; do echo "ln -s $i ${i##*/}" >> create_symlinks.sh;ln -s $i ${i##*/}; done

# merge
# create a file list all samples
for i in *_L001_R1_001.fastq.gz; do echo $i | sed 's/_L001_R1_001.fastq.gz//'>> samplelist; done
# merge lanes for each sample
mkdir merged
while read -r i; do cat ${i}_L???_R1_001.fastq.gz > merged/${i}.R1.fastq.gz; echo "cat ${i}_L???_R1_001.fastq.gz > merged/${i}.R1.fastq.gz" >> merge.sh; done < samplelist
while read -r i; do cat ${i}_L???_R2_001.fastq.gz > merged/${i}.R2.fastq.gz; echo "cat ${i}_L???_R2_001.fastq.gz > merged/${i}.R2.fastq.gz" >> merge.sh; done < samplelist

# create symbolic links
cd symbolic/folder
for i in absolute/path/to/files/*; do ln -s $i ${i##*/}; echo "ln -s $i ${i##*/}" >> create_symlinks.sh; done



