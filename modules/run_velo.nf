process RUN_VELO {
    tag "$meta"

    label 'process_medium'

    publishDir "$out_dir", params.publish_dir_mode

    // Run only if velocyto is not installed locally
    // conda "../assets/env.yml"
    
    input:
    tuple val(meta), path(input_bam)
    path(transcriptome)
    path(repeats)
    val(samtools_threads)
    val(samtools_mem)
    path(out_dir)

    output:
    path("*")

    script:
    """
    velocyto run -m $repeats \\
                --samtools-threads $samtools_threads \\
                --samtools-memory $samtools_mem \\
                -o ./$meta \\
                $input_bam \\
                $transcriptome
    """
}