process RUN_VELO {
    tag "$meta"

    label 'process_medium'

    publishDir "$out_dir", params.publish_dir_mode

    // Run only if velocyto is not installed locally
    // uncomend this if you don't have the env locally or build it and specify the path below
    // conda "$baseDir/assets/env.yml"
    conda "/home/fotakis/.conda/envs/velocyto/"
    
    input:
    tuple val(meta), path(input_bam)
    path(transcriptome)
    path(repeats)
    val(samtools_threads)
    // skipped - returns error
    // val(samtools_mem)
    path(out_dir)

    output:
    path("*")

    script:
    """
    velocyto run -m $repeats \\
                --samtools-threads $samtools_threads \\
                -o ./$meta \\
                $input_bam \\
                $transcriptome
    """
}