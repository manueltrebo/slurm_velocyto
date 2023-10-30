// #TODO: problematic - cannot define output dir
process RUN_VELO_10X {
    tag "$meta"

    label 'process_medium'

    publishDir "$out_dir", params.publish_dir_mode
    
    // Run only if velocyto is not installed locally
    // conda "../assets/env.yml"

    input:
    tuple val(meta), path(cellrenger_out_dir)
    path(transcriptome)
    path(repeats)
    val(samtools_threads)

    output:
    path("*")

    script:
    """
    velocyto run10x -m $repeats \\
                -@ $samtools_threads \\
                $cellrenger_out_dir \\
                $transcriptome
    """
}