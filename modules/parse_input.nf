process PARSE_INPUT {
    tag "$input_csv"

    label 'process_single'

    conda "python=3.8.3 pandas"
    
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