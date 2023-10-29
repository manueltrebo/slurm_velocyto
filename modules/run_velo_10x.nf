// #TODO: problematic - cannot define output dir
process RUN_VELO_10X {
    tag "$meta.id"

    conda "../assets/env.yml"
    
    input:
    tuple val(meta), path(alevin_results)

    output:


    script:
    """
    velocyto run10x -m $repeats \\
                -@ 10 \\
                $dataDir \\
                $transcriptome
    """
}