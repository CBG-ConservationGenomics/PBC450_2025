#!/bin/sh                                                                                                                                                                             \
                                                                                                                                                                                       
############################################################################################                                                                                           
# pipeline for processing nanopore metagenomic reads from soil with epi2me metagenomics wf #                                                                                           
#                                                                                          #                                                                                           
# usage:  ./run_metgen.sh  $basedir                                                        #                                                                                           
#                                                                                          #                                                                                           
# author: Suzy Strickler susan.strickler@northwestern.edu                                  #                                                                                           
############################################################################################                                                                                           

# 1. Basecall the pod5 files on lovelace (this was done for you)                                                                                                                       
#dorado basecaller --emit-fastq -x cuda:all hac . > calls.fastq                                                                                                                        

# 2. Demultiplex the data using the sequence barcodes (this was done for you)                                                                                                          
#dorado demux --kit-name SQK-RBK114-24  --output-dir demux  --emit-fastq calls.fastq                                                                                                   

# 3. Make a dir for the data and analyses and copy the data to it                                                                                                                      
cd ~/PBC450_2025/
cp -r /home/general/Classes/PBC450/2025/soil_metagenomics/ .

# 4. Install Nanoplot for QC of reads                                                                                                                                                  
pip install NanoPlot --upgrade

# Add conda executables to PATH by editing the .bashrc file                                                                                                                            
emacs ~/.bashrc
# Add this to bottom of file: export PATH=$PATH:/home/[your_netid]/.local/bin/                                                                                                         
source ~/.bashrc #activates the changes                                                                                                                                                

# Get the proper version of some python packages                                                                                                                                       
pip uninstall numpy
pip install "numpy==1.22.4"

pip uninstall pandas
pip install pandas

# 5. Run Nanoplot on the unclassified reads                                                                                                                                            
cd soil_metagenomics/20251107_1254_MN29288_FBE86142_e0306a7f/pod5/demux/
NanoPlot -o e0306a7f-0f47-436a-bfef-23e64d0532f5_unclassified_np --fastq e0306a7f-0f47-436a-bfef-23e64d0532f5_unclassified.fastq

# 6. Run epi2me wf-metagenomics pipeline, this uses nextflow                                                                                                                           
nextflow run epi2me-labs/wf-metagenomics --fastq e0306a7f-0f47-436a-bfef-23e64d0532f5_unclassified.fastq --out_dir e0306a7f-0f47-436a-bfef-23e64d0532f5_unclassified_metagen

