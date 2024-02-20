process CONVERT_LOOM {
    tag "$meta"

    label 'process_single'

    publishDir "$loom_out_dir", mode: params.publish_dir_mode

    // conda "python=3.8.3 pandas"
    // uncomend this if you don't have the env locally or build it and specify the path below
    // conda "$baseDir/assets/env.yml"
    conda "/home/fotakis/.conda/envs/velocyto/"

    input:
    tuple val(meta), path(loom_file)
    path(loom_out_dir)

    output:
    path("*/*.loom")

    script:
    // out_dir = params.custom_loom_dir
    """
    prep_scvelo_input.py \\
    --input $loom_file \\
    --sample_id $meta \\
    --out_dir $loom_out_dir
    """
}