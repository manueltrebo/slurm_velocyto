process PARSE_INPUT {
    tag "$input_csv"

    label 'process_single'

    // conda "python=3.8.3 pandas"
    // uncomend this if you don't have the env locally or build it and specify the path below
    // conda "$baseDir/assets/env.yml"
    conda "/home/fotakis/.conda/envs/velocyto/"
    
    input:
    path(input_csv)

    output:
    path("sanitized_sample_sheet.csv"), emit: sample_sheet

    script:
    """
    parse_sample_sheet.py \\
    --input $input_csv \\
    --output ./sanitized_sample_sheet.csv
    """
}