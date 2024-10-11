process RUN_VELO_BD {
    // errorStrategy 'ignore'
    tag "$meta"

    label 'process_medium'

    publishDir "$out_dir", mode: params.publish_dir_mode

    // Run only if velocyto is not installed locally
    // uncomend this if you don't have the env locally or build it and specify the path below
    // conda "$baseDir/assets/env.yml"
    conda "/home/q089mt/.conda/envs/velocyto/"

    input:
    tuple val(meta), path(input_bam), path(input_bcl)
    path(transcriptome)
    path(repeats)
    val(samtools_threads)
    val(out_dir)
    // skipped - returns error
    // val(samtools_mem)

    output:
    path("velocyto/*.loom")
    tuple val(meta), path("velocyto/*.loom"), emit: ch_loom

    script:
    """
    cat \\
        <(samtools view -HS $input_bam) \\
        <(samtools view $input_bam | grep "MA:Z:*"  | sed  "s/MA:Z:/UB:Z:/" ) | \\
    samtools view -Sb -@6 > ${input_bam.baseName}.for_velocyto.bam

    velocyto run -b $input_bcl \\
                -m $repeats \\
                --samtools-threads $samtools_threads \\
                ${input_bam.baseName}.for_velocyto.bam \\
                $transcriptome
    """
}
