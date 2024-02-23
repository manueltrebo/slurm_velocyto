// #TODO: problematic - cannot define output dir
process RUN_VELO_10X {
    tag "$meta"

    label 'process_medium'

    publishDir "$out_dir", mode: params.publish_dir_mode
    
    // Run only if velocyto is not installed locally
    // uncomend this if you don't have the env locally or build it and specify the path below
    // conda "$baseDir/assets/env.yml"
    conda "/home/fotakis/.conda/envs/velocyto/"

    input:
    tuple val(meta), path(cellrenger_out_dir)
    path(transcriptome)
    path(repeats)
    val(samtools_threads)

    output:
    path("*")
    tuple val(meta), path("*/*.loom"), emit: ch_loom

    script:
    out_dir = "$bam_path/"
    
    """
    velocyto run10x -m $repeats \\
                -@ $samtools_threads \\
                $cellrenger_out_dir \\
                $transcriptome
    """
}               