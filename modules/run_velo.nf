process RUN_VELO {
    stageInMode 'copy'
    // errorStrategy 'ignore'
    tag "$meta"

    label 'process_medium'

    publishDir "$out_dir", mode: params.publish_dir_mode

    // Run only if velocyto is not installed locally
    // uncomend this if you don't have the env locally or build it and specify the path below
    // conda "$baseDir/assets/env.yml"
    conda "/home/fotakis/.conda/envs/velocyto/"

    input:
    tuple val(meta), path(input_bam), path(input_bcl)
    path(transcriptome)
    path(repeats)
    val(samtools_threads)
    val(out_dir)
    // skipped - returns error
    // val(samtools_mem)

    output:
    // path("velocyto/*.loom")
    tuple val(meta), path("velocyto/*.loom"), emit: ch_loom

    script:
    """
    zip -cdf $transcriptome > annotation.gtf
    
    velocyto run -b $input_bcl \\
                -m $repeats \\
                --samtools-threads $samtools_threads \\
                $input_bam \\
                annotation.gtf
    
    rm $repeats
    rm $input_bam
    rm $transcriptome
    rm annotation.gtf
    """
}
                