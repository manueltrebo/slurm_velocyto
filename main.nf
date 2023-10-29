#!/usr/bin/env nextflow

nextflow.enable.dsl=2

process velo {
    tag { dataDir.baseName }
    publishDir "/home/fotakis/myScratch/projects/Pircher/PCa_data/${dataDir.baseName}", mode: "copy"

    cpus 10
    conda "/home/fotakis/.conda/envs/scvelo"
    errorStrategy 'finish'

    input:
        path dataDir
        file repeats
        file transcriptome

    output:
        file("*.loom")

    script:
        """
        velocyto run10x -m $repeats \
                -@ 10 \
                $dataDir \
                $transcriptome
        """
}

workflow {
    dataDir = channel.of('/home/fotakis/myScratch/projects/Pircher/PCa_data/Pool1-P2n/', 
                        '/home/fotakis/myScratch/projects/Pircher/PCa_data/Pool1-P2t/', 
                        '/home/fotakis/myScratch/projects/Pircher/PCa_data/Pool1-P3n/', 
                        '/home/fotakis/myScratch/projects/Pircher/PCa_data/Pool1-P3t/', 
                        '/home/fotakis/myScratch/projects/Pircher/PCa_data/Pool1-P4n/', 
                        '/home/fotakis/myScratch/projects/Pircher/PCa_data/Pool1-P4t/')
    repeats = "/home/fotakis/myScratch/projects/Natalie/scVelo/hg38_rmsk.gtf"
    transcriptome="/data/databases/CellRanger/refdata-cellranger-GRCh38-3.0.0/genes/genes.gtf"
    velo(dataDir, repeats, transcriptome)
}
